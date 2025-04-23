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

			indicator = new AppIndicator.Indicator.with_path(
					"Neo Layout Viewer",
					neo_win.get_layout_icon_name(), // "Neo-Icon",
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
#if _OLD_GTK_STOCK
		public void create_menuMain() {
			menuMain = new Gtk.Menu();
			var menuAnzeigen = new Gtk.MenuItem.with_label("Anzeigen");
			menuAnzeigen.activate.connect(() => { this.neo_win.toggle(); });

			menuMain.append(menuAnzeigen);

			var menuAbout = new ImageMenuItem.from_stock(Stock.ABOUT, null);
			menuAbout.activate.connect(NeoLayoutViewer.about_dialog);
			menuMain.append(menuAbout);

			var menuQuit = new ImageMenuItem.from_stock(Stock.QUIT, null);
			menuQuit.activate.connect(NeoLayoutViewer.quit);
			menuMain.append(menuQuit);

		}
#else
		private void _addWidget(ref Gtk.Menu menu, ref Gtk.MenuItem m) {
		  // This prints a baseless warning ( -Wincompatible-pointer-types )
			// expected 'GtkWidget *' {aka 'struct _GtkWidget *'} but argument is of type 'GtkMenuItem *' {aka 'struct _GtkMenuItem *'}
			//menu.append(m);
			// Workaround: Using insert instead of append to avoid anoying cast warning,
			// see https://gitlab.gnome.org/GNOME/gtk/-/issues/5870
			menu.insert(m as Gtk.Widget, -1);
		}

		public void create_menuMain() {
			menuMain = new Gtk.Menu();
			var anzeigenBox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);
			var anzeigenLabel = new Gtk.Label.with_mnemonic("A_nzeigen");
			var anzeigenMenuItem = new Gtk.MenuItem();
			anzeigenLabel.set_xalign(0.0f);
			anzeigenBox.pack_end(anzeigenLabel, true, true, 0);
			anzeigenMenuItem.add(anzeigenBox);
			anzeigenMenuItem.activate.connect(() => { this.neo_win.toggle(); });
			_addWidget(ref menuMain, ref anzeigenMenuItem);

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
			_addWidget(ref menuMain, ref aboutMenuItem);

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
			_addWidget(ref menuMain, ref quitMenuItem);
#endif

			menuMain.show_all();
		}

	}

}
