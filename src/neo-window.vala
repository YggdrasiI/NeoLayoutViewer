/* vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab */
// modules: Gtk Gdk X Posix

using Gtk;
using Gdk;
using X; //keysym.h
using Posix; //system-calls
using Cairo;

namespace NeoLayoutViewer {

	errordomain PositionArrayParsingError {
		CODE_1A
	}

	public class Modkey {
		public Gtk.Image modKeyImage;
		public int modifier_index;
		public int active;

		public Modkey(Gtk.Image i, int m) {
			this.modKeyImage = i;
			this.modifier_index = m;
			this.active = 0;
		}

		public void change (int new_state) {
			if (new_state == this.active) return;
			this.active = new_state;
			if (this.active == 0) {
				modKeyImage.hide();
			} else {
				modKeyImage.show();
			}
		}
	}

	public class NeoWindow : Gtk.ApplicationWindow {

		private ScalingImage image;

#if _NO_WIN
		private KeyOverlay key_overlay;
#endif

		public Gee.Map<string, Gdk.Pixbuf> image_buffer;
		private Gdk.Pixbuf[] layer_pixbufs;
		private int monitor_id = -1;
		private Gee.Map<int, Size> size_for_monitor;

		public Gee.List<Modkey> modifier_key_images; // for modifier which didn't toggle a layout layer. I.e. ctrl, alt.
		public Gee.Map<string, string> config;

		public bool fix_layer = false;
		private int _layer = 1;
		public int layer {
			get { return _layer; }
			set { if (value < 1 || value > 6) { _layer = 1; } else { _layer = value; } }
		}
		public int[] active_modifier_by_keyboard;
		public int[] active_modifier_by_mouse;
		public int numpad_width;
		public int function_keys_height;
		private bool minimized;
		private int position_num;
		private int[] position_cycle;
		private int position_on_hide_x;
		private int position_on_hide_y;
		private int screen_dim[2];
		private bool screen_dim_auto[2]; //if true, x/y screen dimension will detect on every show event.
		private bool already_shown_on_monitor1;  // flag to prevent first hide()-call during monitor cycle in some cases.

		/* Die Neo-Modifier unterscheiden sich zum Teil von den Normalen, für die Konstanten definiert sind. Bei der Initialisierung werden aus den Standardkonstanen die Konstanten für die Ebenen 1-6 berechnet.*/
		public int[] NEO_MODIFIER_MASK;
		public int[] MODIFIER_MASK;

		/* Falls ein Modifier (oder eine andere Taste) gedrückt wird und schon Modifier gedrückt sind, gibt die Map an, welche Ebene dann aktiviert ist. */
		private short[,] MODIFIER_MAP = {
			{0, 1, 2, 3, 4, 5},
			{1, 1, 4, 3, 4, 5},
			{2, 4, 2, 5, 4, 5},
			{3, 3, 5, 3, 4, 5} };

		/* [0, 1]^3->{0, 5}, Bildet aktive Modifier auf angezeigte Ebene ab.
			 Interpretationsreihenfolge der Dimensionen: Shift, Neo-Mod3, Neo-Mod4. */
		private short[,,] MODIFIER_MAP2 = {
			{ {0 , 3}, {2 , 5 } },  // 000, 001; 010, 011
			{ {1 , 3}, {4 , 5}}	  // 100, 101; 110, 111
		};

		/* {0, 5} -> [0, 1]^3 */
		private short[,] LAYER_TO_MODIFIERS = {
			{0 , 0, 0}, // 0
			{1 , 0, 0}, // 1
			{0 , 1, 0}, // 2
			{0 , 0, 1}, // 3
			{1 , 1, 0}, // 4
			{1 , 1, 1}  // 5
		};

		/* Analog zu oben für den Fall, dass eine Taste losgelassen wird. Funktioniert nicht immer.
			 Ist beispielsweise ShiftL und ShiftR gedrückt und eine wird losgelassen, so wechselt die Anzeige zur ersten Ebene.
			 Die Fehler sind imo zu vernachlässigen.
		 */
		private short[,] MODIFIER_MAP_RELEASE = {
			{0, 0, 0, 0, 0, 0},
			{0, 0, 2, 3, 2, 5},
			{0, 1, 0, 3, 1, 3},
			{0, 1, 2, 0, 4, 2} };

		/*
			 Modifier können per Tastatur und Maus aktiviert werden. Diese Abbildung entscheidet,
			 wie bei einer Zustandsänderung verfahren werden soll.
			 k, m, K, M ∈ {0, 1}.
			 k - Taste wurde gedrückt gehalten
			 m - Taste wurde per Mausklick selektiert.
			 K - Taste wird gedrückt
			 M - Taste wird per Mausklick selektiert.

			 k' = f(k, m, K, M). Und wegen der Symmetrie(!)
			 m' = f(m, k, M, K)
			 Siehe auch change_active_modifier(…).
		 */
		private short[,,,] MODIFIER_KEYBOARD_MOUSE_MAP = {
			//		 k		=				f(k, m, K, M, ) and m = f(m, k, M, K)
			{ { {0, 0} , {1, 0} } ,  // 0000, 0001; 0010, 0011;
				{ {0, 0} , {1, 1} } }, // 0100, 0101; 0110, 0111(=swap);
			{ { {0, 0} , {1, 0} } , //1000, 1001; 1010, 1011(=swap);
				{ {0, 0} , {1, 1} } }//1100, 1101; 1110, 1111; //k=m=1 should be impossible
		};

		public NeoWindow (NeoLayoutViewerApp app) {
			this.config = app.configm.getConfig();
			this.minimized = true;

			/* Set window type to let tiling window manager, i.e. i3-wm,
			 * the chance to float the window automatically.
			 */
			this.type_hint = Gdk.WindowTypeHint.UTILITY;

			this.NEO_MODIFIER_MASK = {
				0,
				Gdk.ModifierType.SHIFT_MASK, //1
				Gdk.ModifierType.MOD5_MASK+Gdk.ModifierType.LOCK_MASK, //128+2
				Gdk.ModifierType.MOD3_MASK, //32
				Gdk.ModifierType.MOD5_MASK+Gdk.ModifierType.LOCK_MASK+Gdk.ModifierType.SHIFT_MASK, //128+2+1
				Gdk.ModifierType.MOD5_MASK+Gdk.ModifierType.LOCK_MASK+Gdk.ModifierType.MOD3_MASK //128+2+32
			};
			this.MODIFIER_MASK = {
				0,
				Gdk.ModifierType.SHIFT_MASK, //1
				Gdk.ModifierType.MOD5_MASK, //128
				Gdk.ModifierType.MOD3_MASK, //32
				Gdk.ModifierType.CONTROL_MASK,
				Gdk.ModifierType.MOD1_MASK // Alt-Mask do not work :-(
			};
			this.active_modifier_by_keyboard = {0, 0, 0, 0, 0, 0};
			this.active_modifier_by_mouse = {0, 0, 0, 0, 0, 0};

			this.modifier_key_images = new Gee.ArrayList<Modkey>();
			this.position_num = int.min(200, int.max(int.parse(this.config.get("position")), 1));
			this.already_shown_on_monitor1 = ( this.position_num < 10
					&& this.config.get("show_on_startup") != "0");
			this.size_for_monitor = new Gee.HashMap<int, Size>();
			this.check_resize.connect(main_resized);

			//Anlegen des Arrays, welches den Positionsdurchlauf beschreibt.
			try {
				//var space = new Regex(" ");
				//string[] split = space.split(this.config.get("position_cycle"));
				var non_numeral = new Regex("[^0-9]+");
				string[] split = non_numeral.split(this.config.get("position_cycle"));

				/* Create array which can hold the parsed integers, but also some
					 unused indizes (0th. entry, 10th entry, …)
				 */
				var min_len = ((position_num-1)/10 + 1)*10;
				position_cycle = new int[int.max(min_len, ( (split.length-1)/10 + 1)*10)]; // multiple of 10 and > 0

				GLib.assert( position_cycle.length/10 >= split.length/9 );

				// Prefill with default values. Call is not redundant!
				debug(@"Cycle array length: $(position_cycle.length)");
				fill_position_cycle_default(ref position_cycle);

				// Read positions from config string
				int j = 1;
				//position_cycle[0] = -1;  // already set in fill_position_cycle_default(...)
				for (int i = 0;i < split.length; i++) {
					// Valid range: [1, 10*number_of_monitors - 1]
					position_cycle[j] = int.max(int.min(int.parse(split[i]), position_cycle.length-1), 1);

					if (position_cycle[j] == 0) {
						// Invalid number parsed (or parsing failed). Print error message and use predefined array
						GLib.stdout.printf("Position cycle reading failed. Problematic value: $(split[i])\n");
						throw new PositionArrayParsingError.CODE_1A("Unexpected Integer");
					}
					GLib.assert( position_cycle[j] > 0 );

					j++;
					if (j%10 == 0) { j++; }
				}
			} catch (PositionArrayParsingError e) {
				fill_position_cycle_default(ref position_cycle);
			} catch (RegexError e) {
				fill_position_cycle_default(ref position_cycle);
			}

			debug("Position cycle map:");
			for (int i = 0;i < position_cycle.length; i++) {
				debug(@"$(i)=> $(position_cycle[i])");
			}

			if (app.start_layer > 0) {
				this.fix_layer = true;
				this.layer = app.start_layer;
				this.active_modifier_by_mouse[1] = this.LAYER_TO_MODIFIERS[this.layer-1, 0];
				this.active_modifier_by_mouse[2] = this.LAYER_TO_MODIFIERS[this.layer-1, 1];
				this.active_modifier_by_mouse[3] = this.LAYER_TO_MODIFIERS[this.layer-1, 2];
			}

			// Crawl dimensions of screen/display/monitor
			// Should be done before load_images() is called.
			screen_dim_auto[0] = (this.config.get("screen_width") == "auto");
			screen_dim_auto[1] = (this.config.get("screen_height") == "auto");

			if (screen_dim_auto[0]) {
				this.screen_dim[0] = this.get_screen_width();
				this.screen_dim_auto[0] = false; // Disables further re-evaluations
			} else {
				this.screen_dim[0] = int.max(1, int.parse(this.config.get("screen_width")));
			}

			if (screen_dim_auto[1]) {
				this.screen_dim[1] = this.get_screen_height();
				this.screen_dim_auto[1] = false; // Disables further re-evaluations
			} else {
				this.screen_dim[1] = int.max(1, int.parse(this.config.get("screen_height")));
			}

			// Load pngs of all six layers, etc
			this.image_buffer =  new Gee.HashMap<string, Gdk.Pixbuf>();
			this.load_images();

			this.layer_pixbufs = {
				this.image_buffer["unscaled_1"],
				this.image_buffer["unscaled_2"],
				this.image_buffer["unscaled_3"],
				this.image_buffer["unscaled_4"],
				this.image_buffer["unscaled_5"],
				this.image_buffer["unscaled_6"],
			};

			// Setup background image.
			int backgroundW_unscaled = this.get_unscaled_width();
			int backgroundH_unscaled = this.get_unscaled_height();

			this.image = new ScalingImage(
					backgroundW_unscaled, backgroundH_unscaled,
					this, backgroundW_unscaled, backgroundH_unscaled,
					layer_pixbufs, 0);

			this.monitor_id = this.position_num / 10;

			// Setup startup size of window
			int win_width = get_image_width_for_monitor(this.screen_dim[0]);
			int win_height = (backgroundH_unscaled * win_width)/ backgroundW_unscaled;

			//this.set_size_request(1, 1);
			this.resize(win_width, win_height);
			this.set_default_size(win_width, win_height);

			image.show();
			var layout = new Layout();
			layout.put(this.image, 0, 0);

#if _NO_WIN
			this.key_overlay = new KeyOverlay(this);
			this.key_overlay.show();
			layout.put(this.key_overlay, 0, 0);
#endif

			add(layout);
			layout.show();

			//Fenstereigenschaften setzen
			this.key_press_event.connect(on_key_pressed);
			this.button_press_event.connect(on_button_pressed);
			this.destroy.connect(NeoLayoutViewer.quit);

			//this.set_gravity(Gdk.Gravity.SOUTH);
			this.decorated = (this.config.get("window_decoration") != "0");
			this.skip_taskbar_hint = true;

			//Icon des Fensters
			this.icon = this.image_buffer["icon"];

			//Nicht selektierbar (für virtuelle Tastatur)
			this.set_accept_focus((this.config.get("window_selectable") != "0"));

			if (this.config.get("show_on_startup") != "0") {
				//Move ist erst nach show() erfolgreich
				//this.numkeypad_move(int.parse(this.config.get("position")));
				this.numkeypad_move(this.position_num);
				this.show();
			} else {
				this.hide();
				//this.numkeypad_move(int.parse(this.config.get("position")));
				this.numkeypad_move(this.position_num);
			}

		}

		public override void show() {
			this.minimized = false;
			this.move(this.position_on_hide_x, this.position_on_hide_y);
			debug(@"Show window on $(this.position_on_hide_x), $(this.position_on_hide_y)\n");
			base.show();
			this.move(this.position_on_hide_x, this.position_on_hide_y);
			/* Second move fixes issue for i3-wm(?). The move() before show()
				 moves the current window as expected, but somehow does not propagate this values
				 correcty to the wm. => The next hide() call will fetch wrong values
				 and a second show() call plaes the window in the middle of the screen.
			 */

			if (this.config.get("on_top") == "1") {
				this.set_keep_above(true);
			} else {
				this.present();
			}
		}

		public override void hide() {
			//store current coordinates
			int tmpx;
			int tmpy;
			this.get_position(out tmpx, out tmpy);
			this.position_on_hide_x = tmpx;
			this.position_on_hide_y = tmpy;
			debug(@"Hide window on $(this.position_on_hide_x), $(this.position_on_hide_y)\n");

			this.minimized = true;
			base.hide();
		}

		public bool toggle() {
			if (this.minimized) show();
			else hide();
			return this.minimized;
		}

		public void numkeypad_move(int pos) {

			var display = Gdk.Display.get_default();
			//var screen = Gdk.Screen.get_default();
			var screen = display.get_default_screen();
			//var screen = this.get_screen();
			//var monitor = display.get_monitor_at_window(screen.get_active_window());

#if GTK_MAJOR_VERSION == 2 || GTK_MINOR_VERSION == 18 || GTK_MINOR_VERSION == 19 || GTK_MINOR_VERSION == 20 || GTK_MINOR_VERSION == 21
			// Old variant for ubuntu 16.04 (Glib version < 3.22)
			var n_monitors = screen.get_n_monitors();
#else
			var n_monitors = display.get_n_monitors(); // Könnte n_1+n_2+…n_k sein mit k Screens?!
#endif
			debug(@"Number of monitors: $(n_monitors)");

			GLib.assert(n_monitors > 0);

			// Automatic set of next position
			if ((pos%10) == 0) {
				/* Resolve next position */
				pos = this.position_cycle[this.position_num];
			}
			GLib.assert( (pos%10) > 0 );

			// Validate input for manual set of position.
			// Note that 'extra monitors', which are not respected in position_cycle, will be ignored.
			if (pos >= this.position_cycle.length) {
				pos %= 10;  // go back to first monitor
			}

			if (pos < 1) {
				GLib.stdout.printf(@"Positioning error! Can not handle $(pos). Fall back on pos=5.\n");
				pos = 5;
			}

			GLib.assert(pos >= 0);

			/* Positions supports multiple screens, now.
				 1-9 on monitor 0, 11-19 on monitor 1, …

				 This line shift indicies of non connected monitors to a available one.
			 */
			pos %= 10 * n_monitors;

			// Get monitor for this position
			int monitor_index = pos/10;
			GLib.assert(monitor_index >= 0);
			if (monitor_index >= n_monitors) {
				monitor_index %= n_monitors;
			}

			// Get the position within the monitor
			int pos_on_screen = pos % 10;

			Gdk.Rectangle monitor_rect_dest;
			screen.get_monitor_geometry(monitor_index, out monitor_rect_dest);

			debug(@"Monitor($(monitor_index)) values: x=$(monitor_rect_dest.x), " +
					@"y=$(monitor_rect_dest.y), w=$(monitor_rect_dest.width), h=$(monitor_rect_dest.height)\n");

			this.monitor_id = monitor_index;

			/* Get the desired size for the current monitor. */
			int width;
			int height;
			Size user_size = this.size_for_monitor[this.monitor_id];
			if (user_size != null &&
					monitor_rect_dest.width == user_size.monitor_width /* catch resolution changes */
				) {
			  // Use stored values
				width = user_size.width;
				height = user_size.height;
			} else {
				// Default values
				width = get_image_width_for_monitor(monitor_rect_dest.width);
				height = get_unscaled_height() * width / get_unscaled_width();

				// Store values
				Size tmp = new Size();
				tmp.width = width;
				tmp.height = height;
				tmp.monitor_width = monitor_rect_dest.width;
				this.size_for_monitor.set(this.monitor_id, tmp);
			}

			/* Compare current window size with desired new value and resize if required.*/
			int x, y, w, h;
			this.get_size(out w, out h);  // wrong if resolution changed?! TODO: Edit comment
			//this.get_size2(out w, out h);  // this reflect resolution changes

			if (w != width || h != height) {
			  // Window should move on monitor where the window needs an other width.
				this.resize(width, height);
				this.set_default_size(width, height);
				w = width;
				h = height;
			}

			/* Positioning window */
			switch(pos_on_screen) {
				case 0: // Jump to next position
					GLib.assert(false); // Deprecated case. It should be already handled.
					return;
				case 7:
					x = 0;
					y = 0;
					break;
				case 8:
					x = (monitor_rect_dest.width - w) / 2;
					y = 0;
					break;
				case 9:
					x = monitor_rect_dest.width - w;
					y = 0;
					break;
				case 4:
					x = 0;
					y = (monitor_rect_dest.height - h) / 2;
					break;
				case 5:
					x = (monitor_rect_dest.width - w) / 2;
					y = (monitor_rect_dest.height - h) / 2;
					break;
				case 6:
					x = monitor_rect_dest.width - w;
					y = (monitor_rect_dest.height - h) / 2;
					break;
				case 1:
					x = 0;
					y = monitor_rect_dest.height - h;
					break;
				case 2:
					x = (monitor_rect_dest.width - w) / 2;
					y = monitor_rect_dest.height - h;
					break;
				default:
					x = monitor_rect_dest.width - w;
					y = monitor_rect_dest.height - h;
					break;
			}
			// Multi monitor support: Add offset of current monitor
			x += monitor_rect_dest.x;
			y += monitor_rect_dest.y;

			this.position_num = pos;

			//store current coordinates
			this.position_on_hide_x = x;
			this.position_on_hide_y = y;

			this.move(x, y);
		}

		public void monitor_move(int i_monitor=-1, bool hide_after_latest=false) {

			if (hide_after_latest) {
				if (this.minimized) {
					debug(@"Show minimized window again. $(this.position_num)");
					show();
					return;
				}
			}

			if (i_monitor < 0) {
				numkeypad_move(this.position_num + 10);
			} else {
				numkeypad_move( 10 * i_monitor + (this.position_num % 10));
			}
			debug(@"New position: $(this.position_num)");

			if (hide_after_latest && this.position_num < 10 && this.already_shown_on_monitor1) {
				// First monitor reached again
				debug(@"Hide window. $(this.position_num)");

				// Workaround: get_positon() call in hide still returns old position.
				// reset new value after call.
				int tmpx = this.position_on_hide_x;
				int tmpy = this.position_on_hide_y;
				this.hide();
				//debug(@"AAAA $(this.position_on_hide_x), $(tmpx)");
				this.position_on_hide_x = tmpx;
				this.position_on_hide_y = tmpy;
			}
			if (this.position_num < 10) {
				this.already_shown_on_monitor1 = true;
			}
		}

		public Gdk.Pixbuf open_image (int layer) {
			var bildpfad = @"$(config.get("asset_folder"))/neo2.0_hires/tastatur_neo_Ebene$(layer).png";
			return open_image_str(bildpfad);
		}

		public Gdk.Pixbuf open_image_str (string bildpfad) {
			try {
				return new Gdk.Pixbuf.from_file (bildpfad);
			} catch (Error e) {
				error ("%s", e.message);
			}
		}

		public void load_images () {
			this.image_buffer["icon"] = open_image_str(
					@"$(config.get("asset_folder"))/icons/Neo-Icon.png");

			/*
				 int screen_width = this.get_screen_width(); //Gdk.Screen.width();
				 int max_width = (int) (double.parse(this.config.get("max_width")) * screen_width);
				 int min_width = (int) (double.parse(this.config.get("min_width")) * screen_width);
				 int width = int.min(int.max(int.parse(this.config.get("width")), min_width), max_width);
				 int w, h;
			 */

			this.numpad_width = int.parse(this.config.get("numpad_width"));
			this.function_keys_height = int.parse(this.config.get("function_keys_height"));

			for (int i = 1; i < 7; i++) {
				Gdk.Pixbuf layer = open_image(i);

				//Funktionstasten ausblenden, falls gefordert.
				if (this.config.get("display_function_keys") == "0") {
					var tmp =  new Gdk.Pixbuf(layer.colorspace, layer.has_alpha, layer.bits_per_sample, layer.width , layer.height-function_keys_height);
					layer.copy_area(0, function_keys_height, tmp.width, tmp.height, tmp, 0, 0);
					layer = tmp;
				}

				//Numpad-Teil abschneiden, falls gefordert.
				if (this.config.get("display_numpad") == "0") {
					var tmp =  new Gdk.Pixbuf(layer.colorspace, layer.has_alpha, layer.bits_per_sample, layer.width-numpad_width , layer.height);
					layer.copy_area(0, 0, tmp.width, tmp.height, tmp, 0, 0);
					layer = tmp;
				}

				string id = @"unscaled_$(i)";
				this.image_buffer.set(id, layer);
			}

		}

		private int get_image_width_for_monitor (int monitor_width) {

			//int screen_width = this.get_screen_width(); //Gdk.Screen.width();
			int max_width = (int) (double.parse(this.config.get("max_width")) * monitor_width);
			int min_width = (int) (double.parse(this.config.get("min_width")) * monitor_width);
			int width = int.min(int.max(int.parse(this.config.get("width")), min_width), max_width);

			return width;
		}

		private bool on_key_pressed (Widget source, Gdk.EventKey key) {
			// If the key pressed was q, quit, else show the next page
			if (key.str == "q") {
				NeoLayoutViewer.quit();
			}

			if (key.str == "h") {
				this.hide();
			}

			return false;
		}

		private bool on_button_pressed (Widget source, Gdk.EventButton event) {
			if (event.button == 3) {
				this.hide();
			}
			return false;
		}

		/*
			 Use the for values
			 - “modifier was pressed”
			 - “modifier is pressed”
			 - “modifier was seleted by mouseclick” and
			 - “modifier is seleted by mouseclick”
			 as array indizes to eval an new state. See comment of MODIFIER_KEYBOARD_MOUSE_MAP, too.
		 */
		public void change_active_modifier(int mod_index, bool keyboard, int new_mod_state) {
			int old_mod_state;
			if (keyboard) {
				//Keypress or Release of shift etc.
				old_mod_state = this.active_modifier_by_keyboard[mod_index]; 
				this.active_modifier_by_keyboard[mod_index] = MODIFIER_KEYBOARD_MOUSE_MAP[
					old_mod_state,
					this.active_modifier_by_mouse[mod_index],
					new_mod_state,
					this.active_modifier_by_mouse[mod_index]
				];
					this.active_modifier_by_mouse[mod_index] = MODIFIER_KEYBOARD_MOUSE_MAP[
						this.active_modifier_by_mouse[mod_index],
						old_mod_state,
						this.active_modifier_by_mouse[mod_index],
						new_mod_state
					];
			} else {
				//Mouseclick on shift button etc.
				old_mod_state = this.active_modifier_by_mouse[mod_index];
				this.active_modifier_by_mouse[mod_index] = MODIFIER_KEYBOARD_MOUSE_MAP[
					old_mod_state,
					this.active_modifier_by_keyboard[mod_index],
					new_mod_state,
					this.active_modifier_by_keyboard[mod_index]
				];
					this.active_modifier_by_keyboard[mod_index] = MODIFIER_KEYBOARD_MOUSE_MAP[
						this.active_modifier_by_keyboard[mod_index],
						old_mod_state,
						this.active_modifier_by_keyboard[mod_index],
						new_mod_state
					];
			}

		}

		public int getActiveModifierMask(int[] modifier) {
			int modMask = 0;
			foreach (int i in modifier) {
				modMask += (this.active_modifier_by_keyboard[i] | this.active_modifier_by_mouse[i]) * this.MODIFIER_MASK[i];
			}
			return modMask;
		}

		private void check_modifier(int iet1) {

			if (iet1 != this.layer) {
				this.layer = iet1;
				render_page();
			}
		}

		public void redraw() {
			var tlayer = this.layer;
			if (this.fix_layer) {  // Ignore key events
				this.layer = this.MODIFIER_MAP2[
					this.active_modifier_by_mouse[1], //shift
					this.active_modifier_by_mouse[2], //neo-mod3
					this.active_modifier_by_mouse[3] //neo-mod4
				] + 1;

			} else {
				this.layer = this.MODIFIER_MAP2[
					this.active_modifier_by_keyboard[1] | this.active_modifier_by_mouse[1], //shift
					this.active_modifier_by_keyboard[2] | this.active_modifier_by_mouse[2], //neo-mod3
					this.active_modifier_by_keyboard[3] | this.active_modifier_by_mouse[3] //neo-mod4
				] + 1;
			}
			// check, which extra modifier is pressed and update.
			foreach (var modkey in modifier_key_images) {
				modkey.change(
						this.active_modifier_by_keyboard[modkey.modifier_index] |
						this.active_modifier_by_mouse[modkey.modifier_index]
						);
			}

			if (tlayer != this.layer) {
				render_page();
			}

		}


		private void render_page () {
			this.image.select_pixbuf(this.layer-1);
		}

		public Gdk.Pixbuf getIcon() {
			return this.image_buffer["icon"];
		}

		public void external_key_press(int iet1, int modifier_mask) {

			for (int iet2 = 0; iet2 < 4; iet2++) {
				if (this.NEO_MODIFIER_MASK[iet2] == modifier_mask) {
					iet1 = this.MODIFIER_MAP[iet1, iet2] + 1;
					this.check_modifier(iet1);
					return;
				}
			}

			iet1 = this.MODIFIER_MAP[iet1, 0] + 1;
			this.check_modifier(iet1);
		}

		public void external_key_release(int iet1, int modifier_mask) {
			for (int iet2 = 0; iet2 < 4; iet2++) {
				if (this.NEO_MODIFIER_MASK[iet2] == modifier_mask) {
					iet1 =  this.MODIFIER_MAP_RELEASE[iet1, iet2] + 1;
					this.check_modifier(iet1);
					return;
				}
			}

			iet1 = this.MODIFIER_MAP_RELEASE[iet1, 0] + 1;
			this.check_modifier(iet1);
		}

		public int get_screen_width() {
			// Return value derived from config.get("screen_width")) or Gdk.Screen.width()

			if (this.screen_dim_auto[0]) {
				//Re-evaluate

#if GTK_MINOR_VERSION == 18 || GTK_MINOR_VERSION == 19 || GTK_MINOR_VERSION == 20 || GTK_MINOR_VERSION == 21
				// Old variant for ubuntu 16.04 ( '<' check not defined in vala preprozessor :-()
				var display = Gdk.Display.get_default();
				var screen = display.get_default_screen();
				//Gdk.Rectangle geometry = {0, 0, screen.get_width(), screen.get_height()};
				screen_dim[0] = screen.get_width();
#else
				var display = Gdk.Display.get_default();
				var screen = this.get_screen();
				var monitor = display.get_monitor_at_window(screen.get_active_window());
				//Note that type of this is Gtk.Window, but get_active_window() return Gdk.Window
				if (monitor == null) {
					monitor = display.get_primary_monitor();
				}
				Gdk.Rectangle geometry = monitor.get_geometry();
				screen_dim[0] = geometry.width;
#endif
			}
			return screen_dim[0];
		}

		public int get_unscaled_height() {
			int backgroundH_unscaled = 250;
			if (this.config.get("display_function_keys") == "0") {
				backgroundH_unscaled -= this.function_keys_height;
			}
			return backgroundH_unscaled;
		}

		public int get_unscaled_width() {
			int backgroundW_unscaled = 1000;
			if (this.config.get("display_numpad") == "0") {
				backgroundW_unscaled -= this.numpad_width;
			}
			return backgroundW_unscaled;
		}

		public int get_screen_height() {
			// Return value derived from config.get("screen_height")) or Gdk.Screen.height()

			if (this.screen_dim_auto[1]) {
				//Re-evaluate

#if GTK_MINOR_VERSION == 18 || GTK_MINOR_VERSION == 19 || GTK_MINOR_VERSION == 20 || GTK_MINOR_VERSION == 21
				// Old variant for ubuntu 16.04 ( '<' check not defined in vala preprozessor :-()
				var display = Gdk.Display.get_default();
				var screen = display.get_default_screen();
				//Gdk.Rectangle geometry = {0, 0, screen.get_width(), screen.get_height()};
				screen_dim[1] = screen.get_height();
#else
				var display = Gdk.Display.get_default();
				var screen = this.get_screen();
				var monitor = display.get_monitor_at_window(screen.get_active_window());
				//Note that type of this is Gtk.Window, but get_active_window() return Gdk.Window
				if (monitor == null) {
					monitor = display.get_primary_monitor();
				}
				Gdk.Rectangle geometry = monitor.get_geometry();
				screen_dim[1] = geometry.height;
#endif
			}
			return screen_dim[1];
		}

		private void fill_position_cycle_default(ref int[] positions) {
			/* Position          Next position    o ← o ← o
				 9   8   9          4   7   8       ↓       ↑
				 6   5   6  ====>   1   3   9       o   o   o
				 3   2   3          2   3   6       ↓     ↘ ↑
				 o → o → o

				 Values for monitor 4 are 11, …, 19 and so on.

				 Example output:
				 positions = {
				 -1, 3, 3, 9, 1, 3, 9, 1, 7, 7,
				 -11, 13, 13, 19, 11, 13, 19, 11, 17, 17,
				 -21, 23, 23, 29, 21, 23, 29, 21, 27, 27,
				 -31, 33, 33, 39, 31, 33, 39, 31, 37, 37,
				 };
			 */

			GLib.assert( positions.length%10 == 0 && positions.length > 0);
			int n_monitors = positions.length/10;
			for (int i_monitor=0; i_monitor < n_monitors; i_monitor++) {
				int s = i_monitor*10;
				positions[s] = -1;
				positions[s+1] = s + 2;
				positions[s+2] = s + 3;
				positions[s+3] = s + 6;
				positions[s+4] = s + 1;
				positions[s+5] = s + 3;
				positions[s+6] = s + 9;
				positions[s+7] = s + 4;
				positions[s+8] = s + 7;
				positions[s+9] = s + 8;
			}
		}

		private void main_resized() {

		  // Overwrite stored size for current monitor
			int width;
			int height;
			this.get_size(out width, out height);

			Size user_size = this.size_for_monitor[this.monitor_id];
			GLib.assert (user_size != null);
			if (user_size != null) {
				user_size.width = width;
				user_size.height = height;
			}
		}

	} //End class NeoWindow

	private class Size {
		private int _width;
		private int _height;
		private int _monitor_width;
		public int width {
			get { return _width; }
			set { if (value < 1) { _width = 1; } else { _width = value; } }
		}
		public int height {
			get { return _height; }
			set { if (value < 1) { _height = 1; } else { _height = value; } }
		}
		public int monitor_width {
			get { return _monitor_width; }
			set { if (value < 1) { _monitor_width = 1; } else { _monitor_width = value; } }
		}
	}
}
