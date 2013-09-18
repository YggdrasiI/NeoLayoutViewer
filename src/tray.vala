using Gtk;

namespace NeoLayoutViewer {

	public class AppStatusIcon {

		public StatusIcon trayicon;
		private Gtk.Menu menuMain;
		private NeoWindow neo_win;

		public AppStatusIcon(NeoWindow neo_win) {
			this.neo_win = neo_win;
			/* Create tray icon */
			trayicon = new StatusIcon.from_pixbuf(neo_win.get_icon());
			trayicon.set_tooltip_text ("Neo 2.0 Layout Viewer");
			trayicon.set_visible(true);

			create_menuMain();
			/* Connect popup_menu with right click */
			trayicon.popup_menu.connect(menuMain_popup);

			/* Connect main window with left click/acitvation */
			trayicon.activate.connect(()=>{this.neo_win.toggle();});
		}

		/* Create popup menu */
		public void create_menuMain() {
			menuMain = new Gtk.Menu();

			var menuAbout = new ImageMenuItem.from_stock(Stock.ABOUT, null);
			menuAbout.activate.connect(NeoLayoutViewer.about_dialog);
			menuMain.append(menuAbout);

			var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
			menuQuit.activate.connect(Gtk.main_quit);
			menuMain.append(menuQuit);
			menuMain.show_all();
		}

		/* Show popup menu on right button */
		private void menuMain_popup(uint button, uint time) {
			menuMain.popup(null, null, null, button, time);
		}

	}

}
