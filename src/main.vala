using X;

namespace NeoLayoutViewer{

	public NeoWindow neo_win;
	public KeybindingManager manager;
	public ConfigManager configm;

#if tray
	public AppStatusIcon neo_tray; //for gnome2.x, kde(?)
#endif
#if indicator
	public NeoIndicator neo_indicator; //for gnome3.x
#endif

	public static int main (string[] args) {

		string slayer;
		if( args.length<2) {
			slayer="1";
		}else{
			slayer=args[1];
		}

		Gtk.init (ref args);


		//Get program path (no binding for getcwd found…)
		string path = "";
		try {
			var regex = new Regex("[^/]*$");
			path = regex.replace(args[0],-1,0,"");
		} catch (RegexError e) {
			path = "";
		}
		debug(@"Path: $path");

		string[] paths = {
			//GLib.Environment.get_user_config_dir(),
			GLib.Environment.get_home_dir(),
			GLib.Environment.get_current_dir()
		};

		configm = new ConfigManager(paths,".neo_layout_viewer.conf");

		// Try to find asset folder (images)
		string asset_folder = search_asset_folder( configm.getConfig().get("asset_folder") );
		if( asset_folder == null ){
			stdout.printf("Application start failed. Asset folder was not found.\n");
			stdout.flush();
			return 0;
		}
		//add path to asset folder
		configm.getConfig().set("asset_folder",asset_folder);

		debug(@"Asset folder: $(asset_folder)\n");




		neo_win = new NeoWindow (slayer, configm.getConfig());

		var app = showPreviousInstance("org.gnome.neo_layout_viewer", neo_win);
		if( app == null){
				return 0;
		}

		manager = new KeybindingManager(neo_win);

#if tray
		neo_tray = new AppStatusIcon(neo_win);
#endif

#if indicator
		neo_indicator = new NeoIndicator(neo_win);
#endif

		manager.bind(configm.getConfig().get("show_shortcut"), ()=>{neo_win.toggle();});
		manager.bind(configm.getConfig().get("move_shortcut"), ()=>{neo_win.numkeypad_move(0);});

		//neo_win.show_all ();
		//neo_win.hide_all();

		//move window (Fehlerquelle: config von configm ist im allgemeinen nicht gleich neo_win.config?! Derzeit gleiches Objekt.)

		Gtk.main ();

		return 0;
	}


/* This function create the about dialog in
	tray menu or indicator menu */
	private static void about_dialog() {
			var about = new Gtk.AboutDialog();
			about.set_version("0.9");
			about.set_program_name("Neo2.0 Ebenenanzeige");
			about.set_comments(@"Erleichtert das Nachschlagen von Tastenkombinationen im Neo 2.0-Layout.\n\n Olaf Schulz\n funwithkinect-AT-googlemail.com\n\n\nTastenkombinationen:\n Ein-/Ausblenden - $(neo_win.config.get("show_shortcut"))\n Bewegen - $(neo_win.config.get("move_shortcut"))\n Beenden (sofern Fenster selektiert) - q\n");
			about.set_copyright("GPLv3");
			about.run();
			about.hide();
		}

	/* Check given path and shared files folders for the asset folder.
		 The folder will be assumed as right one if one required file was found.
		 @return: assed folder or null.
	 */
	private static string? search_asset_folder(string path){
		string filename = "/icons/Neo-Icon.png";
		var file = File.new_for_path (path+filename);
		if( file.query_exists(null)) return path;

		string[] datadirs = GLib.Environment.get_system_data_dirs();
		foreach( var s in datadirs ){
			var path2 = s+"NeoLayoutViewer/assets";
			var file2 = File.new_for_path (path2+filename);
			if( file2.query_exists(null)) return path2;
		}

		return null;
	}


}

/* Extern C routines */
extern int keysend(uint keysym, int modifiers);
extern int keysend2(uint keysym, uint modsym1, uint modsym2);
extern bool checkCapsLock(X.Display* d);
extern void checkModifier(X.Display* d, int* keycodes, int nkeycodes, int* pressed );
