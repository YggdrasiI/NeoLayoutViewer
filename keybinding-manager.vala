namespace NeoLayoutViewer{
	/**
	 * Modification of http://www.linux-nantes.org/~fmonnier/ocaml/Xlib/doc/Xlib.html by
	 * Oliver Sauder <os@esite.ch>
	 */
	public class KeybindingManager : GLib.Object
	{
		private NeoWindow neo_win;
		/**
		 * list of binded keybindings
		 */
		private Gee.List<Keybinding> bindings = new Gee.ArrayList<Keybinding>();
		private Gee.List<ModifierKeybinding> modifier_bindings = new Gee.ArrayList<ModifierKeybinding>();
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


		/**
		 * Helper class to store keybinding
		 */
		private class Keybinding
		{
			public Keybinding(string accelerator, int keycode,
					Gdk.ModifierType modifiers, KeybindingHandlerFunc handler)
			{
				this.accelerator = accelerator;
				this.keycode = keycode;
				this.modifiers = modifiers;
				this.handler = handler;
			}

			public string accelerator { get; set; }
			public int keycode { get; set; }
			public Gdk.ModifierType modifiers { get; set; }
			public KeybindingHandlerFunc handler { get; set; }
		}


		/**
		 * Helper class to store second set of keybindings (modifier)
		 */
		private class ModifierKeybinding
		{
			public ModifierKeybinding(string accelerator, int keycode,
					Gdk.ModifierType modifiers, int ebene, KeybindingHandlerFunc handler)
			{
				this.accelerator = accelerator;
				this.keycode = keycode;
				this.ebene = ebene;
				this.modifiers = modifiers;
				this.handler = handler;
			}

			public string accelerator { get; set; }
			public int keycode { get; set; }
			public int ebene { get; set; }
			public Gdk.ModifierType modifiers { get; set; }
			public KeybindingHandlerFunc handler { get; set; }
		}

		/**
		 * Keybinding func needed to bind key to handler
		 *
		 * @param event passing on gdk event
		 */
		public delegate void KeybindingHandlerFunc(Gdk.Event event);

		public KeybindingManager(NeoWindow neo_win)
		{
			this.neo_win = neo_win;
			// init filter to retrieve X.Events
			Gdk.Window rootwin = Gdk.get_default_root_window();
			if(rootwin != null) {
				rootwin.add_filter(event_filter);
			}


			//some tests
			/*
				 X.Display display = Gdk.x11_drawable_get_xdisplay(rootwin);
				 X.ModifierKeymap modmap = display.get_modifier_mapping ();
				 debug("Max mod: %i\n".printf(modmap.max_keypermod));
				 for(int i=0; i<modmap.max_keypermod;i++){
				 debug(modmap.modifiermap[i].to_string()+"\n");
				 }*/

		}

		/**
		 * Bind accelerator to given handler
		 *
		 * @param accelerator accelerator parsable by Gtk.accelerator_parse
		 * @param handler handler called when given accelerator is pressed
		 */
		public void bind(string accelerator, KeybindingHandlerFunc handler)
		{
			//debug("Binding key " + accelerator);

			// convert accelerator
			uint keysym;
			Gdk.ModifierType modifiers;
			Gtk.accelerator_parse(accelerator, out keysym, out modifiers);

			Gdk.Window rootwin = Gdk.get_default_root_window();
			unowned X.Display display = Gdk.x11_drawable_get_xdisplay(rootwin);
			X.ID xid = Gdk.x11_drawable_get_xid(rootwin);
			int keycode = display.keysym_to_keycode(keysym);

			if(keycode != 0) {
				// trap XErrors to avoid closing of application
				// even when grabing of key fails
				Gdk.error_trap_push();

				// grab key finally
				// also grab all keys which are combined with a lock key such NumLock
				foreach(uint lock_modifier in lock_modifiers) {
					display.grab_key(keycode, modifiers|lock_modifier, xid, false, X.GrabMode.Async, X.GrabMode.Async);
				}

				// wait until all X request have been processed
				Gdk.flush();

				// store binding
				Keybinding binding = new Keybinding(accelerator, keycode, modifiers, handler);
				bindings.add(binding);

				//debug("Successfully binded key " + accelerator);
			}
		}


		public void bind2(int keycode, string accelerator, int ebene, KeybindingHandlerFunc handler)
		{

			// convert accelerator
			/*uint keysym;
				Gdk.ModifierType modifiers;
				Gtk.accelerator_parse(accelerator, out keysym, out modifiers);*/

			Gdk.Window rootwin = Gdk.get_default_root_window();
			unowned X.Display display = Gdk.x11_drawable_get_xdisplay(rootwin);
			X.ID xid = Gdk.x11_drawable_get_xid(rootwin);
			//int keycode = display.keysym_to_keycode(keysym);

			if(keycode != 0) {
				// trap XErrors to avoid closing of application
				// even when grabing of key fails
				Gdk.error_trap_push();

				// grab key finally
				display.grab_key(keycode, 0, xid, false, X.GrabMode.Async, X.GrabMode.Async);

				// wait until all X request have been processed
				Gdk.flush();

				// store binding
				ModifierKeybinding binding = new ModifierKeybinding(accelerator, keycode, 0, ebene, handler);
				modifier_bindings.add(binding);

				//debug("Successfully binded key ");
			}
		}


		/**
		 * Unbind given accelerator.
		 *
		 * @param accelerator accelerator parsable by Gtk.accelerator_parse
		 */

		public void unbind(string accelerator)
		{
			//debug("Unbinding key " + accelerator);

			Gdk.Window rootwin = Gdk.get_default_root_window();
			unowned X.Display display = Gdk.x11_drawable_get_xdisplay(rootwin);
			X.ID xid = Gdk.x11_drawable_get_xid(rootwin);

			// unbind all keys with given accelerator
			Gee.List<Keybinding> remove_bindings = new Gee.ArrayList<Keybinding>();
			foreach(Keybinding binding in bindings) {
				if(str_equal(accelerator, binding.accelerator)) {
					foreach(uint lock_modifier in lock_modifiers) {
						display.ungrab_key(binding.keycode, binding.modifiers, xid);
					}
					remove_bindings.add(binding);
				}
			}
			// remove unbinded keys
			bindings.remove_all(remove_bindings);
		}


		public void unbind2(int keycode)
		{
			//debug("Unbinding key\n ");

			Gdk.Window rootwin = Gdk.get_default_root_window();
			unowned X.Display display = Gdk.x11_drawable_get_xdisplay(rootwin);
			X.ID xid = Gdk.x11_drawable_get_xid(rootwin);

			// unbind all keys with given accelerator
			Gee.List<ModifierKeybinding> remove_bindings = new Gee.ArrayList<ModifierKeybinding>();
			foreach(ModifierKeybinding binding in modifier_bindings) {
				if(keycode == binding.keycode) {
					display.ungrab_key(binding.keycode, binding.modifiers, xid);
					remove_bindings.add(binding);
				}
			}
			// remove unbinded keys
			bindings.remove_all(remove_bindings);
		}



		/**
		 * Event filter method needed to fetch X.Events
		 */
		public Gdk.FilterReturn event_filter(Gdk.XEvent gdk_xevent, Gdk.Event gdk_event)
		{
			Gdk.FilterReturn filter_return = Gdk.FilterReturn.CONTINUE;
			//Gdk.FilterReturn filter_return = Gdk.FilterReturn.REMOVE;

			void* pointer = &gdk_xevent;
			X.Event* xevent = (X.Event*) pointer;

			if(xevent->type == X.EventType.KeyPress) {
				foreach(Keybinding binding in bindings) {
					// remove NumLock, CapsLock and ScrollLock from key state
					uint event_mods = xevent.xkey.state & ~ (lock_modifiers[7]);
					if(xevent->xkey.keycode == binding.keycode && event_mods == binding.modifiers) {
						// call all handlers with pressed key and modifiers
						binding.handler(gdk_event);
					}
				}
			}

			if(xevent->type == X.EventType.KeyPress) {
				uint event_mods = xevent.xkey.state;
				foreach(ModifierKeybinding binding in modifier_bindings) {
					if(xevent->xkey.keycode == binding.keycode) {
						//neo_win.external_key_press(binding.ebene,(int)event_mods);
						neo_win.active_modifier[binding.ebene] = 1;
						neo_win.redraw();
						// call all handlers with pressed key and modifiers
						binding.handler(gdk_event);
						//send_event_again(Gdk.get_default_root_window(), binding, *xevent);
					}
				}
			}

			if(xevent->type == X.EventType.KeyRelease) {
				uint event_mods = xevent.xkey.state;

				foreach(ModifierKeybinding binding in modifier_bindings) {
					if(xevent->xkey.keycode == binding.keycode) {
						//neo_win.external_key_release(0,(int)event_mods);
						neo_win.active_modifier[binding.ebene] = 0;
						neo_win.redraw();
						// call all handlers with pressed key and modifiers
						binding.handler(gdk_event);
						//send_event_again(Gdk.get_default_root_window(), binding, *xevent);
					}
				}
			}


			debug("Filter %u\n".printf(xevent.xkey.keycode));

			send_event_again(Gdk.get_default_root_window(), *xevent);

			return filter_return;
		}


		private void send_event_again(Gdk.Window rootwin, X.Event xevent){

			if(rootwin != null) {
				unowned X.Display display = Gdk.x11_drawable_get_xdisplay(rootwin);
				X.ID xid = Gdk.x11_drawable_get_xid(rootwin);
				foreach(ModifierKeybinding binding in modifier_bindings){
					display.ungrab_key(binding.keycode, binding.modifiers, xid);
				}

				//rootwin.remove_filter(event_filter);
				debug("Send Event again %u\n".printf(xevent.xkey.state));
				display.send_event(xevent.xkey.window,true,xevent.xkey.state,ref xevent);
				//rootwin.add_filter(event_filter);

				foreach(ModifierKeybinding binding in modifier_bindings){
					//	display.grab_key(binding.keycode, 0, xid, false, X.GrabMode.Async, X.GrabMode.Async);
				}
			}

		}

	}
}
