using X;

namespace NeoLayoutViewer{

	public NeoWindow neo_win;
	public AppStatusIcon neo_tray;
	public KeybindingManager manager;
	public ConfigManager configm;

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

		configm = new ConfigManager(path,"neo_layout_viewer.conf");

		neo_win = new NeoWindow (slayer, configm.getConfig());
		neo_tray = new AppStatusIcon(neo_win);
		manager = new KeybindingManager(neo_win);

		manager.bind(configm.getConfig().get("show_shortcut"), ()=>{neo_win.toggle();});
		manager.bind(configm.getConfig().get("move_shortcut"), ()=>{neo_win.numkeypad_move(0);});

		//neo_win.show_all ();
		//neo_win.hide_all();

		//move window (Fehlerquelle: config von configm ist im allgemeinen nicht gleich neo_win.config?! Derzeit gleiches Objekt.)

		Gtk.main ();

		return 0;
	}


}

/* Extern C routines */
extern int keysend(uint keysym, int modifiers);
extern int keysend2(uint keysym, uint modsym1, uint modsym2);
extern bool checkCapsLock(X.Display* d);
extern void checkModifier(X.Display* d, int* keycodes, int nkeycodes, int* pressed );
