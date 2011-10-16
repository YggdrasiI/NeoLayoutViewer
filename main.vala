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

/*
		manager.bind2(50, "ShiftL",1, ()=>{});
		manager.bind2(62, "ShiftR",1, ()=>{});
		manager.bind2(66, "Mod3L",2, ()=>{});
		manager.bind2(51, "Mod3R",2, ()=>{});
		manager.bind2(94, "Mod4",3, ()=>{});
		manager.bind2(108, "Mod4",3, ()=>{});
*/
		manager.bind(configm.getConfig().get("show_shortcut"), ()=>{neo_win.toggle();});
		manager.bind(configm.getConfig().get("move_shortcut"), ()=>{neo_win.numkeypad_move(0);});

		//neo_win.show_all ();
		//neo_win.hide_all();

		//move window (Fehlerquelle: config von configm, nicht neo_win. Derzeit gleiches Objekt.)

		Gtk.main ();
/*
		manager.unbind2(50);
		manager.unbind2(62);
		manager.unbind2(66);
		manager.unbind2(51);
		manager.unbind2(94);
		manager.unbind2(108);
*/

		return 0;
	}


}

/* Extern C routines */
extern int keysend(uint keysym, int modifiers);
//extern int keysend2(uint keysym, uint modsym1, uint modsym2);
extern bool checkCapsLock(X.Display* d);
extern void checkModifier(X.Display* d, int* keycodes, int nkeycodes, int* pressed );
