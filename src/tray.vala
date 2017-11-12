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

#if _OLD_GTK_STOCK
			var menuAbout = new ImageMenuItem.from_stock(Stock.ABOUT, null);
			menuAbout.activate.connect(NeoLayoutViewer.about_dialog);
			menuMain.append(menuAbout);

			var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
			menuQuit.activate.connect(Gtk.main_quit);
			menuMain.append(menuQuit);

#else
      var aboutBox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);
			var aboutIcon = new Gtk.Image.from_icon_name( "help-about", IconSize.SMALL_TOOLBAR);
      var aboutLabel = new Gtk.Label.with_mnemonic("_About");
      var aboutMenuItem = new Gtk.MenuItem();
      aboutLabel.set_use_underline(true);
      aboutLabel.set_xalign(0.0f);
      aboutBox.pack_start(aboutIcon, false, false, 0);
      aboutBox.pack_end(aboutLabel, true, true, 0);
      aboutMenuItem.add(aboutBox);
			aboutMenuItem.activate.connect(NeoLayoutViewer.about_dialog);
      menuMain.append(aboutMenuItem);

      var quitBox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);
			var quitIcon = new Gtk.Image.from_icon_name( "application-exit", IconSize.SMALL_TOOLBAR);
      var quitLabel = new Gtk.Label.with_mnemonic("_QUIT");
      var quitMenuItem = new Gtk.MenuItem();
      quitLabel.set_use_underline(true);
      quitLabel.set_xalign(0.0f);
      quitBox.pack_start(quitIcon, false, false, 0);
      quitBox.pack_end(quitLabel, true, true, 0);
      quitMenuItem.add(quitBox);
			quitMenuItem.activate.connect(Gtk.main_quit);
      menuMain.append(quitMenuItem);
#endif

			menuMain.show_all();
		}

		/* Show popup menu on right button */
		private void menuMain_popup(uint button, uint time) {
			menuMain.popup(null, null, null, button, time);
		}

	}

}
