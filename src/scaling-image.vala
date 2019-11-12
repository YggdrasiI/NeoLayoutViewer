/* vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab */
// modules: Gtk Gdk

using Gtk;
using Gdk;

namespace NeoLayoutViewer {

	/* Reacts on window size changes.
	 *
	 */
	class ScalingImage: Gtk.Image {

		private Gtk.Window winMain;
		private Gdk.Pixbuf[] source_pixbufs;
		private Gdk.Pixbuf[] scaled_pixbufs;
		private int width = -1;
		private int height = -1;
		private int start_width;
		private int start_height;
		private int reference_w;
		private int reference_h;
		private int win_width;
		private int win_height;
		private int source_index;
		private static int __id = 0;
		private int id;

		public ScalingImage(
				int start_width, int start_height,
				Gtk.Window winMain, int reference_w, int reference_h,
				Gdk.Pixbuf[] source_pixbufs,
				int start_source_index = 0
				)
		{
			this.id = ScalingImage.__id++;
			this.winMain = winMain;
			this.start_width = start_width;
			this.start_height = start_height;
			this.width = start_width;
			this.height = start_height;
			this.reference_w = reference_w;
			this.reference_h = reference_h;

			this.win_width = this.winMain.get_allocated_width();
			this.win_height = this.winMain.get_allocated_height();

			this.source_pixbufs = source_pixbufs;
			this.scaled_pixbufs = new Gdk.Pixbuf[source_pixbufs.length];

			this.source_index = start_source_index;
			GLib.assert(this.source_index >= 0);
			GLib.assert(this.source_index < this.source_pixbufs.length);

			this.winMain.check_resize.connect(main_resized);
		}

		private void main_resized(){

			// Get new window size
			int win_width2;
			int win_height2;
			//win_width2 = this.winMain.get_allocated_width();
			//win_height2 = this.winMain.get_allocated_height();
			this.winMain.get_size(out win_width2, out win_height2);

			if (win_width == win_width2 && win_height == win_height2) {
				//debug(@"(ScalingImage $(this.id)) same width $(win_width)");
				return;
			}

			debug(@"Window resize signal. New width/height: $(width)/$(height)\n");

			if( win_width2 == 1 && win_height2 == 1){
				return;  // (1,1) send if user show/hides window very fast.
			}

			// Eval new image size
			GLib.assert(this.win_width > 0);
			GLib.assert(this.win_height > 0);

			this.width = (this.start_width * win_width2)/this.reference_w;
			this.height = (this.start_height * win_height2)/this.reference_h;

			// Overwrite old window size
			this.win_width = win_width2;
			this.win_height = win_height2;

			this.select_pixbuf(this.source_index);
		}

		public void select_pixbuf(int new_source_index)
		{
			GLib.assert(new_source_index >= 0);
			GLib.assert(new_source_index < this.source_pixbufs.length);
			GLib.assert(this.source_pixbufs.length == this.scaled_pixbufs.length);

			this.source_index = new_source_index;
			int i = new_source_index;

			// Scale pixbuf if required
			if (this.scaled_pixbufs[i] == null ||
					this.width != this.scaled_pixbufs[i].width ||
					this.height != this.scaled_pixbufs[i].height) {
				//debug(@"(ScalingImage $(this.id)) scaling to $(this.width)x$(this.height)");

				this.scaled_pixbufs[i] = this.source_pixbufs[i].scale_simple(
						this.width, this.height, Gdk.InterpType.BILINEAR);
			}

			// Update displayed image
			//debug(@"(ScalingImage $(this.id)) draw image");
			this.set_from_pixbuf(this.scaled_pixbufs[i]);
		}

	}  // End class ScalingImage
}

