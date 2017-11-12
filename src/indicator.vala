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

			var menuAnzeigen = new Gtk.MenuItem.with_label("Anzeigen");
			menuAnzeigen.activate.connect(() => { this.neo_win.toggle(); });
			menuMain.append(menuAnzeigen);

			//var about_icon = new Gtk.Image.from_icon_name( "document-about", IconSize.SMALL_TOOLBAR);
			//var menuAbout = new ImageMenuItem.with_mnemonic("_About");
			//menuAbout.set_image(about_icon);

			var menuAbout = new ImageMenuItem.from_stock(Stock.ABOUT, null);
			menuAbout.activate.connect(NeoLayoutViewer.about_dialog);
			menuMain.append(menuAbout);

			var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
			menuQuit.activate.connect(Gtk.main_quit);
			menuMain.append(menuQuit);
			menuMain.show_all();
		}

	}

}
