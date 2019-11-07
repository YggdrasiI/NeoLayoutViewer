/* vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab */
// modules: Gtk

using Gtk;

namespace NeoLayoutViewer {

	public class NeoIndicator {

		private NeoWindow neo_win;
		private AppIndicator.Indicator indicator;
		private Gtk.Menu menuMain;

		public NeoIndicator(NeoWindow neo_win) {
			this.neo_win = neo_win;

			indicator = new AppIndicator.Indicator.with_path("Neo Layout Viewer", "Neo-Icon",
					AppIndicator.IndicatorCategory.APPLICATION_STATUS,
					configm.getConfig().get("asset_folder")+"/icons/");
			//"./assets/icons/" );

			create_menuMain();
			indicator.set_menu(this.menuMain);

			indicator.set_status(AppIndicator.IndicatorStatus.ACTIVE);

		}

		public void deactivate() {

			if (indicator != null) {
				indicator.set_status(AppIndicator.IndicatorStatus.PASSIVE);
			}
		}

		/* Create popup menu */
		public void create_menuMain() {
			menuMain = new Gtk.Menu();

#if _OLD_GTK_STOCK
			var menuAnzeigen = new Gtk.MenuItem.with_label("Anzeigen");
			menuAnzeigen.activate.connect(() => { this.neo_win.toggle(); });
			menuMain.append(menuAnzeigen);

			var menuAbout = new ImageMenuItem.from_stock(Stock.ABOUT, null);
			menuAbout.activate.connect(NeoLayoutViewer.about_dialog);
			menuMain.append(menuAbout);

			var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
			menuQuit.activate.connect(NeoLayoutViewer.quit);
			menuMain.append(menuQuit);

#else
			var anzeigenBox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);
			var anzeigenLabel = new Gtk.Label.with_mnemonic("A_nzeigen");
			var anzeigenMenuItem = new Gtk.MenuItem();
			//anzeigenBox.add(anzeigenIcon);
			anzeigenLabel.set_xalign(0.0f);
			anzeigenBox.pack_end(anzeigenLabel, true, true, 0);
			anzeigenMenuItem.add(anzeigenBox);
			anzeigenMenuItem.activate.connect(() => { this.neo_win.toggle(); });
			menuMain.append(anzeigenMenuItem);

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
			quitMenuItem.activate.connect(NeoLayoutViewer.quit);
			menuMain.append(quitMenuItem);
#endif

			menuMain.show_all();
		}

	}

}
