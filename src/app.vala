/* vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab */
// modules: Gtk

using Gtk;

namespace NeoLayoutViewer{

	public class NeoLayoutViewerApp: Gtk.Application {

		//public int start_layer = 0; // > 0: keybord events do not change displayed layer
		public int counter { get; set; }
		public NeoWindow neo_win = null;
		private bool primary_start_finished = false;

		// Some options need references to static variables. These are
		// defined here, but not by add_main_option_entries(...)
		private static bool _opt_version = false;
		private static int _opt_move = -1; // != 0
		private const GLib.OptionEntry[] options = {
			// --version
			{ "version", 'v', 0, OptionArg.NONE, ref _opt_version, "Display version number", null },
			// --move
			{"move", 'm', OptionFlags.NONE, OptionArg.INT, ref _opt_move,
				"Move application window", "position (Num pad style)"},
			// list terminator
			{ null }
		};

		public NeoLayoutViewerApp() {
			Object(application_id: "org.gnome.neo_layout_viewer",
					//flags: ApplicationFlags.HANDLES_OPEN );
				flags: ApplicationFlags.HANDLES_COMMAND_LINE);

			this.add_main_option_entries(options);
			this.add_main_option("layer", 'l',
					OptionFlags.NONE, OptionArg.INT
					, "Force displayed layer, if > 0", "0-6");
			this.add_main_option("show", 's', OptionFlags.NONE, OptionArg.NONE
					, "Show application window", null);
			this.add_main_option("hide", 'h', OptionFlags.NONE, OptionArg.NONE
					, "Hide application window", null);
			this.add_main_option("toggle", 't', OptionFlags.NONE, OptionArg.NONE
					, "Toggle application window", null);
			this.add_main_option("pos", 'p', OptionFlags.NONE, OptionArg.STRING
					, "Set explicit position of application window", "x,y");
			this.add_main_option("quit", 'q', OptionFlags.NONE, OptionArg.NONE
					, "Quit primary instance", null);

			this.neo_win = null;
			this.counter = -2;
		}

		public override int handle_local_options (VariantDict options){
			// Return -1 to signal app that options should be handled
			// in command_line(...) of primary instance.

			if( _opt_version ) {
				print(@"Version $(RELEASE_VERSION) (git $(GIT_COMMIT_VERSION))\n");
				this.quit();
				return 0;
			}

			/* The --move option was added by add_main_option_entries(...) because
			 * the default value should be -1, not 0.
			 * Otherwise '--move 0' can not be distinct from unset option(?!)

			 * We need to add this option here again because the VariantDict
			 * 'options' only contains options added by add_main_option(...).
			 */
			options.insert_value("move", new Variant.int32(_opt_move));

			GLib.assert(options.lookup("move", "i"));
			//var opt_move = options.lookup_value("move", VariantType.INT32);
			//print(@"Move: $(opt_move.get_int32())");

			return -1;
		}

		public override int command_line (ApplicationCommandLine command_line){
			// Note: This method can be called multiple times.
			// Multiple starts of the app call this method in the primary instance.

			VariantDict options = command_line.get_options_dict();
			if ( options == null ){
				debug("Hey, option dict undefined?!\n");
				return 0;
			}

			var opt_quit = options.lookup_value("quit", VariantType.BOOLEAN);
			if( opt_quit != null && opt_quit.get_boolean() ){
				debug("Quit app");
				this.quit();
				return 0;
			}

			var opt_layer = options.lookup_value("layer", VariantType.INT32);
			var opt_show = options.lookup_value("show", VariantType.ANY);
			var opt_hide = options.lookup_value("hide", VariantType.ANY);
			var opt_toggle = options.lookup_value("toggle", VariantType.ANY);

			var opt_move = options.lookup_value("move", VariantType.INT32);
			var opt_pos = options.lookup_value("pos", VariantType.STRING);
			bool show_handled = false;

			if( opt_move != null && opt_move.get_int32() > -1 ){
			print(@"Move: $(opt_move.get_int32())\n");
				this.neo_win.numkeypad_move(opt_move.get_int32());
				show_handled = true;
			}else if( opt_pos != null ){
				debug("Not implemented");
				Regex separator = null;
				try {
					separator = new Regex(",");
				} catch (RegexError e) {
					error("Hm, regex compiling failed.");
				}
				if (separator != null) {
					string[] str_xy = separator.split(opt_pos.get_string());
					int new_x = 0; int new_y = 0;
/*					if (int.try_parse(str_xy[0], out new_x) &&
							int.try_parse(str_xy[1], out new_y) ) {
						// TODO: Maybe the ints should get a boundary check.
						debug(@"Move window to ($(new_x), $(new_y))");
						this.neo_win.move(new_x, new_y);
					}*/
				}
				show_handled = true;
			}

			if( opt_layer != null ){
				this.neo_win.fixed_layer = opt_layer.get_int32();
				show_handled = true;
			}

			if( opt_show != null ){
				this.neo_win.show();
				show_handled = true;
			}else if (opt_hide != null ){
				this.neo_win.hide();
				show_handled = true;
			}else if (opt_toggle != null ){
				this.neo_win.toggle();
				show_handled = true;
			}

			/* No option set which had changed the visibility state.
			 * Threat lack of option like '--toggle'.
			 */
			if (!show_handled ) {
				// Filtering first call out because option config file decide
				// inital visibility.
				if (this.primary_start_finished ){
					this.neo_win.toggle();
				}
			}else if (!this.neo_win.minimized) {
				this.neo_win.redraw();
			}

			this.primary_start_finished = true;
			return 0;
		}

		protected override void activate () {
			debug(@"Activate called");
			this.hold();
			// Only a stub.
			// The functionality was shifted into handling of command line
			this.release();
		}

		public override void open (File[] files, string hint) {
			debug(@"Open called, but without functionality!");
			// Only a stub because app is now controled over options
			// and ApplicationFlags.HANDLES_OPEN flag is not set anymore.
		}

	}
}
