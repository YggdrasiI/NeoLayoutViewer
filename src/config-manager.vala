/* vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab */
// modules: Gtk

namespace NeoLayoutViewer {

	public class ConfigManager {

		public Gee.Map<string, string> config;
		private Gee.Map<string, string> description; // allow optional commenting config entrys.
		public string used_config_path;

		public ConfigManager(string[] paths, string conffile) {
			this.config =  new Gee.TreeMap<string, string>();
			this.description =  new Gee.TreeMap<string, string>();

			//add default values, if key not set in the config file
			add_defaults();

			//try to read/create config file on given array of paths
			string conffile2 = null;

			//1. Try to read conf file
			foreach (var path in paths) {
				string testfile = @"$(path)/$(conffile)";
				debug(@"Search $(testfile)\n");
				if (search_config_file(testfile)) {
					conffile2 = testfile;
					debug(@"Found $(testfile)\n");
					break;
				}
			}

			//2. Try deprecated name with leading dot
			if (conffile2 == null) {
				foreach (var path in paths) {
					string testfile = @"$(path)/.$(conffile)";
					debug(@"Search $(testfile)\n");
					if (search_config_file(testfile)) {
						conffile2 = testfile;
						debug(@"Found $(testfile)\n");
						break;
					}
				}
			}

			//3. Try to write new conf file if read had failed
			if (conffile2 == null) {
				foreach (var path in paths) {
					string testfile = @"$(path)/$(conffile)";
					if (create_conf_file(testfile) > -1) {
						debug(@"Create $(testfile)\n");
						conffile2 = testfile;
						break;
					}
				}
			}

			debug(@"Config file: $(conffile2)");

			if (search_config_file(conffile2))
				load_config_file(conffile2);

			add_intern_values();
			used_config_path = conffile2;
		}

		public Gee.Map<string, string> getConfig() {
			return config;
		}

		private void addSetting(string name, string val, string? comment) {
			config.set(name, val);

			if (comment != null) {
				description.set(name, comment);
			}
		}

		/*
			 Standard values. This vaules will be written in the config file
			 if it was not found.
		 */
		public void add_defaults() {
      addSetting("layout_type", "NEO_2", "Select keyboard layout: NEO_2, ADNW, KOY");
			//config.set("show_shortcut", "<Mod4><Super_L>n", "Toggle the visibility of the window.");
			addSetting("show_shortcut", "<Ctrl><Alt>q", "Toggle the visibility of the window.");
			addSetting("on_top", "1", "Show window on top.");
			addSetting("position", "3", "Window position on startup (num pad orientation)\n"
					+ "#   Add 10 to start on second monitor, etc.");
			/* width of application window
				 if value between 'resolution width'*max_width and  'resolution width'*min_width */
			addSetting("width", "1000", "Width in Pixel. Min_width and max_width bound sensible values. ");
			addSetting("min_width", "0.25", "Minimal width. 1=full screen width");
			addSetting("max_width", "0.5", "Maximal width. 1=full screen width");
			addSetting("monitor_shortcut", "<Ctrl><Alt><Shift>n", "Circle window through monitors.\n"
					+ "#   Use same value as 'show_shortcut' to combine both functionalities.");
			addSetting("move_shortcut", "<Ctrl><Alt>n", "Circle through window positions.");
			addSetting("position_cycle", "2 3 6 1 3 9 4 7 8 | 12 13 16 11 13 19 14 17 18 |",
					"""List of positions (num pad orientation)
#   The number on the n-th index marks the next position of the window.
#   Default cycle:  7 ← 8 ← 9
#                   ↓       ↑
#                   4   5   6
#                   ↓     ↘ ↑
#                   1 → 2 → 3
#
#   position_cycle = 2 3 6 1 3 9 4 7 8 | 12 13 16 11 13 19 14 17 18 |… 
#
#   Further examples:         
#        monitor          1                       2
#       position   1 2 3 4 5 6 7 8 9 | 11 12 13 14 15 18 17 18 19 |…
# position_cycle = 3 3 9 1 3 9 1 7 7 | 13 13 19 11 13 19 11 17 17 |… (corners only)
# position_cycle =3 3 11 1 3 9 1 7 7 | 13 13 19 11 13 19  9 17 17 |… (cycle over two monitors)""");

				addSetting("display_numpad", "1", null);
			addSetting("display_function_keys", "0", null);
			addSetting("window_selectable", "0", "Disable window selection to use the program as virtual keyboard.");
			addSetting("window_decoration", "0", "Show window decoration/border (not recommended).");
			addSetting("screen_width", "auto", "Set the resolution of your screen manually, if the automatic detection fails.");
			addSetting("screen_height", "auto", "Set the resolution of your screen manually, if the automatic detection fails.");
			addSetting("show_on_startup", "1", "Show window on startup.");
			addSetting("asset_folder", "./assets", "Default lookup folder image data.");
			addSetting("color_event_boxes", "0", "(Debugging) Show event boxes of virtual keyboard.");
		}

		/*
			 Enrich setting map by some values. User can not change them because
			 intern values overrides external values.
		 */
		private void add_intern_values() {
			config.set("numpad_width", "350");
			config.set("function_keys_height", "30");
		}

		private bool search_config_file(string conffile) {
			var file = File.new_for_path(conffile);
			return file.query_exists(null);
		}

		private int create_conf_file(string conffile) {
			var file = File.new_for_path(conffile);

			try {
				//Create a new file with this name
				var file_stream = file.create(FileCreateFlags.NONE);

				// Test for the existence of file
				if (!file.query_exists()) {
					GLib.stdout.printf("Can't create config file.\n");
					return -1;
				}

				// Write text data to file
				var data_stream = new DataOutputStream(file_stream);

				foreach (Gee.Map.Entry<string, string> e in this.config.entries) {

					if (this.description.has_key(e.key)) {
						data_stream.put_string("# " + this.description.get(e.key) + "\n");
					}

					data_stream.put_string(e.key + " = " + e.value + "\n");
				}
			} // Streams
			catch ( GLib.IOError e) { return -1; }
			catch ( GLib.Error e) { return -1; }

			return 0;
		}

		private int load_config_file(string conffile) {

			// A reference to our file
			var file = File.new_for_path(conffile);

			try {
				// Open file for reading and wrap returned FileInputStream into a
				// DataInputStream, so we can read line by line
				var in_stream = new DataInputStream(file.read(null));
				string line;
				string[] split;
				var comment = new Regex("^#.*$");
				var regex = new Regex("(#[^=]*)*[ ]*=[ ]*");

				// Read lines until end of file (null) is reached
				while ((line = in_stream.read_line(null, null)) != null) {

					if (comment.match(line)) continue;

					split = regex.split(line);
					if (split.length>1) {
						this.config.set(split[0].strip(), split[1].strip());
					}
				}
			} catch (GLib.IOError e) {
				error ("%s", e.message);
			} catch (RegexError e) {
				error ("%s", e.message);
			} catch (GLib.Error e) {
				error ("%s", e.message);
			}

			return 0;
		}

	} // end ConfigManager
} // end namespace
