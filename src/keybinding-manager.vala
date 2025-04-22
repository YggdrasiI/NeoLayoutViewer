/* vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab */
// modules: X

using X;

namespace NeoLayoutViewer {

	/**
	 * Modification of http://www.linux-nantes.org/~fmonnier/ocaml/Xlib/doc/Xlib.html by
	 * Oliver Sauder <os@esite.ch>
	 */
	public class KeybindingManager : GLib.Object {

		private NeoWindow neo_win;

		/**
		 * list of binded keybindings
		 */
		private Gee.List<Keybinding> bindings = new Gee.ArrayList<Keybinding>();

		/**
		 * locked modifiers used to grab all keys whatever lock key
		 * is pressed.
		 */
		private static uint[] lock_modifiers = {
			0,
			Gdk.ModifierType.MOD2_MASK, // NUM_LOCK
			Gdk.ModifierType.LOCK_MASK, // CAPS_LOCK
			Gdk.ModifierType.MOD5_MASK, // SCROLL_LOCK
			Gdk.ModifierType.MOD2_MASK|Gdk.ModifierType.LOCK_MASK,
			Gdk.ModifierType.MOD2_MASK|Gdk.ModifierType.MOD5_MASK,
			Gdk.ModifierType.LOCK_MASK|Gdk.ModifierType.MOD5_MASK,
			Gdk.ModifierType.MOD2_MASK|Gdk.ModifierType.LOCK_MASK|Gdk.ModifierType.MOD5_MASK
		};

		private int modifier_keycodes[10];
		private int modifier_pressed[10];

		/**
		 * Helper class to store keybinding
		 */
		private class Keybinding {

			public Keybinding(string accelerator, int keycode, Gdk.ModifierType modifiers, KeybindingHandlerFunc handler) {
				this.accelerator = accelerator;
				this.keycode = keycode;
				this.modifiers = modifiers;
				this.handler = handler;
			}

			public string accelerator { get; set; }
			public int keycode { get; set; }
			public Gdk.ModifierType modifiers { get; set; }
			public unowned KeybindingHandlerFunc handler { get; set; }
		}

		/**
		 * Keybinding func needed to bind key to handler
		 *
		 * @param event passing on gdk event
		 */
		public delegate void KeybindingHandlerFunc(Gdk.Event event);

		public KeybindingManager(NeoWindow neo_win) {
			this.neo_win = neo_win;

			// init filter to retrieve X.Events
			unowned Gdk.Window rootwin = Gdk.get_default_root_window();

			if (rootwin != null) {

				rootwin.add_filter(event_filter);

				unowned X.Display display = Gdk.X11.get_default_xdisplay();

				modifier_keycodes[0] = display.keysym_to_keycode(XK_Shift_L);
				modifier_keycodes[1] = display.keysym_to_keycode(XK_Shift_R);
				modifier_keycodes[2] = 66; //Mod3L can differ?!
				modifier_keycodes[3] = 51; //Mod3R
				modifier_keycodes[4] = 94; //Mod4L
				modifier_keycodes[5] = 108;//Mod4R
				modifier_keycodes[6] = display.keysym_to_keycode(XK_Control_L);
				modifier_keycodes[7] = display.keysym_to_keycode(XK_Control_R);
				modifier_keycodes[8] = display.keysym_to_keycode(XK_Alt_L);
				modifier_keycodes[9] = display.keysym_to_keycode(XK_Alt_R);

				Timeout.add(100, modifier_timer);

			}
		}

		/**
		 * Bind accelerator to given handler
		 *
		 * @param accelerator accelerator parsable by Gtk.accelerator_parse
		 * @param handler handler called when given accelerator is pressed
		 */
		public void bind(string accelerator, KeybindingHandlerFunc handler) {

			debug("Binding key " + accelerator);

			// convert accelerator
			uint keysym;
			Gdk.ModifierType modifiers;
			Gtk.accelerator_parse(accelerator, out keysym, out modifiers);

			unowned X.Display display = Gdk.X11.get_default_xdisplay();
			int keycode = display.keysym_to_keycode(keysym);

			if (keycode != 0) {
				X.Window root_window = Gdk.X11.get_default_root_xwindow();

				// trap XErrors to avoid closing of application
				// even when grabing of key fails
				Gdk.error_trap_push();

				// grab key finally
				// also grab all keys which are combined with a lock key such NumLock
				foreach (uint lock_modifier in lock_modifiers) {
					display.grab_key(keycode, modifiers|lock_modifier, root_window, false, X.GrabMode.Async, X.GrabMode.Async);
				}

				// wait until all X request have been processed
				Gdk.flush();

				// store binding
				Keybinding binding = new Keybinding(accelerator, keycode, modifiers, handler);
				bindings.add(binding);

				debug("Successfully bound key " + accelerator);
			}
		}

		/**
		 * Unbind given accelerator.
		 *
		 * @param accelerator accelerator parsable by Gtk.accelerator_parse
		 */

		public void unbind(string accelerator) {
			debug("Unbinding key " + accelerator);

			unowned X.Display display = Gdk.X11.get_default_xdisplay();
			X.Window root_window = Gdk.X11.get_default_root_xwindow();

			// unbind all keys with given accelerator
			Gee.List<Keybinding> remove_bindings = new Gee.ArrayList<Keybinding>();

			foreach (Keybinding binding in bindings) {

				if (str_equal(accelerator, binding.accelerator)) {

					foreach (uint lock_modifier in lock_modifiers) {
						display.ungrab_key(binding.keycode, binding.modifiers, root_window);
					}

					remove_bindings.add(binding);
				}
			}

			// remove unbinded keys
			bindings.remove_all(remove_bindings);
		}


		/**
		 * Event filter method needed to fetch X.Events
		 */
		private Gdk.FilterReturn event_filter(Gdk.XEvent gdk_xevent, Gdk.Event gdk_event) {
			Gdk.FilterReturn filter_return = Gdk.FilterReturn.CONTINUE;
#if VALA_0_16 || VALA_0_17
			X.Event* xevent = (X.Event*) gdk_xevent;
#else
			void* pointer = &gdk_xevent;
			X.Event* xevent = (X.Event*) pointer;
#endif

			if (xevent->type == X.EventType.KeyPress) {

				foreach (Keybinding binding in bindings) {
					// remove NumLock, CapsLock and ScrollLock from key state
					uint event_mods = xevent.xkey.state & ~ (lock_modifiers[7]);

					if (xevent->xkey.keycode == binding.keycode && event_mods == binding.modifiers) {
						// call all handlers with pressed key and modifiers
						binding.handler(gdk_event);
					}
				}
			}

			return filter_return;
		}

		/*
			 Checks periodically which modifier are pressed.
		 */
		private bool modifier_timer() {
			unowned X.Display display = Gdk.X11.get_default_xdisplay();

			checkModifier(display, &modifier_keycodes[0], modifier_keycodes.length, &modifier_pressed[0]);

			/* Verallgemeinerung von checkCapsLock:
			 * 1. Bit: caps lock
			 * 2. Bit: mod4 lock
			 */
			uint lock_flags = checkIndicatorStates(display);
			int shift_lock = (int)(lock_flags & 0x1);
			int mod4_lock = (int)(lock_flags & 0x2);

			// Convert modifier keys to modifier/layer
			neo_win.change_active_modifier(1, true,
					(int)(modifier_pressed[0] | modifier_pressed[1] != shift_lock) );
			neo_win.change_active_modifier(2, true,
					(int)(modifier_pressed[2] | modifier_pressed[3]));
			neo_win.change_active_modifier(3, true,
					(int)(modifier_pressed[4] | modifier_pressed[5] != mod4_lock) );
			neo_win.change_active_modifier(4, true,
					(int)(modifier_pressed[6] | modifier_pressed[7]));
			neo_win.change_active_modifier(5, true,
					(int)(modifier_pressed[8] | modifier_pressed[9]));

			neo_win.redraw();

			return true;
		}
	}// End KeybindingManager class


}// End Namespace
