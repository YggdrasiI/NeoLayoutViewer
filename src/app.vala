/* vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab */
// modules: Gtk

using Gtk;

namespace NeoLayoutViewer{

	public class NeoLayoutViewerApp: Gtk.Application {

		public NeoWindow neo_win = null;

#if tray
		public AppStatusIcon neo_tray; //for gnome2.x, kde(?)
#endif
#if indicator
		public NeoIndicator neo_indicator; //for gnome3.x
#endif
#if _NO_WIN
		public KeybindingManager manager;
#endif

		public int start_layer = 0; // > 0: keybord events do not change displayed layer
		public ConfigManager configm;


		public NeoLayoutViewerApp(ConfigManager configm) {
			Object(application_id: "org.gnome.neo_layout_viewer",
					flags: ApplicationFlags.HANDLES_OPEN );

			this.configm = configm;
		}

		protected override void activate () {
			if (this.neo_win == null ) {
				// Create the window of this application and show it
				this.neo_win = new NeoWindow (this);

#if tray
				this.neo_tray = new AppStatusIcon(neo_win);
#endif

#if indicator
				this.neo_indicator = new NeoIndicator(neo_win);
#endif

#if _NO_WIN
				bind_shortcuts();
#endif

				this.add_window(this.neo_win);
			}else{
				// reached if app.activate() called by remote instance
				this.neo_win.toggle();
			}
		}

		private void bind_shortcuts(){
			manager = new KeybindingManager(this.neo_win);
			var show_shortcut = configm.getConfig().get("show_shortcut").strip();
			var move_shortcut = configm.getConfig().get("move_shortcut").strip();
			var monitor_shortcut = configm.getConfig().get("monitor_shortcut").strip();

			if (move_shortcut.length > 0){
				manager.bind(move_shortcut, ()=>{this.neo_win.numkeypad_move(0);});
			}

			if (show_shortcut == monitor_shortcut){
				// combination of show + monitor move
				debug("Use combined shortcut for window showing and monitor switching.");
				manager.bind(monitor_shortcut, ()=>{this.neo_win.monitor_move(-1, true);});

			}else{
				if (monitor_shortcut.length > 0){
					manager.bind(monitor_shortcut, ()=>{this.neo_win.monitor_move();});
				}
				if (show_shortcut.length > 0){
					manager.bind(show_shortcut, ()=>{this.neo_win.toggle();});
				}
			}
		}

		public override void open (File[] files, string hint) {
			// Threat non-option argument(s) as layer to show at startup.
			// Note: This signal is not called in remote-case.

			foreach (File file in files) {
				var slayer = file.get_basename();
				this.start_layer = int.parse(slayer);
				break;
			}
			this.activate(); // init neo_win
			this.neo_win.show();
		}

	}
}
