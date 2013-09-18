using Gtk;
using Unique;

namespace NeoLayoutViewer {

public const int SHOW=1000;

public static Unique.App? showPreviousInstance(string name, Gtk.Window win) {
		var app = new Unique.App(name, null);
		app.add_command ("Show application", SHOW); 

		if (app.is_running) {
			//where is already a running instance
			debug("Application already running. Show window.");
			app.send_message(SHOW,null);
			return null;
		}

		app.message_received.connect((t, command, data, time) =>{
			if (command == SHOW) {
				win.show();
			}
			return Unique.Response.OK;
		});

		return app;
	}

}

