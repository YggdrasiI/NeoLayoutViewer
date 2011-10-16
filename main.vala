using X;

namespace NeoLayoutViewer{

	public static int main (string[] args) {
		string sebene;
		if( args.length<2) {
			sebene="1";
		}else{
			sebene=args[1];
		}

		Gtk.init (ref args);

		var configm = new ConfigManager("neolayoutviewer.conf");

		var neo_win = new NeoWindow (sebene, configm.getConfig());
		var neo_tray = new AppStatusIcon(neo_win);
		var manager = new KeybindingManager(neo_win);

		manager.bind(configm.getConfig().get("show_shortcut"), ()=>{neo_win.toggle();});
		manager.bind(configm.getConfig().get("move_shortcut"), ()=>{neo_win.numkeypad_move(0);});

		//neo_win.show_all ();
		//neo_win.hide_all();

		//move window (Fehlerquelle: config von configm, nicht neo_win. Derzeit gleiches Objekt.)

		Gtk.main ();

		return 0;
	}


}

/* Extern C routines */
extern int keysend(uint keysym, int modifiers);
//extern int keysend2(uint keysym, uint modsym1, uint modsym2);
extern bool checkCapsLock(X.Display* d);
extern void checkModifier(X.Display* d, int* keycodes, int nkeycodes, int* pressed );
