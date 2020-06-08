/* vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab */
// modules: Gtk Gdk X Posix

/*
	 Known Problems:
	 - Tab, Shift+Tab, Shift+Space, Numblock not implemented
	 - Some special characters, i.e ℂ, not implemented, because the unicode numbers
	 not defined in keysymdef.h (and left in the vapi file, too).
 */
using Gtk;
using Gdk;
using X;
using Posix;//system-call

namespace NeoLayoutViewer {

	/* Use Layout instead of Fixed because size of Layout content does not
	influence the window size. (=> No feedback loop) */
	public class KeyOverlay : Gtk.Layout {

		private Gee.HashMap<int, KeycodeArray> keysyms;
		private NeoWindow winMain;

		private Gee.HashMap<int, KeyEventCell> eventCells;
		bool color_event_boxes = true;  // for debugging
		private int __move_id;
		private int _width;
		private int _height;

		public KeyOverlay(NeoWindow winMain) {
			this.winMain = winMain;
			switch (winMain.layoutType) {
				case "ADNW":
					{
						this.keysyms = generateKeysymsAdnw(); // for ADNW-layout
						break;
					}
				case "KOY":
					{
						this.keysyms = generateKeysymsKoy();  // for KOY-layout
						break;
					}
				case "NEO2":
				default:
					{
						this.keysyms = generateKeysymsNeo2();  // for NEO-layout
						break;
					}
			}

			this.eventCells = new Gee.HashMap<int, KeyEventCell>();

			this._width = this.winMain.get_allocated_width();
			this._height = this.winMain.get_allocated_height();
			this.set_size_request(_width, _height);

			this.color_event_boxes = (winMain.config.get("color_event_boxes") == "1");

			generateCells();

			this.winMain.check_resize.connect(main_resized);
		}

		private void main_resized() {

			int width;
			int height;
			//width = this.winMain.get_allocated_width();
			//height = this.winMain.get_allocated_height();
			this.winMain.get_size(out width, out height);

			if (this._width == width && this._height == height) {
				return;  // to avoid infinite resize live lock...
			}
			debug(@"Window resize signal. New width/height: $(width)/$(height)");

			if (width == 1 && height == 1) {
				return;  // (1, 1) send if user show/hides window very fast.
			}

			this._width = width;
			this._height = height;

			// Propagate new window width/height to this grid.
			this.set_size_request(width, height);

			debug("Rescale cells");
			move_and_scale_cells();


		}

		/* Generate for every key an EventBox and add it to this grid.

			 The cell size will grow/shrink with the window size and
			 must match to the background image of the window.
		 */
		public void generateCells() {

			// Dimensions of unscaled background image
			double width_unscaled = (double) winMain.get_unscaled_width();
			double height_unscaled = (double) winMain.get_unscaled_height();

			int width, height;
			// Desirered target size
			width = this._width;
			height = this._height;

			double scaleX = width/width_unscaled;
			double scaleY = height/height_unscaled;

			double x_unscaled = 0.0;
			double y_unscaled = 0.0;
			int x = 0;
			int y = 0;

			//debug(@"XXXX width=$(width), height=$(height)");
			//debug(@"XXXX width_unscaled=$(width_unscaled), height_unscaled=$(height_unscaled)");
			//debug(@"XXXX scaleX=$(scaleX), scaleY=$(scaleY)");

			//++ function key row ++
			if (winMain.config.get("display_function_keys") != "0") {
				//esc
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 9, false, 0);
				//free space
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				// F1-F4
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 67, false, 0);
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 68, false, 0);
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 69, false, 0);
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 70, false, 0);
				//free space
				gridCell(22.0-5.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				// F5-F8
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 71, false, 0);
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 72, false, 0);
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 73, false, 0);
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 74, false, 0);
				//free space
				gridCell(22.0-5.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				// F9-F11
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 75, false, 0);
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 76, false, 0);
				gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 95, false, 0);

				if (winMain.config.get("display_numpad") != "0") {
					//F12
					gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 96, false, 0);
					//free space
					gridCell(22.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
					// print, scroll, break
					gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 107, false, 0);
					gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 78, false, 0);
					gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 127, true, 0);

				} else {
					//F12
					gridCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 96, true, 0);
				}

				//debug(@"x=$(x) y=$(y)");

				//Reset right shift.
				x_unscaled = 0.0;
				x = 0;
			}
			//++ END function key row ++

			//++ top row ++
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 49, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 10, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 11, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 12, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 13, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 14, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 15, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 16, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 17, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 18, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 19, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 20, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 21, false, 0);

			if (winMain.config.get("display_numpad") != "0") {
				gridCell(78.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 22, false, 0);
				//free space
				gridCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				//ins home page_up
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 118, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 110, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 112, false, 0);
				//free space
				gridCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				//num key, divide, times, and minus
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 77, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 106, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 63, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 82, true, 0);
			} else {
				gridCell(78.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 22, true, 0);
			}

			//debug(@"x=$(x) y=$(y)");
			//Reset right shift.
			x_unscaled = 0.0;
			x = 0;
			//++ End top row ++

			//++ upper row ++
			gridCell(60.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 23, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 24, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 25, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 26, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 27, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 28, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 29, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 30, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 31, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 32, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 33, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 34, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 35, false, 0);

			if (winMain.config.get("display_numpad") != "0") {
				//Halve of Return/Enter
				gridCell(62.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 36, false, 0);
				//free space
				gridCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				//entf end page_down
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 119, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 115, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 117, false, 0);
				//free space
				gridCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				//7, 8, 9, and halve of plus
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 79, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 80, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 81, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 86, true, 0);
			} else {
				//Halve of Return/Enter
				gridCell(62.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 36, true, 0);
			}

			//debug(@"x=$(x) y=$(y)");
			//Reset right shift.
			x_unscaled = 0.0;
			x = 0;
			//++ End upper row ++

			//++ home row ++
			//left mod3
			gridCell(73.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 2/*37*/, false, 1);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 38, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 39, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 40, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 41, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 42, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 43, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 44, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 45, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 46, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 47, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 48, false, 0);
			//right mod3
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 2/*51*/, false, 1);

			if (winMain.config.get("display_numpad") != "0") {
				//Second halve of Enter/Return
				gridCell(49.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 36, false, 0);
				//free space
				gridCell(174.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				//4, 5, 6, and halve of plus
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 83, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 84, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 85, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 86, true, 0);
			} else {
				//Second halve of Enter/Return
				gridCell(49.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 36, true, 0);
			}

			//debug(@"x=$(x) y=$(y)");
			//Reset right shift.
			x_unscaled = 0.0;
			x = 0;
			//++ End home row ++

			//++ lower row ++
			//left shift
			gridCell(52.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 1/*50*/, false, 1);
			//mod4
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 3/*94*/, false, 1);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 52, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 53, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 54, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 55, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 56, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 57, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 58, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 59, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 60, false, 0);
			gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 61, false, 0);

			if (winMain.config.get("display_numpad") != "0") {
				//right shift
				gridCell(114.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 1 /*62*/, false, 1);
				//free space
				gridCell(66.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				// up
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 111, false, 0);
				//free space
				gridCell(66.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				//1, 2, 3, and halve of enter
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 87, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 88, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 89, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 104, true, 0);
			} else {
				//right shift
				gridCell(114.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 1 /*62*/, true, 1);
			}

			//debug(@"x=$(x) y=$(y)");
			//Reset right shift.
			x_unscaled = 0.0;
			x = 0;
			//++ End lower row ++

			//++ last/space row ++
			//left ctrl, 37
			gridCell(61.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 4/*37*/, false, 2);
			//free space
			gridCell(48.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
			//alt
			gridCell(61.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 5/*64*/, false, 4);
			//space
			gridCell(316.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 65, false, 0);
			//mod4
			gridCell(61.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 3/*94*/, false, 1);
			//free space
			gridCell(40.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);

			if (winMain.config.get("display_numpad") != "0") {
				// right ctrl
				gridCell(61.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 4/*105*/, false, 3);
				//free space
				gridCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				//left, down, right
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 113, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 116, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 114, false, 0);
				//free space
				gridCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, -1, false, -1);
				//0, comma, and halve of enter
				gridCell(88.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 90, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 91, false, 0);
				gridCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 104, true, 0);
			} else {
				// right ctrl
				gridCell(61.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, 4/*105*/, true, 3);
			}

			//debug(@"x=$(x) y=$(y)");
			//++ End last/space row ++

		}

		public void move_and_scale_cells() {

			double width_unscaled = (double) winMain.get_unscaled_width();
			double height_unscaled = (double) winMain.get_unscaled_height();

			int width, height;
			winMain.get_size(out width, out height);

			double scaleX = width/width_unscaled;
			double scaleY = height/height_unscaled;

			double x_unscaled = 0.0;
			double y_unscaled = 0.0;
			int x = 0;
			int y = 0;

			// detach cells from grid
			/*foreach (KeyEventCell w in this.eventCells.values) {
				this.remove(w);
			}*/
			// Reset id. Number will increased in ever moveCell call
			this.__move_id = 0;

			//debug(@"YYYY width=$(width), height=$(height)");
			//debug(@"YYYY width_unscaled=$(width_unscaled), height_unscaled=$(height_unscaled)");
			//debug(@"YYYY scaleX=$(scaleX), scaleY=$(scaleY)");

			//++ function key row ++
			if (winMain.config.get("display_function_keys") != "0") {
				//esc
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				// F1-F4
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(22.0-5.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				// F5-F8
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(22.0-5.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				// F9-F11
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);

				if (winMain.config.get("display_numpad") != "0") {
					//F12
					moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
					//free space
					moveCell(22.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
					// print, scroll, break
					moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
					moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
					moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);

				} else {
					//F12
					moveCell(44.0, 30.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);
				}

				//debug(@"x=$(x) y=$(y)");

				//Reset right shift.
				x_unscaled = 0.0;
				x = 0;
			}
			//++ END function key row ++

			//++ top row ++
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);

			if (winMain.config.get("display_numpad") != "0") {
				moveCell(78.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//ins home page_up
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//num key, divide, times, and minus
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);
			} else {
				moveCell(78.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);
			}

			//debug(@"x=$(x) y=$(y)");
			//Reset right shift.
			x_unscaled = 0.0;
			x = 0;
			//++ End top row ++

			//++ upper row ++
			moveCell(60.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);

			if (winMain.config.get("display_numpad") != "0") {
				//Halve of Return/Enter
				moveCell(62.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//entf end page_down
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//7, 8, 9, and halve of plus
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);
			} else {
				//Halve of Return/Enter
				moveCell(62.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);
			}

			//debug(@"x=$(x) y=$(y)");
			//Reset right shift.
			x_unscaled = 0.0;
			x = 0;
			//++ End upper row ++

			//++ home row ++
			//left mod3
			moveCell(73.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			//right mod3
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);

			if (winMain.config.get("display_numpad") != "0") {
				//Second halve of Enter/Return
				moveCell(49.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(174.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//4, 5, 6, and halve of plus
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);
			} else {
				//Second halve of Enter/Return
				moveCell(49.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);
			}

			//debug(@"x=$(x) y=$(y)");
			//Reset right shift.
			x_unscaled = 0.0;
			x = 0;
			//++ End home row ++

			//++ lower row ++
			//left shift
			moveCell(52.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			//mod4
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);

			if (winMain.config.get("display_numpad") != "0") {
				//right shift
				moveCell(114.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(66.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				// up
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(66.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//1, 2, 3, and halve of enter
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);
			} else {
				//right shift
				moveCell(114.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);
			}

			//debug(@"x=$(x) y=$(y)");
			//Reset right shift.
			x_unscaled = 0.0;
			x = 0;
			//++ End lower row ++

			//++ last/space row ++
			//left ctrl, 37
			moveCell(61.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			//free space
			moveCell(48.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			//alt
			moveCell(61.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			//space
			moveCell(316.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			//mod4
			moveCell(61.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
			//free space
			moveCell(41.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);

			if (winMain.config.get("display_numpad") != "0") {
				// right ctrl
				moveCell(61.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//left, down, right
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//free space
				moveCell(22.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				//0, comma, and halve of enter
				moveCell(88.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, false);
				moveCell(44.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);
			} else {
				// right ctrl
				moveCell(61.0, 44.0, ref x_unscaled, ref y_unscaled, ref x, ref y, scaleX, scaleY, true);
			}

			//debug(@"x=$(x) y=$(y)");
			//++ End last/space row ++

		}

		private void gridCell(
				double width_unscaled, double height_unscaled,
				ref double x_unscaled, ref double y_unscaled,
				ref int x, ref int y,
				double scaleX, double scaleY,
				int keycode, bool vertical,
				int cell_type)
		{

			// Truncate cell width if too wide for current window size (to omit rescaling)
			// Not required for Gtk.Layout
			/*
			double win_width_unscaled = (double) winMain.get_unscaled_width();
			double win_height_unscaled = (double) winMain.get_unscaled_height();
			int win_width, win_height;
			winMain.get_size(out win_width, out win_height);

			int width;
			int height;

			if (x_unscaled + width_unscaled > win_width_unscaled) {
				debug(@"AAAA cell too wide! Change from $(width_unscaled) to $(win_width_unscaled-x_unscaled)");
				width_unscaled = win_width_unscaled - x_unscaled;
				width = win_width - x;
			} else {
				width = (int)GLib.Math.floor((x_unscaled + width_unscaled) * scaleX - x );
			}

			if (y_unscaled + height_unscaled > win_height_unscaled) {
				debug(@"AAAA cell too tall! Change from $(height_unscaled) to $(win_height_unscaled-y_unscaled)");
				height_unscaled = win_height_unscaled - y_unscaled;
				height = win_height - y;
			} else {
				height = (int)GLib.Math.floor((y_unscaled + height_unscaled) * scaleY - y );
			}
			*/
			int width = (int)GLib.Math.floor((x_unscaled + width_unscaled) * scaleX - x );
			int height = (int)GLib.Math.floor((y_unscaled + height_unscaled) * scaleY - y );

			KeyEventCell cell;
			switch (cell_type) {
				case 0:
					// Normale Taste
					KeycodeArray ks = this.keysyms.get(keycode);
					cell = new KeyEventCell(winMain, width, height, width, height, ref ks.val );
					break;
				case 1:
					// Modifier, die andere Buchstabenebenen aktivieren. Zusätzlich Ebenen-Bild einblenden.
					cell = new KeyEventCell.modifier(winMain, width, height, width, height, keycode /*=modifier array index*/ );
					break;
					//Andere Modifier (CTRL, Alt, ... )
				case 2: //left ctrl
					//cell = new KeyEventCell.modifier(winMain, width, height, width, height, keycode );
					cell = new KeyEventCell.modifier2(winMain, width, height, width, height, keycode /*modifier array index */, "tastatur_ctrl_left_2.png" );
					break;
				case 3: //right ctrl
					//cell = new KeyEventCell.modifier(winMain, width, height, width, height, keycode );
					cell = new KeyEventCell.modifier2(winMain, width, height, width, height, keycode /*modifier array index */, "tastatur_ctrl_right_2.png" );
					break;
				case 4: //left alt
					//cell = new KeyEventCell.modifier(winMain, width, height, width, height, keycode );
					cell = new KeyEventCell.modifier2(winMain, width, height, width, height, keycode /*modifier array index */, "tastatur_alt_left_2.png" );
					break;
				default:
					// Fläche ohne Funktion
					cell = new KeyEventCell.freeArea(winMain, width, height, width, height );
					break;
			}

			// Let eventbox fill the whole grid cell.
			/*
			cell.set_hexpand(true);
			cell.set_vexpand(true);
			cell.set_halign(Gtk.Align.FILL);
			cell.set_valign(Gtk.Align.FILL);
			*/
			cell.set_hexpand(false);
			cell.set_vexpand(false);
			cell.set_halign(Gtk.Align.CENTER);
			cell.set_valign(Gtk.Align.CENTER);

			// Add cell to list (required to handle window resizing
			this.eventCells.set(this.__move_id, cell);
			this.__move_id += 1;

			//debug(@"x=$(x) y=$(y)");

			cell.set_size_request(width, height);
			cell.show();
			this.put(cell, x, y);

			x_unscaled += width_unscaled;
			x += width;
			if (vertical) {
				y_unscaled += height_unscaled;
				y += height;
			}

			// TODO
			if (this.color_event_boxes && cell.get_children().length() == 0) {
				Label l = new Label(""); // do not use non-empty string
				l.show();

				cell.add(l);

				Gdk.RGBA color = Gdk.RGBA();
				color.parse("#ebccd1");
				color.blue = (double) ((keycode*232437)%230)/255.0;
				color.red = (double) ((keycode*12393)%230)/255.0;
				color.green = (double) ((keycode*58283)%230)/255.0;
				color.alpha = 0.5;
				l.override_background_color(Gtk.StateFlags.NORMAL, color);
			}

		}

		private void moveCell(
				double width_unscaled, double height_unscaled,
				ref double x_unscaled, ref double y_unscaled,
				ref int x, ref int y,
				double scaleX, double scaleY,
				bool vertical)
		{

			// Truncate cell width if too wide for current window size (to omit rescaling)
			// Not required for Gtk.Layout
			/*
			double win_width_unscaled = (double) winMain.get_unscaled_width();
			double win_height_unscaled = (double) winMain.get_unscaled_height();
			int win_width, win_height;
			winMain.get_size(out win_width, out win_height);

			int width;
			int height;

			if (x_unscaled + width_unscaled > win_width_unscaled) {
				debug(@"AAAA cell too wide! Change from $(width_unscaled) to $(win_width_unscaled-x_unscaled)");
				width_unscaled = win_width_unscaled - x_unscaled;
				width = win_width - x;
			} else {
				width = (int)GLib.Math.floor((x_unscaled + width_unscaled) * scaleX - x );
			}

			if (y_unscaled + height_unscaled > win_height_unscaled) {
				debug(@"AAAA cell too tall! Change from $(height_unscaled) to $(win_height_unscaled-y_unscaled)");
				height_unscaled = win_height_unscaled - y_unscaled;
				height = win_height - y;
			} else {
				height = (int)GLib.Math.floor((y_unscaled + height_unscaled) * scaleY - y );
			}
			*/
			int width = (int)GLib.Math.floor((x_unscaled + width_unscaled) * scaleX - x );
			int height = (int)GLib.Math.floor((y_unscaled + height_unscaled) * scaleY - y );

			KeyEventCell cell = this.eventCells.get(this.__move_id);
			this.__move_id += 1;
			GLib.assert( cell != null );

			cell.set_size_request(width, height);  // No effect if scaling down?!
			this.move(cell, x, y);

			x_unscaled += width_unscaled;
			x += width;
			if (vertical) {
				y_unscaled += height_unscaled;
				y += height;
			}

		}


	} //End Class KeyOverlay



	public class KeyEventCell : EventBox{

		private uint[] keysym;// or
		private int modifier_index;

		private NeoWindow winMain;
		private int width;
		private int height;
		//private Gtk.Image image;
		private ScalingImage image;
		private string image_source_id;

		public double unscaled_width;
		public double unscaled_height;

		/*
			 Die Reihenfolge der Zeichen in keysyms passt nicht
			 zur Nummerierung der Ebenen in winMain. Mit diesem Array
			 wird der Wert permutiert.
			 Achtung, mittlerweile ist es die Identitätsabbildung, da die zwei
			 redundanten Layer, die durch Caps-Lock entstehen, entfernt wurden.
		 */
		private const short[] layer_permutation = {0, 1, 2, 3, 5, 4, 6};

		private KeyEventCell.all(NeoWindow winMain, double unscaled_width, double unscaled_height, int width, int height) {
			this.winMain = winMain;
			this.width = width;
			this.height = height;
			this.unscaled_width = unscaled_width;
			this.unscaled_height = unscaled_height;

			this.image = null;
			this.image_source_id = null;

			this.set_visible_window(false); // ?!
			//debug(@"Init with $(width), $(height)");
			this.show();
		}

		public KeyEventCell(NeoWindow winMain, double unscaled_width, double unscaled_height, int width, int height, ref uint[] keysym) {
			this.all(winMain, unscaled_width, unscaled_height, width, height);
			this.keysym = keysym;

			this.button_press_event.connect ((event) => {
					if (event.button != 1) {
					return false;
					}

					uint ks = this.keysym[NeoLayoutViewer.KeyEventCell.layer_permutation[winMain.layer] - 1];
					int modi = winMain.getActiveModifierMask({4, 5}); //ctrl+alt mask
					if (ks < 1) return false;

#if _NO_WIN
					if (modi == 0 || true) {
					// Alt-Mask do not work :-(
					keysend(ks, modi);
					} else {
					//debug("Variante mit zweitem Modifier.");
					keysend2(ks, modi & Gdk.ModifierType.CONTROL_MASK, modi & Gdk.ModifierType.MOD1_MASK);
					}
#endif
					//GLib.stdout.printf(@"Key: $(ks)\n"); GLib.stdout.flush();

					return false;
			});
		}

		public KeyEventCell.modifier(NeoWindow winMain, double unscaled_width, double unscaled_height, int width, int height, int modifier_index) {
			this.all(winMain, unscaled_width, unscaled_height, width, height);
			this.modifier_index = modifier_index;

			this.button_press_event.connect ((event) => {
					if (winMain.active_modifier_by_mouse[this.modifier_index] == 0) {
					winMain.change_active_modifier( this.modifier_index, false, 1 );
					//winMain.status.set_label(@"Activate\nModifier $(this.modifier_index)");
					} else {
					winMain.change_active_modifier( this.modifier_index, false, 0 );
					//winMain.status.set_label(@"Deactivate\nModifier $(this.modifier_index)");
					}
					winMain.redraw();

					return false;
					});
		}

		public KeyEventCell.modifier2(NeoWindow winMain, double unscaled_width, double unscaled_height, int width, int height, int modifier_index, string pressed_key_image) {
			this.all(winMain, unscaled_width, unscaled_height, width, height);
			this.modifier_index = modifier_index;
			this.image_source_id = @"modifier_$(pressed_key_image)";

			// Setup of modifier image
			Gdk.Pixbuf[] modifier_pixbufs;
			if (!winMain.image_buffer.has_key(this.image_source_id)) {
				// Image of pressed Button
				modifier_pixbufs = {
					winMain.open_image_str(
							@"$(winMain.config.get("asset_folder"))/neo2.0/" +
							@"$(pressed_key_image)")
				};

				// store unscaled variant (TODO: redundant)
				winMain.image_buffer.set(this.image_source_id, modifier_pixbufs[0]);
			} else {
				modifier_pixbufs = {
					winMain.image_buffer.get(this.image_source_id)
				};
			}
			var w = modifier_pixbufs[0].width;
			var h = modifier_pixbufs[0].height;

			this.image = new ScalingImage(
					w, h, winMain,
					winMain.get_unscaled_width(), winMain.get_unscaled_height(),
					modifier_pixbufs);


			this.button_press_event.connect ((event) => {
					if (winMain.active_modifier_by_mouse[this.modifier_index] == 0) {
					winMain.change_active_modifier( 1, false, 0 );
					winMain.change_active_modifier( 2, false, 0 );
					winMain.change_active_modifier( 3, false, 0 );
					winMain.change_active_modifier( this.modifier_index, false, 1 );
					this.image.show();
					} else {
					winMain.change_active_modifier( this.modifier_index, false, 0 );
					this.image.hide();
					}

					winMain.redraw();
					return false;
					});


			add(this.image);

			Modkey mod_key = new Modkey(this.image, this.modifier_index);
			winMain.modifier_key_images.add( mod_key );


			// TODO: Handle resize event and re-evaluate this.image
		}

		public KeyEventCell.freeArea(NeoWindow winMain, double unscaled_width, double unscaled_height, int width, int height) {
			this.all(winMain, unscaled_width, unscaled_height, width, height);
		}

		/*
		 * This method Gtk+ is calling on a widget to ask
		 * the widget how large it wishes to be. It's not guaranteed
		 * that Gtk+ will actually give this size to the widget.
		 */

		public override void get_preferred_width(out int minimum_width, out int natural_width) {
			minimum_width = width;
			natural_width = width;
		}
		public override void get_preferred_height(out int minimum_height, out int natural_height) {
			minimum_height = height;
			natural_height = height;
		}

	} //End Class KeyEventCell

	// Wrapper to store array into hash map?!
	public class KeycodeArray {
		public uint[] val;
		public KeycodeArray(uint[] val) {
			this.val = val;
		}
	}

  // Define Keyboard layout NEO2
	public Gee.HashMap<int, KeycodeArray> generateKeysymsNeo2() {
			Gee.HashMap<int, KeycodeArray> keysyms = new Gee.HashMap<int, KeycodeArray>();

			/* Define keyboard layout. this object maps the keycodes to the list of keycodes of each keyboard layer. */
			keysyms.set(8, new KeycodeArray({}));
			keysyms.set( 9, new KeycodeArray({ XK_Escape, XK_Escape, XK_Escape, XK_Escape, XK_Escape }));
			keysyms.set( 10, new KeycodeArray({ XK_1, XK_degree, XK_onesuperior, XK_onesubscript, XK_ordfeminine, XK_notsign, 0 /*NoSymbol*/ }));
			keysyms.set( 11, new KeycodeArray({ XK_2, XK_section, XK_twosuperior, XK_twosubscript, XK_masculine, XK_logicalor, 0 /*NoSymbol*/ }));
			keysyms.set( 12, new KeycodeArray({ XK_3, (uint)X.string_to_keysym("U2113"), XK_threesuperior, XK_threesubscript, XK_numerosign, XK_logicaland, 0 /*NoSymbol*/ }));
			keysyms.set( 13, new KeycodeArray({ XK_4, XK_guillemotright, (uint)X.string_to_keysym("U203A"), XK_femalesymbol, 0 /*NoSymbol*/, (uint)X.string_to_keysym("U22A5"), 0 /*NoSymbol*/ }));
			keysyms.set( 14, new KeycodeArray({ XK_5, XK_guillemotleft, (uint)X.string_to_keysym("U2039"), XK_malesymbol, XK_periodcentered, (uint)X.string_to_keysym("U2221"), 0 /*NoSymbol*/ }));
			keysyms.set( 15, new KeycodeArray({ XK_6, XK_dollar, XK_cent, (uint)X.string_to_keysym("U26A5"), XK_sterling, (uint)X.string_to_keysym("U2225"), 0 /*NoSymbol*/ }));
			keysyms.set( 16, new KeycodeArray({ XK_7, XK_EuroSign, XK_yen, (uint)X.string_to_keysym("U03F0"), XK_currency, XK_rightarrow, 0 /*NoSymbol*/ }));
			keysyms.set( 17, new KeycodeArray({ XK_8, XK_doublelowquotemark, XK_singlelowquotemark, (uint)X.string_to_keysym("U27E8"), XK_Tab, (uint)X.string_to_keysym("U221E"), 0 /*NoSymbol*/ }));
			keysyms.set( 18, new KeycodeArray({ XK_9, XK_leftdoublequotemark, XK_leftsinglequotemark, (uint)X.string_to_keysym("U27E9"), XK_KP_Divide, XK_variation, 0 /*NoSymbol*/ }));
			keysyms.set( 19, new KeycodeArray({ XK_0, XK_rightdoublequotemark, XK_rightsinglequotemark, XK_zerosubscript, XK_KP_Multiply, XK_emptyset, 0 /*NoSymbol*/ }));
			keysyms.set( 20, new KeycodeArray({ XK_minus, XK_emdash, 0 /*NoSymbol*/, (uint)X.string_to_keysym("U2011"), XK_KP_Subtract, XK_hyphen, 0 /*NoSymbol*/ }));
			keysyms.set( 21, new KeycodeArray({ XK_dead_grave, XK_dead_cedilla, XK_dead_abovering, XK_dead_abovereversedcomma, XK_dead_diaeresis, XK_dead_macron, 0 /*NoSymbol*/ }));
			keysyms.set( 22, new KeycodeArray({ XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace }));
			keysyms.set( 23, new KeycodeArray({ XK_Tab, XK_ISO_Left_Tab, XK_Multi_key, XK_ISO_Level5_Lock, 0 /*NoSymbol*/, 0 /*NoSymbol*/, XK_ISO_Level5_Lock }));
			keysyms.set( 24, new KeycodeArray({ XK_x, XK_X, XK_ellipsis, XK_Greek_xi, XK_Prior, XK_Greek_XI, 0 /*NoSymbol*/ }));
			keysyms.set( 25, new KeycodeArray({ XK_v, XK_V, XK_underscore, 0 /*NoSymbol*/, XK_BackSpace, XK_radical, 0 /*NoSymbol*/ }));
			keysyms.set( 26, new KeycodeArray({ XK_l, XK_L, XK_bracketleft, XK_Greek_lamda, XK_Up, XK_Greek_LAMDA, 0 /*NoSymbol*/ }));
			keysyms.set( 27, new KeycodeArray({ XK_c, XK_C, XK_bracketright, XK_Greek_chi, XK_Delete, (uint)X.string_to_keysym("U2102"), 0 /*NoSymbol*/ }));
			keysyms.set( 28, new KeycodeArray({ XK_w, XK_W, XK_asciicircum, XK_Greek_omega, XK_Next, XK_Greek_OMEGA, 0 /*NoSymbol*/ }));
			keysyms.set( 29, new KeycodeArray({ XK_k, XK_K, XK_exclam, XK_Greek_kappa, XK_exclamdown, XK_multiply, 0 /*NoSymbol*/ }));
			keysyms.set( 30, new KeycodeArray({ XK_h, XK_H, XK_less, XK_Greek_psi, XK_KP_7, XK_Greek_PSI, 0 /*NoSymbol*/ }));
			keysyms.set( 31, new KeycodeArray({ XK_g, XK_G, XK_greater, XK_Greek_gamma, XK_KP_8, XK_Greek_GAMMA, 0 /*NoSymbol*/ }));
			keysyms.set( 32, new KeycodeArray({ XK_f, XK_F, XK_equal, XK_Greek_phi, XK_KP_9, XK_Greek_PHI, 0 /*NoSymbol*/ }));
			keysyms.set( 33, new KeycodeArray({ XK_q, XK_Q, XK_ampersand, (uint)X.string_to_keysym("U03D5"), XK_KP_Add, (uint)X.string_to_keysym("U211A"), 0 /*NoSymbol*/ }));
			keysyms.set( 34, new KeycodeArray({ XK_ssharp, (uint)X.string_to_keysym("U1E9E"), (uint)X.string_to_keysym("U017F"), XK_Greek_finalsmallsigma, (uint)X.string_to_keysym("U2212"), XK_jot, 0 /*NoSymbol*/ }));
			keysyms.set( 35, new KeycodeArray({ XK_dead_acute, XK_dead_tilde, XK_dead_stroke, XK_dead_abovecomma, XK_dead_doubleacute, XK_dead_breve, 0 /*NoSymbol*/ }));
			keysyms.set( 36, new KeycodeArray({ XK_Return, XK_Return, XK_Return, XK_Return, XK_Return }));
			keysyms.set( 37, new KeycodeArray({ XK_Control_L, XK_Control_L, XK_Control_L, XK_Control_L, XK_Control_L }));
			keysyms.set( 38, new KeycodeArray({ XK_u, XK_U, XK_backslash, 0 /*NoSymbol*/, XK_Home, XK_includedin, 0 /*NoSymbol*/ }));
			keysyms.set( 39, new KeycodeArray({ XK_i, XK_I, XK_slash, XK_Greek_iota, XK_Left, XK_integral, 0 /*NoSymbol*/ }));
			keysyms.set( 40, new KeycodeArray({ XK_a, XK_A, XK_braceleft, XK_Greek_alpha, XK_Down, (uint)X.string_to_keysym("U2200"), 0 /*NoSymbol*/ }));
			keysyms.set( 41, new KeycodeArray({ XK_e, XK_E, XK_braceright, XK_Greek_epsilon, XK_Right, (uint)X.string_to_keysym("U2203"), 0 /*NoSymbol*/ }));
			keysyms.set( 42, new KeycodeArray({ XK_o, XK_O, XK_asterisk, XK_Greek_omicron, XK_End, XK_elementof, 0 /*NoSymbol*/ }));
			keysyms.set( 43, new KeycodeArray({ XK_s, XK_S, XK_question, XK_Greek_sigma, XK_questiondown, XK_Greek_SIGMA, 0 /*NoSymbol*/ }));
			keysyms.set( 44, new KeycodeArray({ XK_n, XK_N, XK_parenleft, XK_Greek_nu, XK_KP_4, (uint)X.string_to_keysym("U2115"), 0 /*NoSymbol*/ }));
			keysyms.set( 45, new KeycodeArray({ XK_r, XK_R, XK_parenright, XK_Greek_rho, XK_KP_5, (uint)X.string_to_keysym("U211D"), 0 /*NoSymbol*/ }));
			keysyms.set( 46, new KeycodeArray({ XK_t, XK_T, XK_minus, XK_Greek_tau, XK_KP_6, XK_partialderivative, 0 /*NoSymbol*/ }));
			keysyms.set( 47, new KeycodeArray({ XK_d, XK_D, XK_colon, XK_Greek_delta, XK_KP_Separator, XK_Greek_DELTA, 0 /*NoSymbol*/ }));
			keysyms.set( 48, new KeycodeArray({ XK_y, XK_Y, XK_at, XK_Greek_upsilon, XK_period, XK_nabla, 0 /*NoSymbol*/ }));
			keysyms.set( 49, new KeycodeArray({ XK_dead_circumflex, XK_dead_caron, (uint)X.string_to_keysym("U21BB"), (uint)X.string_to_keysym("U02DE"), XK_dead_abovedot, XK_dead_belowdot, 0 /*NoSymbol*/ }));
			keysyms.set( 50, new KeycodeArray({ XK_Shift_L, XK_Caps_Lock }));
			keysyms.set( 51, new KeycodeArray({ XK_ISO_Level3_Shift }));
			keysyms.set( 52, new KeycodeArray({ XK_udiaeresis, XK_Udiaeresis, XK_numbersign, 0 /*NoSymbol*/, XK_Escape, XK_union, 0 /*NoSymbol*/ }));
			keysyms.set( 53, new KeycodeArray({ XK_odiaeresis, XK_Odiaeresis, XK_dollar, (uint)X.string_to_keysym("U03F5"), XK_Tab, XK_intersection, 0 /*NoSymbol*/ }));
			keysyms.set( 54, new KeycodeArray({ XK_adiaeresis, XK_Adiaeresis, XK_bar, XK_Greek_eta, XK_Insert, (uint)X.string_to_keysym("U2135"), 0 /*NoSymbol*/ }));
			keysyms.set( 55, new KeycodeArray({ XK_p, XK_P, XK_asciitilde, XK_Greek_pi, XK_Return, XK_Greek_PI, 0 /*NoSymbol*/ }));
			keysyms.set( 56, new KeycodeArray({ XK_z, XK_Z, XK_grave, XK_Greek_zeta, XK_Undo, (uint)X.string_to_keysym("U2124"), 0 /*NoSymbol*/ }));
			keysyms.set( 57, new KeycodeArray({ XK_b, XK_B, XK_plus, XK_Greek_beta, XK_colon, (uint)X.string_to_keysym("U21D0"), 0 /*NoSymbol*/ }));
			keysyms.set( 58, new KeycodeArray({ XK_m, XK_M, XK_percent, XK_Greek_mu, XK_KP_1, XK_ifonlyif, 0 /*NoSymbol*/ }));
			keysyms.set( 59, new KeycodeArray({ XK_comma, XK_endash, XK_quotedbl, (uint)X.string_to_keysym("U03F1"), XK_KP_2, (uint)X.string_to_keysym("U21D2"), 0 /*NoSymbol*/ }));
			keysyms.set( 60, new KeycodeArray({ XK_period, XK_enfilledcircbullet, XK_apostrophe, (uint)X.string_to_keysym("U03D1"), XK_KP_3, (uint)X.string_to_keysym("U21A6"), 0 /*NoSymbol*/ }));
			keysyms.set( 61, new KeycodeArray({ XK_j, XK_J, XK_semicolon, XK_Greek_theta, XK_semicolon, XK_Greek_THETA, 0 /*NoSymbol*/ }));
			keysyms.set( 62, new KeycodeArray({ XK_Shift_R, XK_Caps_Lock }));
			keysyms.set( 63, new KeycodeArray({ XK_KP_Multiply, XK_KP_Multiply, (uint)X.string_to_keysym("U2219"), (uint)X.string_to_keysym("U2299"), XK_multiply, (uint)X.string_to_keysym("U2297"), 0 /*NoSymbol*/ }));
			keysyms.set( 64, new KeycodeArray({ XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L }));
			keysyms.set( 65, new KeycodeArray({ XK_space, XK_space, XK_space, XK_nobreakspace, XK_KP_0, (uint)X.string_to_keysym("U202F"), 0 /*NoSymbol*/ }));
			keysyms.set( 66, new KeycodeArray({ XK_ISO_Level3_Shift }));
			keysyms.set( 67, new KeycodeArray({ XK_F1, 0 /*XK_XF86_Switch_VT_1*/ }));
			keysyms.set( 68, new KeycodeArray({ XK_F2, 0 /*XK_XF86_Switch_VT_2*/ }));
			keysyms.set( 69, new KeycodeArray({ XK_F3, 0 /*XK_XF86_Switch_VT_3*/ }));
			keysyms.set( 70, new KeycodeArray({ XK_F4, 0 /*XK_XF86_Switch_VT_4*/ }));
			keysyms.set( 71, new KeycodeArray({ XK_F5, 0 /*XK_XF86_Switch_VT_5*/ }));
			keysyms.set( 72, new KeycodeArray({ XK_F6, 0 /*XK_XF86_Switch_VT_6*/ }));
			keysyms.set( 73, new KeycodeArray({ XK_F7, 0 /*XK_XF86_Switch_VT_7*/ }));
			keysyms.set( 74, new KeycodeArray({ XK_F8, 0 /*XK_XF86_Switch_VT_8*/ }));
			keysyms.set( 75, new KeycodeArray({ XK_F9, 0 /*XK_XF86_Switch_VT_9*/ }));
			keysyms.set( 76, new KeycodeArray({ XK_F10, 0 /*XK_XF86_Switch_VT_10*/ }));
			keysyms.set( 77, new KeycodeArray({ XK_Tab, XK_ISO_Left_Tab, XK_equal, XK_approxeq, XK_notequal, XK_identical, 0 /*NoSymbol*/ }));
			keysyms.set( 78, new KeycodeArray({ XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock }));
			keysyms.set( 79, new KeycodeArray({ XK_KP_7, (uint)X.string_to_keysym("U2714"), (uint)X.string_to_keysym("U2195"), (uint)X.string_to_keysym("U226A"), XK_KP_Home, XK_upstile, 0 /*NoSymbol*/ }));
			keysyms.set( 80, new KeycodeArray({ XK_KP_8, (uint)X.string_to_keysym("U2718"), XK_uparrow, XK_intersection, XK_KP_Up, (uint)X.string_to_keysym("U22C2"),
						0 /*NoSymbol*/ }));
			keysyms.set( 81, new KeycodeArray({ XK_KP_9, XK_dagger, (uint)X.string_to_keysym("U20D7"), (uint)X.string_to_keysym("U226B"), XK_KP_Prior, (uint)X.string_to_keysym("U2309"), 0 /*NoSymbol*/ }));
			keysyms.set( 82, new KeycodeArray({ XK_KP_Subtract, XK_KP_Subtract, (uint)X.string_to_keysym("U2212"), (uint)X.string_to_keysym("U2296"), (uint)X.string_to_keysym("U2216"), (uint)X.string_to_keysym("U2238"), 0 /*NoSymbol*/ }));
			keysyms.set( 83, new KeycodeArray({ XK_KP_4, XK_club, XK_leftarrow, XK_includedin, XK_KP_Left, (uint)X.string_to_keysym("U2286"), 0 /*NoSymbol*/ }));
			keysyms.set( 84, new KeycodeArray({ XK_KP_5, XK_EuroSign, XK_colon, (uint)X.string_to_keysym("U22B6"), XK_KP_Begin, (uint)X.string_to_keysym("U22B7"), 0 /*NoSymbol*/ }));
			keysyms.set( 85, new KeycodeArray({ XK_KP_6, (uint)X.string_to_keysym("U2023"), XK_rightarrow, XK_includes, XK_KP_Right, (uint)X.string_to_keysym("U2287"), 0 /*NoSymbol*/ }));
			keysyms.set( 86, new KeycodeArray({ XK_KP_Add, XK_KP_Add, XK_plusminus, (uint)X.string_to_keysym("U2295"), (uint)X.string_to_keysym("U2213"), (uint)X.string_to_keysym("U2214"), 0 /*NoSymbol*/ }));
			keysyms.set( 87, new KeycodeArray({ XK_KP_1, XK_diamond, (uint)X.string_to_keysym("U2194"), XK_lessthanequal, XK_KP_End, XK_downstile, 0 /*NoSymbol*/ }));
			keysyms.set( 88, new KeycodeArray({ XK_KP_2, XK_heart, XK_downarrow, XK_union, XK_KP_Down, (uint)X.string_to_keysym("U22C3"), 0 /*NoSymbol*/ }));
			keysyms.set( 89, new KeycodeArray({ XK_KP_3, (uint)X.string_to_keysym("U2660"), (uint)X.string_to_keysym("U21CC"), XK_greaterthanequal, XK_KP_Next, (uint)X.string_to_keysym("U230B"), 0 /*NoSymbol*/ }));
			keysyms.set( 90, new KeycodeArray({ XK_KP_0, (uint)X.string_to_keysym("U2423"), XK_percent, (uint)X.string_to_keysym("U2030"), XK_KP_Insert, (uint)X.string_to_keysym("U25A1"), 0 /*NoSymbol*/ }));
			keysyms.set( 91, new KeycodeArray({ XK_KP_Separator, XK_period, XK_comma, XK_minutes, XK_KP_Delete, XK_seconds, 0 /*NoSymbol*/ }));
			keysyms.set( 92, new KeycodeArray({ XK_ISO_Level3_Shift }));
			keysyms.set( 93, new KeycodeArray({ }));
			keysyms.set( 94, new KeycodeArray({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock }));
			keysyms.set( 95, new KeycodeArray({ XK_F11, 0 /*XK_XF86_Switch_VT_11*/ }));
			keysyms.set( 96, new KeycodeArray({ XK_F12, 0 /*XK_XF86_Switch_VT_12*/ }));
			keysyms.set( 97, new KeycodeArray({ }));
			keysyms.set( 98, new KeycodeArray({ XK_Katakana }));
			keysyms.set( 99, new KeycodeArray({ XK_Hiragana }));
			keysyms.set(100, new KeycodeArray({ XK_Henkan_Mode }));
			keysyms.set(101, new KeycodeArray({ XK_Hiragana_Katakana }));
			keysyms.set(102, new KeycodeArray({ XK_Muhenkan }));
			keysyms.set(103, new KeycodeArray({ }));
			keysyms.set(104, new KeycodeArray({ XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, 0 /*NoSymbol*/ }));
			keysyms.set(105, new KeycodeArray({ XK_Control_R, XK_Control_R, XK_Control_R, XK_Control_R, XK_Control_R }));
			keysyms.set(106, new KeycodeArray({ XK_KP_Divide, XK_KP_Divide, XK_division, (uint)X.string_to_keysym("U2300"), (uint)X.string_to_keysym("U2215"), (uint)X.string_to_keysym("U2223"), 0 /*NoSymbol*/ }));
			keysyms.set(107, new KeycodeArray({ XK_Print, XK_Sys_Req }));
			keysyms.set(108, new KeycodeArray({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock }));
			keysyms.set(109, new KeycodeArray({ XK_Linefeed, XK_Linefeed, XK_Linefeed, XK_Linefeed, XK_Linefeed }));
			keysyms.set(110, new KeycodeArray({ XK_Home, XK_Home, XK_Home, XK_Home, XK_Home }));
			keysyms.set(111, new KeycodeArray({ XK_Up, XK_Up, XK_Up, XK_Up, XK_Up }));
			keysyms.set(112, new KeycodeArray({ XK_Prior, XK_Prior, XK_Prior, XK_Prior, XK_Prior }));
			keysyms.set(113, new KeycodeArray({ XK_Left, XK_Left, XK_Left, XK_Left, XK_Left }));
			keysyms.set(114, new KeycodeArray({ XK_Right, XK_Right, XK_Right, XK_Right, XK_Right }));
			keysyms.set(115, new KeycodeArray({ XK_End, XK_End, XK_End, XK_End, XK_End }));
			keysyms.set(116, new KeycodeArray({ XK_Down, XK_Down, XK_Down, XK_Down, XK_Down }));
			keysyms.set(117, new KeycodeArray({ XK_Next, XK_Next, XK_Next, XK_Next, XK_Next }));
			keysyms.set(118, new KeycodeArray({ XK_Insert, XK_Insert, XK_Insert, XK_Insert, XK_Insert }));
			keysyms.set(119, new KeycodeArray({ XK_Delete, XK_Delete, XK_Delete, XK_Delete, XK_Delete }));
			keysyms.set(120, new KeycodeArray({ }));
			keysyms.set(121, new KeycodeArray({ 0 /*XK_XF86AudioMute*/ }));
			keysyms.set(122, new KeycodeArray({ 0 /*XK_XF86AudioLowerVolume*/ }));
			keysyms.set(123, new KeycodeArray({ 0 /*XK_XF86AudioRaiseVolume*/ }));
			keysyms.set(124, new KeycodeArray({ 0 /*XK_XF86PowerOff*/ }));
			keysyms.set(125, new KeycodeArray({ XK_KP_Equal, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/ }));
			keysyms.set(126, new KeycodeArray({ XK_plusminus }));
			keysyms.set(127, new KeycodeArray({ XK_Pause, XK_Break }));
			keysyms.set(128, new KeycodeArray({ 0 /*XK_XF86LaunchA*/ }));
			keysyms.set(129, new KeycodeArray({ XK_KP_Decimal }));
			keysyms.set(130, new KeycodeArray({ XK_Hangul }));
			keysyms.set(131, new KeycodeArray({ XK_Hangul_Hanja }));
			keysyms.set(132, new KeycodeArray({ }));
			keysyms.set(133, new KeycodeArray({ XK_Super_L }));
			keysyms.set(134, new KeycodeArray({ XK_Super_R }));
			keysyms.set(135, new KeycodeArray({ XK_Menu }));
			keysyms.set(136, new KeycodeArray({ XK_Cancel }));
			keysyms.set(137, new KeycodeArray({ XK_Redo }));
			keysyms.set(138, new KeycodeArray({ 0 /*XK_SunProps*/ }));
			keysyms.set(139, new KeycodeArray({ XK_Undo }));
			keysyms.set(140, new KeycodeArray({ 0 /*XK_SunFront*/ }));
			keysyms.set(141, new KeycodeArray({ 0 /*XK_XF86Copy*/ }));
			keysyms.set(142, new KeycodeArray({ 0 /*XK_SunOpen*/ }));
			keysyms.set(143, new KeycodeArray({ 0 /*XK_XF86Paste*/ }));
			keysyms.set(144, new KeycodeArray({ XK_Find }));
			keysyms.set(145, new KeycodeArray({ 0 /*XK_XF86Cut*/ }));
			keysyms.set(146, new KeycodeArray({ XK_Help }));
			keysyms.set(147, new KeycodeArray({ 0 /*XK_XF86MenuKB*/ }));
			keysyms.set(148, new KeycodeArray({ 0 /*XK_XF86Calculator*/ }));
			keysyms.set(149, new KeycodeArray({ }));
			keysyms.set(150, new KeycodeArray({ 0 /*XK_XF86Sleep*/ }));
			keysyms.set(151, new KeycodeArray({ 0 /*XK_XF86WakeUp*/ }));
			keysyms.set(152, new KeycodeArray({ 0 /*XK_XF86Explorer*/ }));
			keysyms.set(153, new KeycodeArray({ 0 /*XK_XF86Send*/ }));
			keysyms.set(154, new KeycodeArray({ }));
			keysyms.set(155, new KeycodeArray({ 0 /*XK_XF86Xfer*/ }));
			keysyms.set(156, new KeycodeArray({ 0 /*XK_XF86Launch1*/ }));
			keysyms.set(157, new KeycodeArray({ 0 /*XK_XF86Launch2*/ }));
			keysyms.set(158, new KeycodeArray({ 0 /*XK_XF86WWW*/ }));
			keysyms.set(159, new KeycodeArray({ 0 /*XK_XF86DOS*/ }));
			keysyms.set(160, new KeycodeArray({ 0 /*XK_XF86ScreenSaver*/ }));
			keysyms.set(161, new KeycodeArray({ }));
			keysyms.set(162, new KeycodeArray({ 0 /*XK_XF86RotateWindows*/ }));
			keysyms.set(163, new KeycodeArray({ 0 /*XK_XF86Mail*/ }));
			keysyms.set(164, new KeycodeArray({ 0 /*XK_XF86Favorites*/ }));
			keysyms.set(165, new KeycodeArray({ 0 /*XK_XF86MyComputer*/ }));
			keysyms.set(166, new KeycodeArray({ 0 /*XK_XF86Back*/ }));
			keysyms.set(167, new KeycodeArray({ 0 /*XK_XF86Forward*/ }));
			keysyms.set(168, new KeycodeArray({ }));
			keysyms.set(169, new KeycodeArray({ 0 /*XK_XF86Eject*/ }));
			keysyms.set(170, new KeycodeArray({ 0 /*XK_XF86Eject*/, 0 /*XK_XF86Eject*/ }));
			keysyms.set(171, new KeycodeArray({ 0 /*XK_XF86AudioNext*/ }));
			keysyms.set(172, new KeycodeArray({ 0 /*XK_XF86AudioPlay*/, 0 /*XK_XF86AudioPause*/ }));
			keysyms.set(173, new KeycodeArray({ 0 /*XK_XF86AudioPrev*/ }));
			keysyms.set(174, new KeycodeArray({ 0 /*XK_XF86AudioStop*/, 0 /*XK_XF86Eject*/ }));
			keysyms.set(175, new KeycodeArray({ 0 /*XK_XF86AudioRecord*/ }));
			keysyms.set(176, new KeycodeArray({ 0 /*XK_XF86AudioRewind*/ }));
			keysyms.set(177, new KeycodeArray({ 0 /*XK_XF86Phone*/ }));
			keysyms.set(178, new KeycodeArray({ }));
			keysyms.set(179, new KeycodeArray({ 0 /*XK_XF86Tools*/ }));
			keysyms.set(180, new KeycodeArray({ 0 /*XK_XF86HomePage*/ }));
			keysyms.set(181, new KeycodeArray({ 0 /*XK_XF86Reload*/ }));
			keysyms.set(182, new KeycodeArray({ 0 /*XK_XF86Close*/ }));
			keysyms.set(183, new KeycodeArray({ }));
			keysyms.set(184, new KeycodeArray({ }));
			keysyms.set(185, new KeycodeArray({ 0 /*XK_XF86ScrollUp*/ }));
			keysyms.set(186, new KeycodeArray({ 0 /*XK_XF86ScrollDown*/ }));
			keysyms.set(187, new KeycodeArray({ XK_parenleft }));
			keysyms.set(188, new KeycodeArray({ XK_parenright }));
			keysyms.set(189, new KeycodeArray({ 0 /*XK_XF86New*/ }));
			keysyms.set(190, new KeycodeArray({ XK_Redo }));
			keysyms.set(191, new KeycodeArray({ 0 /*XK_XF86Tools*/ }));
			keysyms.set(192, new KeycodeArray({ 0 /*XK_XF86Launch5*/ }));
			keysyms.set(193, new KeycodeArray({ 0 /*XK_XF86MenuKB*/ }));
			keysyms.set(194, new KeycodeArray({ }));
			keysyms.set(195, new KeycodeArray({ }));
			keysyms.set(196, new KeycodeArray({ }));
			keysyms.set(197, new KeycodeArray({ }));
			keysyms.set(198, new KeycodeArray({ }));
			keysyms.set(199, new KeycodeArray({ }));
			keysyms.set(200, new KeycodeArray({ 0 /*XK_XF86TouchpadToggle*/ }));
			keysyms.set(201, new KeycodeArray({ }));
			keysyms.set(202, new KeycodeArray({ }));
			keysyms.set(203, new KeycodeArray({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift }));
			keysyms.set(204, new KeycodeArray({ XK_Alt_L }));
			keysyms.set(205, new KeycodeArray({ XK_Alt_L }));
			keysyms.set(206, new KeycodeArray({ XK_Super_L }));
			keysyms.set(207, new KeycodeArray({ }));
			keysyms.set(208, new KeycodeArray({ 0 /*XK_XF86AudioPlay*/ }));
			keysyms.set(209, new KeycodeArray({ 0 /*XK_XF86AudioPause*/ }));
			keysyms.set(210, new KeycodeArray({ 0 /*XK_XF86Launch3*/ }));
			keysyms.set(211, new KeycodeArray({ 0 /*XK_XF86Launch4*/ }));
			keysyms.set(212, new KeycodeArray({ 0 /*XK_XF86LaunchB*/ }));
			keysyms.set(213, new KeycodeArray({ 0 /*XK_XF86Suspend*/ }));
			keysyms.set(214, new KeycodeArray({ 0 /*XK_XF86Close*/ }));
			keysyms.set(215, new KeycodeArray({ 0 /*XK_XF86AudioPlay*/ }));
			keysyms.set(216, new
					KeycodeArray({ 0 /*XK_XF86AudioForward*/ }));
			keysyms.set(217, new KeycodeArray({ }));
			keysyms.set(218, new KeycodeArray({ XK_Print }));
			keysyms.set(219, new KeycodeArray({ }));
			keysyms.set(220, new KeycodeArray({ 0 /*XK_XF86WebCam*/ }));
			keysyms.set(221, new KeycodeArray({ }));
			keysyms.set(222, new KeycodeArray({ }));
			keysyms.set(223, new KeycodeArray({ 0 /*XK_XF86Mail*/ }));
			keysyms.set(224, new KeycodeArray({ }));
			keysyms.set(225, new KeycodeArray({ 0 /*XK_XF86Search*/ }));
			keysyms.set(226, new KeycodeArray({ }));
			keysyms.set(227, new KeycodeArray({ 0 /*XK_XF86Finance*/ }));
			keysyms.set(228, new KeycodeArray({ }));
			keysyms.set(229, new KeycodeArray({ 0 /*XK_XF86Shop*/ }));
			keysyms.set(230, new KeycodeArray({ }));
			keysyms.set(231, new KeycodeArray({ XK_Cancel }));
			keysyms.set(232, new KeycodeArray({ 0 /*XK_XF86MonBrightnessDown*/ }));
			keysyms.set(233, new KeycodeArray({ 0 /*XK_XF86MonBrightnessUp*/ }));
			keysyms.set(234, new KeycodeArray({ 0 /*XK_XF86AudioMedia*/ }));
			keysyms.set(235, new KeycodeArray({ 0 /*XK_XF86Display*/ }));
			keysyms.set(236, new KeycodeArray({ 0 /*XK_XF86KbdLightOnOff*/ }));
			keysyms.set(237, new KeycodeArray({ 0 /*XK_XF86KbdBrightnessDown*/ }));
			keysyms.set(238, new KeycodeArray({ 0 /*XK_XF86KbdBrightnessUp*/ }));
			keysyms.set(239, new KeycodeArray({ 0 /*XK_XF86Send*/ }));
			keysyms.set(240, new KeycodeArray({ 0 /*XK_XF86Reply*/ }));
			keysyms.set(241, new KeycodeArray({ 0 /*XK_XF86MailForward*/ }));
			keysyms.set(242, new KeycodeArray({ 0 /*XK_XF86Save*/ }));
			keysyms.set(243, new KeycodeArray({ 0 /*XK_XF86Documents*/ }));
			keysyms.set(244, new KeycodeArray({ 0 /*XK_XF86Battery*/ }));
			keysyms.set(245, new KeycodeArray({ 0 /*XK_XF86Bluetooth*/ }));
			keysyms.set(246, new KeycodeArray({ 0 /*XK_XF86WLAN*/ }));
			keysyms.set(247, new KeycodeArray({ }));
			keysyms.set(248, new KeycodeArray({ }));
			keysyms.set(249, new KeycodeArray({ }));
			keysyms.set(250, new KeycodeArray({ }));
			keysyms.set(251, new KeycodeArray({ }));
			keysyms.set(252, new KeycodeArray({ }));
			keysyms.set(253, new KeycodeArray({ }));
			keysyms.set(254, new KeycodeArray({ }));
			keysyms.set(255, new KeycodeArray({ }));

			return keysyms;
		}

  // Define Keyboard layout ADNW (Aus der Neo Welt)
	public Gee.HashMap<int, KeycodeArray> generateKeysymsAdnw() {
			Gee.HashMap<int, KeycodeArray> keysyms = new Gee.HashMap<int, KeycodeArray>();

			/* Define keyboard layout. this object maps the keycodes to the list of keycodes of each keyboard layer. */
			keysyms.set(8, new KeycodeArray({}));
			keysyms.set( 9, new KeycodeArray({ XK_Escape, XK_Escape, XK_Escape, XK_Escape, XK_Escape }));
			keysyms.set( 10, new KeycodeArray({ XK_1, XK_degree, XK_onesuperior, XK_onesubscript, XK_ordfeminine, XK_notsign, 0 /*NoSymbol*/ }));
			keysyms.set( 11, new KeycodeArray({ XK_2, XK_section, XK_twosuperior, XK_twosubscript, XK_masculine, XK_logicalor, 0 /*NoSymbol*/ }));
			keysyms.set( 12, new KeycodeArray({ XK_3, (uint)X.string_to_keysym("U2113"), XK_threesuperior, XK_threesubscript, XK_numerosign, XK_logicaland, 0 /*NoSymbol*/ }));
			keysyms.set( 13, new KeycodeArray({ XK_4, XK_guillemotright, (uint)X.string_to_keysym("U203A"), XK_femalesymbol, 0 /*NoSymbol*/, (uint)X.string_to_keysym("U22A5"), 0 /*NoSymbol*/ }));
			keysyms.set( 14, new KeycodeArray({ XK_5, XK_guillemotleft, (uint)X.string_to_keysym("U2039"), XK_malesymbol, XK_periodcentered, (uint)X.string_to_keysym("U2221"), 0 /*NoSymbol*/ }));
			keysyms.set( 15, new KeycodeArray({ XK_6, XK_dollar, XK_cent, (uint)X.string_to_keysym("U26A5"), XK_sterling, (uint)X.string_to_keysym("U2225"), 0 /*NoSymbol*/ }));
			keysyms.set( 16, new KeycodeArray({ XK_7, XK_EuroSign, XK_yen, (uint)X.string_to_keysym("U03F0"), XK_currency, XK_rightarrow, 0 /*NoSymbol*/ }));
			keysyms.set( 17, new KeycodeArray({ XK_8, XK_doublelowquotemark, XK_singlelowquotemark, (uint)X.string_to_keysym("U27E8"), XK_Tab, (uint)X.string_to_keysym("U221E"), 0 /*NoSymbol*/ }));
			keysyms.set( 18, new KeycodeArray({ XK_9, XK_leftdoublequotemark, XK_leftsinglequotemark, (uint)X.string_to_keysym("U27E9"), XK_KP_Divide, XK_variation, 0 /*NoSymbol*/ }));
			keysyms.set( 19, new KeycodeArray({ XK_0, XK_rightdoublequotemark, XK_rightsinglequotemark, XK_zerosubscript, XK_KP_Multiply, XK_emptyset, 0 /*NoSymbol*/ }));
			keysyms.set( 20, new KeycodeArray({ XK_minus, XK_emdash, 0 /*NoSymbol*/, (uint)X.string_to_keysym("U2011"), XK_KP_Subtract, XK_hyphen, 0 /*NoSymbol*/ }));
			keysyms.set( 21, new KeycodeArray({ XK_dead_grave, XK_dead_cedilla, XK_dead_abovering, XK_dead_abovereversedcomma, XK_dead_diaeresis, XK_dead_macron, 0 /*NoSymbol*/ }));
			keysyms.set( 22, new KeycodeArray({ XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace }));
			keysyms.set( 23, new KeycodeArray({ XK_Tab, XK_ISO_Left_Tab, XK_Multi_key, XK_ISO_Level5_Lock, 0 /*NoSymbol*/, 0 /*NoSymbol*/, XK_ISO_Level5_Lock }));
			keysyms.set( 24, new KeycodeArray({ XK_k, XK_K, XK_ellipsis, XK_Greek_kappa, XK_Prior, XK_multiply, 0 /*NoSymbol*/ }));
			keysyms.set( 25, new KeycodeArray({ XK_u, XK_U, XK_underscore, 0 /*NoSymbol*/, XK_BackSpace, XK_includedin, 0 /*NoSymbol*/ }));
			keysyms.set( 26, new KeycodeArray({ XK_udiaeresis, XK_Udiaeresis, XK_bracketleft, 0 /*NoSymbol*/, XK_Up, XK_union, 0 /*NoSymbol*/ }));
			keysyms.set( 27, new KeycodeArray({ XK_period, XK_enfilledcircbullet, XK_bracketright, (uint)X.string_to_keysym("U03D1"), XK_Delete, (uint)X.string_to_keysym("U21A6"), 0 /*NoSymbol*/ }));
			keysyms.set( 28, new KeycodeArray({ XK_adiaeresis, XK_Adiaeresis, XK_asciicircum, XK_Greek_eta, XK_Next, (uint)X.string_to_keysym("U2135"), 0 /*NoSymbol*/ }));
			keysyms.set( 29, new KeycodeArray({ XK_v, XK_V, XK_exclam, 0 /*NoSymbol*/, XK_exclamdown, XK_radical, 0 /*NoSymbol*/ }));
			keysyms.set( 30, new KeycodeArray({ XK_g, XK_G, XK_less, XK_Greek_gamma, XK_KP_7, XK_Greek_GAMMA, 0 /*NoSymbol*/ }));
			keysyms.set( 31, new KeycodeArray({ XK_c, XK_C, XK_greater, XK_Greek_chi, XK_KP_8, (uint)X.string_to_keysym("U2102"), 0 /*NoSymbol*/ }));
			keysyms.set( 32, new KeycodeArray({ XK_l, XK_L, XK_equal, XK_Greek_lamda, XK_KP_9, XK_Greek_LAMDA, 0 /*NoSymbol*/ }));
			keysyms.set( 33, new KeycodeArray({ XK_j, XK_J, XK_ampersand, XK_Greek_theta, XK_KP_Add, XK_Greek_THETA, 0 /*NoSymbol*/ }));
			keysyms.set( 34, new KeycodeArray({ XK_f, XK_F, (uint)X.string_to_keysym("U017F"), XK_Greek_phi, (uint)X.string_to_keysym("U2212"), XK_Greek_PHI, 0 /*NoSymbol*/ }));
			keysyms.set( 35, new KeycodeArray({ XK_dead_acute, XK_dead_tilde, XK_dead_stroke, XK_dead_abovecomma, XK_dead_doubleacute, XK_dead_breve, 0 /*NoSymbol*/ }));
			keysyms.set( 36, new KeycodeArray({ XK_Return, XK_Return, XK_Return, XK_Return, XK_Return }));
			keysyms.set( 37, new KeycodeArray({ XK_Control_L, XK_Control_L, XK_Control_L, XK_Control_L, XK_Control_L }));
			keysyms.set( 38, new KeycodeArray({ XK_h, XK_H, XK_backslash, XK_Greek_psi, XK_Home, XK_Greek_PSI, 0 /*NoSymbol*/ }));
			keysyms.set( 39, new KeycodeArray({ XK_i, XK_I, XK_slash, XK_Greek_iota, XK_Left, XK_integral, 0 /*NoSymbol*/ }));
			keysyms.set( 40, new KeycodeArray({ XK_e, XK_E, XK_braceleft, XK_Greek_epsilon, XK_Down, (uint)X.string_to_keysym("U2203"), 0 /*NoSymbol*/ }));
			keysyms.set( 41, new KeycodeArray({ XK_a, XK_A, XK_braceright, XK_Greek_alpha, XK_Right, (uint)X.string_to_keysym("U2200"), 0 /*NoSymbol*/ }));
			keysyms.set( 42, new KeycodeArray({ XK_o, XK_O, XK_asterisk, XK_Greek_omicron, XK_End, XK_elementof, 0 /*NoSymbol*/ }));
			keysyms.set( 43, new KeycodeArray({ XK_d, XK_D, XK_question, XK_Greek_delta, XK_questiondown, XK_Greek_DELTA, 0 /*NoSymbol*/ }));
			keysyms.set( 44, new KeycodeArray({ XK_t, XK_T, XK_parenleft, XK_Greek_tau, XK_KP_4, XK_partialderivative, 0 /*NoSymbol*/ }));
			keysyms.set( 45, new KeycodeArray({ XK_r, XK_R, XK_parenright, XK_Greek_rho, XK_KP_5, (uint)X.string_to_keysym("U211D"), 0 /*NoSymbol*/ }));
			keysyms.set( 46, new KeycodeArray({ XK_n, XK_N, XK_minus, XK_Greek_nu, XK_KP_6, (uint)X.string_to_keysym("U2115"), 0 /*NoSymbol*/ }));
			keysyms.set( 47, new KeycodeArray({ XK_s, XK_S, XK_colon, XK_Greek_sigma, XK_KP_Separator, XK_Greek_SIGMA, 0 /*NoSymbol*/ }));
			keysyms.set( 48, new KeycodeArray({ XK_ssharp, (uint)X.string_to_keysym("U1E9E"), XK_at, XK_Greek_finalsmallsigma, XK_jot, 0 /*NoSymbol*/ }));
			keysyms.set( 49, new KeycodeArray({ XK_dead_circumflex, XK_dead_caron, (uint)X.string_to_keysym("U21BB"), (uint)X.string_to_keysym("U02DE"), XK_dead_abovedot, XK_dead_belowdot, 0 /*NoSymbol*/ }));
			keysyms.set( 50, new KeycodeArray({ XK_Shift_L, XK_Caps_Lock }));
			keysyms.set( 51, new KeycodeArray({ XK_ISO_Level3_Shift }));
			keysyms.set( 52, new KeycodeArray({ XK_x, XK_X, XK_numbersign, XK_Greek_xi, XK_Escape, XK_Greek_XI, 0 /*NoSymbol*/ }));
			keysyms.set( 53, new KeycodeArray({ XK_y, XK_Y, XK_dollar, XK_Greek_upsilon, XK_Tab, XK_nabla, 0 /*NoSymbol*/ }));
			keysyms.set( 54, new KeycodeArray({ XK_odiaeresis, XK_Odiaeresis, XK_bar, (uint)X.string_to_keysym("U03F5"), XK_Insert, XK_intersection, 0 /*NoSymbol*/ }));
			keysyms.set( 55, new KeycodeArray({ XK_comma, XK_endash, XK_asciitilde, (uint)X.string_to_keysym("U03F1"), XK_Return, (uint)X.string_to_keysym("U21D2"), 0 /*NoSymbol*/ }));
			keysyms.set( 56, new KeycodeArray({ XK_q, XK_Q, XK_grave, (uint)X.string_to_keysym("U03D5"), XK_Undo, (uint)X.string_to_keysym("U211A"), 0 /*NoSymbol*/ }));
			keysyms.set( 57, new KeycodeArray({ XK_b, XK_B, XK_plus, XK_Greek_beta, XK_colon, (uint)X.string_to_keysym("U21D0"), 0 /*NoSymbol*/ }));
			keysyms.set( 58, new KeycodeArray({ XK_p, XK_P, XK_percent, XK_Greek_pi, XK_KP_1, XK_Greek_PI, 0 /*NoSymbol*/ }));
			keysyms.set( 59, new KeycodeArray({ XK_w, XK_W, XK_quotedbl, XK_Greek_omega, XK_KP_2, XK_Greek_OMEGA, 0 /*NoSymbol*/ }));
			keysyms.set( 60, new KeycodeArray({ XK_m, XK_M, XK_apostrophe, XK_Greek_mu, XK_KP_3, XK_ifonlyif, 0 /*NoSymbol*/ }));
			keysyms.set( 61, new KeycodeArray({ XK_z, XK_Z, XK_semicolon, XK_Greek_zeta, XK_semicolon, (uint)X.string_to_keysym("U2124"), 0 /*NoSymbol*/ }));
			keysyms.set( 62, new KeycodeArray({ XK_Shift_R, XK_Caps_Lock }));
			keysyms.set( 63, new KeycodeArray({ XK_KP_Multiply, XK_KP_Multiply, (uint)X.string_to_keysym("U2219"), (uint)X.string_to_keysym("U2299"), XK_multiply, (uint)X.string_to_keysym("U2297"), 0 /*NoSymbol*/ }));
			keysyms.set( 64, new KeycodeArray({ XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L }));
			keysyms.set( 65, new KeycodeArray({ XK_space, XK_space, XK_space, XK_nobreakspace, XK_KP_0, (uint)X.string_to_keysym("U202F"), 0 /*NoSymbol*/ }));
			keysyms.set( 66, new KeycodeArray({ XK_ISO_Level3_Shift }));
			keysyms.set( 67, new KeycodeArray({ XK_F1, 0 /*XK_XF86_Switch_VT_1*/ }));
			keysyms.set( 68, new KeycodeArray({ XK_F2, 0 /*XK_XF86_Switch_VT_2*/ }));
			keysyms.set( 69, new KeycodeArray({ XK_F3, 0 /*XK_XF86_Switch_VT_3*/ }));
			keysyms.set( 70, new KeycodeArray({ XK_F4, 0 /*XK_XF86_Switch_VT_4*/ }));
			keysyms.set( 71, new KeycodeArray({ XK_F5, 0 /*XK_XF86_Switch_VT_5*/ }));
			keysyms.set( 72, new KeycodeArray({ XK_F6, 0 /*XK_XF86_Switch_VT_6*/ }));
			keysyms.set( 73, new KeycodeArray({ XK_F7, 0 /*XK_XF86_Switch_VT_7*/ }));
			keysyms.set( 74, new KeycodeArray({ XK_F8, 0 /*XK_XF86_Switch_VT_8*/ }));
			keysyms.set( 75, new KeycodeArray({ XK_F9, 0 /*XK_XF86_Switch_VT_9*/ }));
			keysyms.set( 76, new KeycodeArray({ XK_F10, 0 /*XK_XF86_Switch_VT_10*/ }));
			keysyms.set( 77, new KeycodeArray({ XK_Tab, XK_ISO_Left_Tab, XK_equal, XK_approxeq, XK_notequal, XK_identical, 0 /*NoSymbol*/ }));
			keysyms.set( 78, new KeycodeArray({ XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock }));
			keysyms.set( 79, new KeycodeArray({ XK_KP_7, (uint)X.string_to_keysym("U2714"), (uint)X.string_to_keysym("U2195"), (uint)X.string_to_keysym("U226A"), XK_KP_Home, XK_upstile, 0 /*NoSymbol*/ }));
			keysyms.set( 80, new KeycodeArray({ XK_KP_8, (uint)X.string_to_keysym("U2718"), XK_uparrow, XK_intersection, XK_KP_Up, (uint)X.string_to_keysym("U22C2"),
						0 /*NoSymbol*/ }));
			keysyms.set( 81, new KeycodeArray({ XK_KP_9, XK_dagger, (uint)X.string_to_keysym("U20D7"), (uint)X.string_to_keysym("U226B"), XK_KP_Prior, (uint)X.string_to_keysym("U2309"), 0 /*NoSymbol*/ }));
			keysyms.set( 82, new KeycodeArray({ XK_KP_Subtract, XK_KP_Subtract, (uint)X.string_to_keysym("U2212"), (uint)X.string_to_keysym("U2296"), (uint)X.string_to_keysym("U2216"), (uint)X.string_to_keysym("U2238"), 0 /*NoSymbol*/ }));
			keysyms.set( 83, new KeycodeArray({ XK_KP_4, XK_club, XK_leftarrow, XK_includedin, XK_KP_Left, (uint)X.string_to_keysym("U2286"), 0 /*NoSymbol*/ }));
			keysyms.set( 84, new KeycodeArray({ XK_KP_5, XK_EuroSign, XK_colon, (uint)X.string_to_keysym("U22B6"), XK_KP_Begin, (uint)X.string_to_keysym("U22B7"), 0 /*NoSymbol*/ }));
			keysyms.set( 85, new KeycodeArray({ XK_KP_6, (uint)X.string_to_keysym("U2023"), XK_rightarrow, XK_includes, XK_KP_Right, (uint)X.string_to_keysym("U2287"), 0 /*NoSymbol*/ }));
			keysyms.set( 86, new KeycodeArray({ XK_KP_Add, XK_KP_Add, XK_plusminus, (uint)X.string_to_keysym("U2295"), (uint)X.string_to_keysym("U2213"), (uint)X.string_to_keysym("U2214"), 0 /*NoSymbol*/ }));
			keysyms.set( 87, new KeycodeArray({ XK_KP_1, XK_diamond, (uint)X.string_to_keysym("U2194"), XK_lessthanequal, XK_KP_End, XK_downstile, 0 /*NoSymbol*/ }));
			keysyms.set( 88, new KeycodeArray({ XK_KP_2, XK_heart, XK_downarrow, XK_union, XK_KP_Down, (uint)X.string_to_keysym("U22C3"), 0 /*NoSymbol*/ }));
			keysyms.set( 89, new KeycodeArray({ XK_KP_3, (uint)X.string_to_keysym("U2660"), (uint)X.string_to_keysym("U21CC"), XK_greaterthanequal, XK_KP_Next, (uint)X.string_to_keysym("U230B"), 0 /*NoSymbol*/ }));
			keysyms.set( 90, new KeycodeArray({ XK_KP_0, (uint)X.string_to_keysym("U2423"), XK_percent, (uint)X.string_to_keysym("U2030"), XK_KP_Insert, (uint)X.string_to_keysym("U25A1"), 0 /*NoSymbol*/ }));
			keysyms.set( 91, new KeycodeArray({ XK_KP_Separator, XK_period, XK_comma, XK_minutes, XK_KP_Delete, XK_seconds, 0 /*NoSymbol*/ }));
			keysyms.set( 92, new KeycodeArray({ XK_ISO_Level3_Shift }));
			keysyms.set( 93, new KeycodeArray({ }));
			keysyms.set( 94, new KeycodeArray({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock }));
			keysyms.set( 95, new KeycodeArray({ XK_F11, 0 /*XK_XF86_Switch_VT_11*/ }));
			keysyms.set( 96, new KeycodeArray({ XK_F12, 0 /*XK_XF86_Switch_VT_12*/ }));
			keysyms.set( 97, new KeycodeArray({ }));
			keysyms.set( 98, new KeycodeArray({ XK_Katakana }));
			keysyms.set( 99, new KeycodeArray({ XK_Hiragana }));
			keysyms.set(100, new KeycodeArray({ XK_Henkan_Mode }));
			keysyms.set(101, new KeycodeArray({ XK_Hiragana_Katakana }));
			keysyms.set(102, new KeycodeArray({ XK_Muhenkan }));
			keysyms.set(103, new KeycodeArray({ }));
			keysyms.set(104, new KeycodeArray({ XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, 0 /*NoSymbol*/ }));
			keysyms.set(105, new KeycodeArray({ XK_Control_R, XK_Control_R, XK_Control_R, XK_Control_R, XK_Control_R }));
			keysyms.set(106, new KeycodeArray({ XK_KP_Divide, XK_KP_Divide, XK_division, (uint)X.string_to_keysym("U2300"), (uint)X.string_to_keysym("U2215"), (uint)X.string_to_keysym("U2223"), 0 /*NoSymbol*/ }));
			keysyms.set(107, new KeycodeArray({ XK_Print, XK_Sys_Req }));
			keysyms.set(108, new KeycodeArray({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock }));
			keysyms.set(109, new KeycodeArray({ XK_Linefeed, XK_Linefeed, XK_Linefeed, XK_Linefeed, XK_Linefeed }));
			keysyms.set(110, new KeycodeArray({ XK_Home, XK_Home, XK_Home, XK_Home, XK_Home }));
			keysyms.set(111, new KeycodeArray({ XK_Up, XK_Up, XK_Up, XK_Up, XK_Up }));
			keysyms.set(112, new KeycodeArray({ XK_Prior, XK_Prior, XK_Prior, XK_Prior, XK_Prior }));
			keysyms.set(113, new KeycodeArray({ XK_Left, XK_Left, XK_Left, XK_Left, XK_Left }));
			keysyms.set(114, new KeycodeArray({ XK_Right, XK_Right, XK_Right, XK_Right, XK_Right }));
			keysyms.set(115, new KeycodeArray({ XK_End, XK_End, XK_End, XK_End, XK_End }));
			keysyms.set(116, new KeycodeArray({ XK_Down, XK_Down, XK_Down, XK_Down, XK_Down }));
			keysyms.set(117, new KeycodeArray({ XK_Next, XK_Next, XK_Next, XK_Next, XK_Next }));
			keysyms.set(118, new KeycodeArray({ XK_Insert, XK_Insert, XK_Insert, XK_Insert, XK_Insert }));
			keysyms.set(119, new KeycodeArray({ XK_Delete, XK_Delete, XK_Delete, XK_Delete, XK_Delete }));
			keysyms.set(120, new KeycodeArray({ }));
			keysyms.set(121, new KeycodeArray({ 0 /*XK_XF86AudioMute*/ }));
			keysyms.set(122, new KeycodeArray({ 0 /*XK_XF86AudioLowerVolume*/ }));
			keysyms.set(123, new KeycodeArray({ 0 /*XK_XF86AudioRaiseVolume*/ }));
			keysyms.set(124, new KeycodeArray({ 0 /*XK_XF86PowerOff*/ }));
			keysyms.set(125, new KeycodeArray({ XK_KP_Equal, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/ }));
			keysyms.set(126, new KeycodeArray({ XK_plusminus }));
			keysyms.set(127, new KeycodeArray({ XK_Pause, XK_Break }));
			keysyms.set(128, new KeycodeArray({ 0 /*XK_XF86LaunchA*/ }));
			keysyms.set(129, new KeycodeArray({ XK_KP_Decimal }));
			keysyms.set(130, new KeycodeArray({ XK_Hangul }));
			keysyms.set(131, new KeycodeArray({ XK_Hangul_Hanja }));
			keysyms.set(132, new KeycodeArray({ }));
			keysyms.set(133, new KeycodeArray({ XK_Super_L }));
			keysyms.set(134, new KeycodeArray({ XK_Super_R }));
			keysyms.set(135, new KeycodeArray({ XK_Menu }));
			keysyms.set(136, new KeycodeArray({ XK_Cancel }));
			keysyms.set(137, new KeycodeArray({ XK_Redo }));
			keysyms.set(138, new KeycodeArray({ 0 /*XK_SunProps*/ }));
			keysyms.set(139, new KeycodeArray({ XK_Undo }));
			keysyms.set(140, new KeycodeArray({ 0 /*XK_SunFront*/ }));
			keysyms.set(141, new KeycodeArray({ 0 /*XK_XF86Copy*/ }));
			keysyms.set(142, new KeycodeArray({ 0 /*XK_SunOpen*/ }));
			keysyms.set(143, new KeycodeArray({ 0 /*XK_XF86Paste*/ }));
			keysyms.set(144, new KeycodeArray({ XK_Find }));
			keysyms.set(145, new KeycodeArray({ 0 /*XK_XF86Cut*/ }));
			keysyms.set(146, new KeycodeArray({ XK_Help }));
			keysyms.set(147, new KeycodeArray({ 0 /*XK_XF86MenuKB*/ }));
			keysyms.set(148, new KeycodeArray({ 0 /*XK_XF86Calculator*/ }));
			keysyms.set(149, new KeycodeArray({ }));
			keysyms.set(150, new KeycodeArray({ 0 /*XK_XF86Sleep*/ }));
			keysyms.set(151, new KeycodeArray({ 0 /*XK_XF86WakeUp*/ }));
			keysyms.set(152, new KeycodeArray({ 0 /*XK_XF86Explorer*/ }));
			keysyms.set(153, new KeycodeArray({ 0 /*XK_XF86Send*/ }));
			keysyms.set(154, new KeycodeArray({ }));
			keysyms.set(155, new KeycodeArray({ 0 /*XK_XF86Xfer*/ }));
			keysyms.set(156, new KeycodeArray({ 0 /*XK_XF86Launch1*/ }));
			keysyms.set(157, new KeycodeArray({ 0 /*XK_XF86Launch2*/ }));
			keysyms.set(158, new KeycodeArray({ 0 /*XK_XF86WWW*/ }));
			keysyms.set(159, new KeycodeArray({ 0 /*XK_XF86DOS*/ }));
			keysyms.set(160, new KeycodeArray({ 0 /*XK_XF86ScreenSaver*/ }));
			keysyms.set(161, new KeycodeArray({ }));
			keysyms.set(162, new KeycodeArray({ 0 /*XK_XF86RotateWindows*/ }));
			keysyms.set(163, new KeycodeArray({ 0 /*XK_XF86Mail*/ }));
			keysyms.set(164, new KeycodeArray({ 0 /*XK_XF86Favorites*/ }));
			keysyms.set(165, new KeycodeArray({ 0 /*XK_XF86MyComputer*/ }));
			keysyms.set(166, new KeycodeArray({ 0 /*XK_XF86Back*/ }));
			keysyms.set(167, new KeycodeArray({ 0 /*XK_XF86Forward*/ }));
			keysyms.set(168, new KeycodeArray({ }));
			keysyms.set(169, new KeycodeArray({ 0 /*XK_XF86Eject*/ }));
			keysyms.set(170, new KeycodeArray({ 0 /*XK_XF86Eject*/, 0 /*XK_XF86Eject*/ }));
			keysyms.set(171, new KeycodeArray({ 0 /*XK_XF86AudioNext*/ }));
			keysyms.set(172, new KeycodeArray({ 0 /*XK_XF86AudioPlay*/, 0 /*XK_XF86AudioPause*/ }));
			keysyms.set(173, new KeycodeArray({ 0 /*XK_XF86AudioPrev*/ }));
			keysyms.set(174, new KeycodeArray({ 0 /*XK_XF86AudioStop*/, 0 /*XK_XF86Eject*/ }));
			keysyms.set(175, new KeycodeArray({ 0 /*XK_XF86AudioRecord*/ }));
			keysyms.set(176, new KeycodeArray({ 0 /*XK_XF86AudioRewind*/ }));
			keysyms.set(177, new KeycodeArray({ 0 /*XK_XF86Phone*/ }));
			keysyms.set(178, new KeycodeArray({ }));
			keysyms.set(179, new KeycodeArray({ 0 /*XK_XF86Tools*/ }));
			keysyms.set(180, new KeycodeArray({ 0 /*XK_XF86HomePage*/ }));
			keysyms.set(181, new KeycodeArray({ 0 /*XK_XF86Reload*/ }));
			keysyms.set(182, new KeycodeArray({ 0 /*XK_XF86Close*/ }));
			keysyms.set(183, new KeycodeArray({ }));
			keysyms.set(184, new KeycodeArray({ }));
			keysyms.set(185, new KeycodeArray({ 0 /*XK_XF86ScrollUp*/ }));
			keysyms.set(186, new KeycodeArray({ 0 /*XK_XF86ScrollDown*/ }));
			keysyms.set(187, new KeycodeArray({ XK_parenleft }));
			keysyms.set(188, new KeycodeArray({ XK_parenright }));
			keysyms.set(189, new KeycodeArray({ 0 /*XK_XF86New*/ }));
			keysyms.set(190, new KeycodeArray({ XK_Redo }));
			keysyms.set(191, new KeycodeArray({ 0 /*XK_XF86Tools*/ }));
			keysyms.set(192, new KeycodeArray({ 0 /*XK_XF86Launch5*/ }));
			keysyms.set(193, new KeycodeArray({ 0 /*XK_XF86MenuKB*/ }));
			keysyms.set(194, new KeycodeArray({ }));
			keysyms.set(195, new KeycodeArray({ }));
			keysyms.set(196, new KeycodeArray({ }));
			keysyms.set(197, new KeycodeArray({ }));
			keysyms.set(198, new KeycodeArray({ }));
			keysyms.set(199, new KeycodeArray({ }));
			keysyms.set(200, new KeycodeArray({ 0 /*XK_XF86TouchpadToggle*/ }));
			keysyms.set(201, new KeycodeArray({ }));
			keysyms.set(202, new KeycodeArray({ }));
			keysyms.set(203, new KeycodeArray({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift }));
			keysyms.set(204, new KeycodeArray({ XK_Alt_L }));
			keysyms.set(205, new KeycodeArray({ XK_Alt_L }));
			keysyms.set(206, new KeycodeArray({ XK_Super_L }));
			keysyms.set(207, new KeycodeArray({ }));
			keysyms.set(208, new KeycodeArray({ 0 /*XK_XF86AudioPlay*/ }));
			keysyms.set(209, new KeycodeArray({ 0 /*XK_XF86AudioPause*/ }));
			keysyms.set(210, new KeycodeArray({ 0 /*XK_XF86Launch3*/ }));
			keysyms.set(211, new KeycodeArray({ 0 /*XK_XF86Launch4*/ }));
			keysyms.set(212, new KeycodeArray({ 0 /*XK_XF86LaunchB*/ }));
			keysyms.set(213, new KeycodeArray({ 0 /*XK_XF86Suspend*/ }));
			keysyms.set(214, new KeycodeArray({ 0 /*XK_XF86Close*/ }));
			keysyms.set(215, new KeycodeArray({ 0 /*XK_XF86AudioPlay*/ }));
			keysyms.set(216, new
					KeycodeArray({ 0 /*XK_XF86AudioForward*/ }));
			keysyms.set(217, new KeycodeArray({ }));
			keysyms.set(218, new KeycodeArray({ XK_Print }));
			keysyms.set(219, new KeycodeArray({ }));
			keysyms.set(220, new KeycodeArray({ 0 /*XK_XF86WebCam*/ }));
			keysyms.set(221, new KeycodeArray({ }));
			keysyms.set(222, new KeycodeArray({ }));
			keysyms.set(223, new KeycodeArray({ 0 /*XK_XF86Mail*/ }));
			keysyms.set(224, new KeycodeArray({ }));
			keysyms.set(225, new KeycodeArray({ 0 /*XK_XF86Search*/ }));
			keysyms.set(226, new KeycodeArray({ }));
			keysyms.set(227, new KeycodeArray({ 0 /*XK_XF86Finance*/ }));
			keysyms.set(228, new KeycodeArray({ }));
			keysyms.set(229, new KeycodeArray({ 0 /*XK_XF86Shop*/ }));
			keysyms.set(230, new KeycodeArray({ }));
			keysyms.set(231, new KeycodeArray({ XK_Cancel }));
			keysyms.set(232, new KeycodeArray({ 0 /*XK_XF86MonBrightnessDown*/ }));
			keysyms.set(233, new KeycodeArray({ 0 /*XK_XF86MonBrightnessUp*/ }));
			keysyms.set(234, new KeycodeArray({ 0 /*XK_XF86AudioMedia*/ }));
			keysyms.set(235, new KeycodeArray({ 0 /*XK_XF86Display*/ }));
			keysyms.set(236, new KeycodeArray({ 0 /*XK_XF86KbdLightOnOff*/ }));
			keysyms.set(237, new KeycodeArray({ 0 /*XK_XF86KbdBrightnessDown*/ }));
			keysyms.set(238, new KeycodeArray({ 0 /*XK_XF86KbdBrightnessUp*/ }));
			keysyms.set(239, new KeycodeArray({ 0 /*XK_XF86Send*/ }));
			keysyms.set(240, new KeycodeArray({ 0 /*XK_XF86Reply*/ }));
			keysyms.set(241, new KeycodeArray({ 0 /*XK_XF86MailForward*/ }));
			keysyms.set(242, new KeycodeArray({ 0 /*XK_XF86Save*/ }));
			keysyms.set(243, new KeycodeArray({ 0 /*XK_XF86Documents*/ }));
			keysyms.set(244, new KeycodeArray({ 0 /*XK_XF86Battery*/ }));
			keysyms.set(245, new KeycodeArray({ 0 /*XK_XF86Bluetooth*/ }));
			keysyms.set(246, new KeycodeArray({ 0 /*XK_XF86WLAN*/ }));
			keysyms.set(247, new KeycodeArray({ }));
			keysyms.set(248, new KeycodeArray({ }));
			keysyms.set(249, new KeycodeArray({ }));
			keysyms.set(250, new KeycodeArray({ }));
			keysyms.set(251, new KeycodeArray({ }));
			keysyms.set(252, new KeycodeArray({ }));
			keysyms.set(253, new KeycodeArray({ }));
			keysyms.set(254, new KeycodeArray({ }));
			keysyms.set(255, new KeycodeArray({ }));

			return keysyms;
		}

  // Define Keyboard layout KOY (Weiterentwicklung von Aus der Neo Welt)
	public Gee.HashMap<int, KeycodeArray> generateKeysymsKoy() {
			Gee.HashMap<int, KeycodeArray> keysyms = new Gee.HashMap<int, KeycodeArray>();

			/* Define keyboard layout. this object maps the keycodes to the list of keycodes of each keyboard layer. */
			keysyms.set(8, new KeycodeArray({}));
			keysyms.set( 9, new KeycodeArray({ XK_Escape, XK_Escape, XK_Escape, XK_Escape, XK_Escape }));
			keysyms.set( 10, new KeycodeArray({ XK_1, XK_degree, XK_onesuperior, XK_onesubscript, XK_ordfeminine, XK_notsign, 0 /*NoSymbol*/ }));
			keysyms.set( 11, new KeycodeArray({ XK_2, XK_section, XK_twosuperior, XK_twosubscript, XK_masculine, XK_logicalor, 0 /*NoSymbol*/ }));
			keysyms.set( 12, new KeycodeArray({ XK_3, (uint)X.string_to_keysym("U2113"), XK_threesuperior, XK_threesubscript, XK_numerosign, XK_logicaland, 0 /*NoSymbol*/ }));
			keysyms.set( 13, new KeycodeArray({ XK_4, XK_guillemotright, (uint)X.string_to_keysym("U203A"), XK_femalesymbol, 0 /*NoSymbol*/, (uint)X.string_to_keysym("U22A5"), 0 /*NoSymbol*/ }));
			keysyms.set( 14, new KeycodeArray({ XK_5, XK_guillemotleft, (uint)X.string_to_keysym("U2039"), XK_malesymbol, XK_periodcentered, (uint)X.string_to_keysym("U2221"), 0 /*NoSymbol*/ }));
			keysyms.set( 15, new KeycodeArray({ XK_6, XK_dollar, XK_cent, (uint)X.string_to_keysym("U26A5"), XK_sterling, (uint)X.string_to_keysym("U2225"), 0 /*NoSymbol*/ }));
			keysyms.set( 16, new KeycodeArray({ XK_7, XK_EuroSign, XK_yen, (uint)X.string_to_keysym("U03F0"), XK_currency, XK_rightarrow, 0 /*NoSymbol*/ }));
			keysyms.set( 17, new KeycodeArray({ XK_8, XK_doublelowquotemark, XK_singlelowquotemark, (uint)X.string_to_keysym("U27E8"), XK_Tab, (uint)X.string_to_keysym("U221E"), 0 /*NoSymbol*/ }));
			keysyms.set( 18, new KeycodeArray({ XK_9, XK_leftdoublequotemark, XK_leftsinglequotemark, (uint)X.string_to_keysym("U27E9"), XK_KP_Divide, XK_variation, 0 /*NoSymbol*/ }));
			keysyms.set( 19, new KeycodeArray({ XK_0, XK_rightdoublequotemark, XK_rightsinglequotemark, XK_zerosubscript, XK_KP_Multiply, XK_emptyset, 0 /*NoSymbol*/ }));
			keysyms.set( 20, new KeycodeArray({ XK_minus, XK_emdash, 0 /*NoSymbol*/, (uint)X.string_to_keysym("U2011"), XK_KP_Subtract, XK_hyphen, 0 /*NoSymbol*/ }));
			keysyms.set( 21, new KeycodeArray({ XK_dead_grave, XK_dead_cedilla, XK_dead_abovering, XK_dead_abovereversedcomma, XK_dead_diaeresis, XK_dead_macron, 0 /*NoSymbol*/ }));
			keysyms.set( 22, new KeycodeArray({ XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace }));
			keysyms.set( 23, new KeycodeArray({ XK_Tab, XK_ISO_Left_Tab, XK_Multi_key, XK_ISO_Level5_Lock, 0 /*NoSymbol*/, 0 /*NoSymbol*/, XK_ISO_Level5_Lock }));
			keysyms.set( 24, new KeycodeArray({ XK_k, XK_K, XK_ellipsis, XK_Greek_kappa, XK_Prior, XK_multiply, 0 /*NoSymbol*/ }));
			keysyms.set( 25, new KeycodeArray({ XK_period, XK_enfilledcircbullet, XK_underscore, (uint)X.string_to_keysym("U03D1"), XK_BackSpace, (uint)X.string_to_keysym("U21A6"), 0 /*NoSymbol*/ }));
			keysyms.set( 26, new KeycodeArray({ XK_o, XK_O, XK_bracketleft, XK_Greek_omicron, XK_Up, XK_elementof, 0 /*NoSymbol*/ }));
			keysyms.set( 27, new KeycodeArray({ XK_comma, XK_endash, XK_bracketright, (uint)X.string_to_keysym("U03F1"), XK_Delete, (uint)X.string_to_keysym("U21D2"), 0 /*NoSymbol*/ }));
			keysyms.set( 28, new KeycodeArray({ XK_y, XK_Y, XK_asciicircum, XK_Greek_upsilon, XK_Next, XK_nabla, 0 /*NoSymbol*/ }));
			keysyms.set( 29, new KeycodeArray({ XK_v, XK_V, XK_exclam, 0 /*NoSymbol*/, 0 /*NoSymbol*/, XK_radical, 0 /*NoSymbol*/ }));
			keysyms.set( 30, new KeycodeArray({ XK_g, XK_G, XK_less, XK_Greek_gamma, XK_KP_7, XK_Greek_GAMMA, 0 /*NoSymbol*/ }));
			keysyms.set( 31, new KeycodeArray({ XK_c, XK_C, XK_greater, XK_Greek_chi, XK_KP_8, (uint)X.string_to_keysym("U2102"), 0 /*NoSymbol*/ }));
			keysyms.set( 32, new KeycodeArray({ XK_l, XK_L, (uint)X.string_to_keysym("U1E9E"), XK_equal, XK_Greek_lamda, XK_KP_9, XK_Greek_LAMDA, 0 /*NoSymbol*/ }));
			keysyms.set( 33, new KeycodeArray({ XK_ssharp, XK_ampersand, XK_Greek_finalsmallsigma, XK_KP_Add, XK_jot, 0 /*NoSymbol*/ }));
			keysyms.set( 34, new KeycodeArray({ XK_z, XK_Z, (uint)X.string_to_keysym("U017F"), XK_Greek_zeta, (uint)X.string_to_keysym("U2212"), (uint)X.string_to_keysym("U2124"), 0 /*NoSymbol*/ }));
			keysyms.set( 35, new KeycodeArray({ XK_dead_acute, XK_dead_tilde, XK_dead_stroke, XK_dead_abovecomma, XK_dead_doubleacute, XK_dead_breve, 0 /*NoSymbol*/ }));
			keysyms.set( 36, new KeycodeArray({ XK_Return, XK_Return, XK_Return, XK_Return, XK_Return }));
			keysyms.set( 37, new KeycodeArray({ XK_Control_L, XK_Control_L, XK_Control_L, XK_Control_L, XK_Control_L }));
			keysyms.set( 38, new KeycodeArray({ XK_h, XK_H, XK_backslash, XK_Greek_psi, XK_Home, XK_Greek_PSI, 0 /*NoSymbol*/ }));
			keysyms.set( 39, new KeycodeArray({ XK_a, XK_A, XK_slash, XK_Greek_alpha, XK_Left, (uint)X.string_to_keysym("U2200"), 0 /*NoSymbol*/ }));
			keysyms.set( 40, new KeycodeArray({ XK_e, XK_E, XK_braceleft, XK_Greek_epsilon, XK_Down, (uint)X.string_to_keysym("U2203"), 0 /*NoSymbol*/ }));
			keysyms.set( 41, new KeycodeArray({ XK_i, XK_I, XK_braceright, XK_Greek_iota, XK_Right, XK_integral, 0 /*NoSymbol*/ }));
			keysyms.set( 42, new KeycodeArray({ XK_u, XK_U, XK_asterisk, 0 /*NoSymbol*/, XK_End, XK_includedin, 0 /*NoSymbol*/ }));
			keysyms.set( 43, new KeycodeArray({ XK_d, XK_D, XK_question, XK_Greek_delta, XK_questiondown, XK_Greek_DELTA, 0 /*NoSymbol*/ }));
			keysyms.set( 44, new KeycodeArray({ XK_t, XK_T, XK_parenleft, XK_Greek_tau, XK_KP_4, XK_partialderivative, 0 /*NoSymbol*/ }));
			keysyms.set( 45, new KeycodeArray({ XK_r, XK_R, XK_parenright, XK_Greek_rho, XK_KP_5, (uint)X.string_to_keysym("U211D"), 0 /*NoSymbol*/ }));
			keysyms.set( 46, new KeycodeArray({ XK_n, XK_N, XK_minus, XK_Greek_nu, XK_KP_6, (uint)X.string_to_keysym("U2115"), 0 /*NoSymbol*/ }));
			keysyms.set( 47, new KeycodeArray({ XK_s, XK_S, XK_colon, XK_Greek_sigma, XK_KP_Separator, XK_Greek_SIGMA, 0 /*NoSymbol*/ }));
			keysyms.set( 48, new KeycodeArray({ XK_f, XK_F, XK_at, XK_Greek_phi, XK_Return, XK_Greek_PHI, 0 /*NoSymbol*/ }));
			keysyms.set( 49, new KeycodeArray({ XK_dead_circumflex, XK_dead_caron, (uint)X.string_to_keysym("U21BB"), (uint)X.string_to_keysym("U02DE"), XK_dead_abovedot, XK_dead_belowdot, 0 /*NoSymbol*/ }));
			keysyms.set( 50, new KeycodeArray({ XK_Shift_L, XK_Caps_Lock }));
			keysyms.set( 51, new KeycodeArray({ XK_ISO_Level3_Shift }));
			keysyms.set( 52, new KeycodeArray({ XK_x, XK_X, XK_numbersign, XK_Greek_xi, XK_Escape, XK_Greek_XI, 0 /*NoSymbol*/ }));
			keysyms.set( 53, new KeycodeArray({ XK_q, XK_Q, XK_dollar, (uint)X.string_to_keysym("U03D5"), XK_Tab, (uint)X.string_to_keysym("U211A"), 0 /*NoSymbol*/ }));
			keysyms.set( 54, new KeycodeArray({ XK_adiaeresis, XK_Adiaeresis, XK_bar, XK_Greek_eta, XK_Insert, (uint)X.string_to_keysym("U2135"), 0 /*NoSymbol*/ }));
			keysyms.set( 55, new KeycodeArray({ XK_udiaeresis, XK_Udiaeresis, XK_asciitilde, 0 /*NoSymbol*/, XK_Return, XK_union, 0 /*NoSymbol*/ }));
			keysyms.set( 56, new KeycodeArray({ XK_odiaeresis, XK_Odiaeresis, XK_grave, (uint)X.string_to_keysym("U03F5"), XK_Undo, XK_intersection, 0 /*NoSymbol*/ }));
			keysyms.set( 57, new KeycodeArray({ XK_b, XK_B, XK_plus, XK_Greek_beta, XK_colon, (uint)X.string_to_keysym("U21D0"), 0 /*NoSymbol*/ }));
			keysyms.set( 58, new KeycodeArray({ XK_p, XK_P, XK_percent, XK_Greek_pi, XK_KP_1, XK_Greek_PI, 0 /*NoSymbol*/ }));
			keysyms.set( 59, new KeycodeArray({ XK_w, XK_W, XK_quotedbl, XK_Greek_omega, XK_KP_2, XK_Greek_OMEGA, 0 /*NoSymbol*/ }));
			keysyms.set( 60, new KeycodeArray({ XK_m, XK_M, XK_apostrophe, XK_Greek_mu, XK_KP_3, XK_ifonlyif, 0 /*NoSymbol*/ }));
			keysyms.set( 61, new KeycodeArray({ XK_j, XK_J, XK_semicolon, XK_Greek_theta, XK_semicolon, XK_Greek_THETA, 0 /*NoSymbol*/ }));
			keysyms.set( 62, new KeycodeArray({ XK_Shift_R, XK_Caps_Lock }));
			keysyms.set( 63, new KeycodeArray({ XK_KP_Multiply, XK_KP_Multiply, (uint)X.string_to_keysym("U2219"), (uint)X.string_to_keysym("U2299"), XK_multiply, (uint)X.string_to_keysym("U2297"), 0 /*NoSymbol*/ }));
			keysyms.set( 64, new KeycodeArray({ XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L }));
			keysyms.set( 65, new KeycodeArray({ XK_space, XK_space, XK_space, XK_nobreakspace, XK_KP_0, (uint)X.string_to_keysym("U202F"), 0 /*NoSymbol*/ }));
			keysyms.set( 66, new KeycodeArray({ XK_ISO_Level3_Shift }));
			keysyms.set( 67, new KeycodeArray({ XK_F1, 0 /*XK_XF86_Switch_VT_1*/ }));
			keysyms.set( 68, new KeycodeArray({ XK_F2, 0 /*XK_XF86_Switch_VT_2*/ }));
			keysyms.set( 69, new KeycodeArray({ XK_F3, 0 /*XK_XF86_Switch_VT_3*/ }));
			keysyms.set( 70, new KeycodeArray({ XK_F4, 0 /*XK_XF86_Switch_VT_4*/ }));
			keysyms.set( 71, new KeycodeArray({ XK_F5, 0 /*XK_XF86_Switch_VT_5*/ }));
			keysyms.set( 72, new KeycodeArray({ XK_F6, 0 /*XK_XF86_Switch_VT_6*/ }));
			keysyms.set( 73, new KeycodeArray({ XK_F7, 0 /*XK_XF86_Switch_VT_7*/ }));
			keysyms.set( 74, new KeycodeArray({ XK_F8, 0 /*XK_XF86_Switch_VT_8*/ }));
			keysyms.set( 75, new KeycodeArray({ XK_F9, 0 /*XK_XF86_Switch_VT_9*/ }));
			keysyms.set( 76, new KeycodeArray({ XK_F10, 0 /*XK_XF86_Switch_VT_10*/ }));
			keysyms.set( 77, new KeycodeArray({ XK_Tab, XK_ISO_Left_Tab, XK_equal, XK_approxeq, XK_notequal, XK_identical, 0 /*NoSymbol*/ }));
			keysyms.set( 78, new KeycodeArray({ XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock }));
			keysyms.set( 79, new KeycodeArray({ XK_KP_7, (uint)X.string_to_keysym("U2714"), (uint)X.string_to_keysym("U2195"), (uint)X.string_to_keysym("U226A"), XK_KP_Home, XK_upstile, 0 /*NoSymbol*/ }));
			keysyms.set( 80, new KeycodeArray({ XK_KP_8, (uint)X.string_to_keysym("U2718"), XK_uparrow, XK_intersection, XK_KP_Up, (uint)X.string_to_keysym("U22C2"),
						0 /*NoSymbol*/ }));
			keysyms.set( 81, new KeycodeArray({ XK_KP_9, XK_dagger, (uint)X.string_to_keysym("U20D7"), (uint)X.string_to_keysym("U226B"), XK_KP_Prior, (uint)X.string_to_keysym("U2309"), 0 /*NoSymbol*/ }));
			keysyms.set( 82, new KeycodeArray({ XK_KP_Subtract, XK_KP_Subtract, (uint)X.string_to_keysym("U2212"), (uint)X.string_to_keysym("U2296"), (uint)X.string_to_keysym("U2216"), (uint)X.string_to_keysym("U2238"), 0 /*NoSymbol*/ }));
			keysyms.set( 83, new KeycodeArray({ XK_KP_4, XK_club, XK_leftarrow, XK_includedin, XK_KP_Left, (uint)X.string_to_keysym("U2286"), 0 /*NoSymbol*/ }));
			keysyms.set( 84, new KeycodeArray({ XK_KP_5, XK_EuroSign, XK_colon, (uint)X.string_to_keysym("U22B6"), XK_KP_Begin, (uint)X.string_to_keysym("U22B7"), 0 /*NoSymbol*/ }));
			keysyms.set( 85, new KeycodeArray({ XK_KP_6, (uint)X.string_to_keysym("U2023"), XK_rightarrow, XK_includes, XK_KP_Right, (uint)X.string_to_keysym("U2287"), 0 /*NoSymbol*/ }));
			keysyms.set( 86, new KeycodeArray({ XK_KP_Add, XK_KP_Add, XK_plusminus, (uint)X.string_to_keysym("U2295"), (uint)X.string_to_keysym("U2213"), (uint)X.string_to_keysym("U2214"), 0 /*NoSymbol*/ }));
			keysyms.set( 87, new KeycodeArray({ XK_KP_1, XK_diamond, (uint)X.string_to_keysym("U2194"), XK_lessthanequal, XK_KP_End, XK_downstile, 0 /*NoSymbol*/ }));
			keysyms.set( 88, new KeycodeArray({ XK_KP_2, XK_heart, XK_downarrow, XK_union, XK_KP_Down, (uint)X.string_to_keysym("U22C3"), 0 /*NoSymbol*/ }));
			keysyms.set( 89, new KeycodeArray({ XK_KP_3, (uint)X.string_to_keysym("U2660"), (uint)X.string_to_keysym("U21CC"), XK_greaterthanequal, XK_KP_Next, (uint)X.string_to_keysym("U230B"), 0 /*NoSymbol*/ }));
			keysyms.set( 90, new KeycodeArray({ XK_KP_0, (uint)X.string_to_keysym("U2423"), XK_percent, (uint)X.string_to_keysym("U2030"), XK_KP_Insert, (uint)X.string_to_keysym("U25A1"), 0 /*NoSymbol*/ }));
			keysyms.set( 91, new KeycodeArray({ XK_KP_Separator, XK_period, XK_comma, XK_minutes, XK_KP_Delete, XK_seconds, 0 /*NoSymbol*/ }));
			keysyms.set( 92, new KeycodeArray({ XK_ISO_Level3_Shift }));
			keysyms.set( 93, new KeycodeArray({ }));
			keysyms.set( 94, new KeycodeArray({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock }));
			keysyms.set( 95, new KeycodeArray({ XK_F11, 0 /*XK_XF86_Switch_VT_11*/ }));
			keysyms.set( 96, new KeycodeArray({ XK_F12, 0 /*XK_XF86_Switch_VT_12*/ }));
			keysyms.set( 97, new KeycodeArray({ }));
			keysyms.set( 98, new KeycodeArray({ XK_Katakana }));
			keysyms.set( 99, new KeycodeArray({ XK_Hiragana }));
			keysyms.set(100, new KeycodeArray({ XK_Henkan_Mode }));
			keysyms.set(101, new KeycodeArray({ XK_Hiragana_Katakana }));
			keysyms.set(102, new KeycodeArray({ XK_Muhenkan }));
			keysyms.set(103, new KeycodeArray({ }));
			keysyms.set(104, new KeycodeArray({ XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, 0 /*NoSymbol*/ }));
			keysyms.set(105, new KeycodeArray({ XK_Control_R, XK_Control_R, XK_Control_R, XK_Control_R, XK_Control_R }));
			keysyms.set(106, new KeycodeArray({ XK_KP_Divide, XK_KP_Divide, XK_division, (uint)X.string_to_keysym("U2300"), (uint)X.string_to_keysym("U2215"), (uint)X.string_to_keysym("U2223"), 0 /*NoSymbol*/ }));
			keysyms.set(107, new KeycodeArray({ XK_Print, XK_Sys_Req }));
			keysyms.set(108, new KeycodeArray({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock }));
			keysyms.set(109, new KeycodeArray({ XK_Linefeed, XK_Linefeed, XK_Linefeed, XK_Linefeed, XK_Linefeed }));
			keysyms.set(110, new KeycodeArray({ XK_Home, XK_Home, XK_Home, XK_Home, XK_Home }));
			keysyms.set(111, new KeycodeArray({ XK_Up, XK_Up, XK_Up, XK_Up, XK_Up }));
			keysyms.set(112, new KeycodeArray({ XK_Prior, XK_Prior, XK_Prior, XK_Prior, XK_Prior }));
			keysyms.set(113, new KeycodeArray({ XK_Left, XK_Left, XK_Left, XK_Left, XK_Left }));
			keysyms.set(114, new KeycodeArray({ XK_Right, XK_Right, XK_Right, XK_Right, XK_Right }));
			keysyms.set(115, new KeycodeArray({ XK_End, XK_End, XK_End, XK_End, XK_End }));
			keysyms.set(116, new KeycodeArray({ XK_Down, XK_Down, XK_Down, XK_Down, XK_Down }));
			keysyms.set(117, new KeycodeArray({ XK_Next, XK_Next, XK_Next, XK_Next, XK_Next }));
			keysyms.set(118, new KeycodeArray({ XK_Insert, XK_Insert, XK_Insert, XK_Insert, XK_Insert }));
			keysyms.set(119, new KeycodeArray({ XK_Delete, XK_Delete, XK_Delete, XK_Delete, XK_Delete }));
			keysyms.set(120, new KeycodeArray({ }));
			keysyms.set(121, new KeycodeArray({ 0 /*XK_XF86AudioMute*/ }));
			keysyms.set(122, new KeycodeArray({ 0 /*XK_XF86AudioLowerVolume*/ }));
			keysyms.set(123, new KeycodeArray({ 0 /*XK_XF86AudioRaiseVolume*/ }));
			keysyms.set(124, new KeycodeArray({ 0 /*XK_XF86PowerOff*/ }));
			keysyms.set(125, new KeycodeArray({ XK_KP_Equal, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/ }));
			keysyms.set(126, new KeycodeArray({ XK_plusminus }));
			keysyms.set(127, new KeycodeArray({ XK_Pause, XK_Break }));
			keysyms.set(128, new KeycodeArray({ 0 /*XK_XF86LaunchA*/ }));
			keysyms.set(129, new KeycodeArray({ XK_KP_Decimal }));
			keysyms.set(130, new KeycodeArray({ XK_Hangul }));
			keysyms.set(131, new KeycodeArray({ XK_Hangul_Hanja }));
			keysyms.set(132, new KeycodeArray({ }));
			keysyms.set(133, new KeycodeArray({ XK_Super_L }));
			keysyms.set(134, new KeycodeArray({ XK_Super_R }));
			keysyms.set(135, new KeycodeArray({ XK_Menu }));
			keysyms.set(136, new KeycodeArray({ XK_Cancel }));
			keysyms.set(137, new KeycodeArray({ XK_Redo }));
			keysyms.set(138, new KeycodeArray({ 0 /*XK_SunProps*/ }));
			keysyms.set(139, new KeycodeArray({ XK_Undo }));
			keysyms.set(140, new KeycodeArray({ 0 /*XK_SunFront*/ }));
			keysyms.set(141, new KeycodeArray({ 0 /*XK_XF86Copy*/ }));
			keysyms.set(142, new KeycodeArray({ 0 /*XK_SunOpen*/ }));
			keysyms.set(143, new KeycodeArray({ 0 /*XK_XF86Paste*/ }));
			keysyms.set(144, new KeycodeArray({ XK_Find }));
			keysyms.set(145, new KeycodeArray({ 0 /*XK_XF86Cut*/ }));
			keysyms.set(146, new KeycodeArray({ XK_Help }));
			keysyms.set(147, new KeycodeArray({ 0 /*XK_XF86MenuKB*/ }));
			keysyms.set(148, new KeycodeArray({ 0 /*XK_XF86Calculator*/ }));
			keysyms.set(149, new KeycodeArray({ }));
			keysyms.set(150, new KeycodeArray({ 0 /*XK_XF86Sleep*/ }));
			keysyms.set(151, new KeycodeArray({ 0 /*XK_XF86WakeUp*/ }));
			keysyms.set(152, new KeycodeArray({ 0 /*XK_XF86Explorer*/ }));
			keysyms.set(153, new KeycodeArray({ 0 /*XK_XF86Send*/ }));
			keysyms.set(154, new KeycodeArray({ }));
			keysyms.set(155, new KeycodeArray({ 0 /*XK_XF86Xfer*/ }));
			keysyms.set(156, new KeycodeArray({ 0 /*XK_XF86Launch1*/ }));
			keysyms.set(157, new KeycodeArray({ 0 /*XK_XF86Launch2*/ }));
			keysyms.set(158, new KeycodeArray({ 0 /*XK_XF86WWW*/ }));
			keysyms.set(159, new KeycodeArray({ 0 /*XK_XF86DOS*/ }));
			keysyms.set(160, new KeycodeArray({ 0 /*XK_XF86ScreenSaver*/ }));
			keysyms.set(161, new KeycodeArray({ }));
			keysyms.set(162, new KeycodeArray({ 0 /*XK_XF86RotateWindows*/ }));
			keysyms.set(163, new KeycodeArray({ 0 /*XK_XF86Mail*/ }));
			keysyms.set(164, new KeycodeArray({ 0 /*XK_XF86Favorites*/ }));
			keysyms.set(165, new KeycodeArray({ 0 /*XK_XF86MyComputer*/ }));
			keysyms.set(166, new KeycodeArray({ 0 /*XK_XF86Back*/ }));
			keysyms.set(167, new KeycodeArray({ 0 /*XK_XF86Forward*/ }));
			keysyms.set(168, new KeycodeArray({ }));
			keysyms.set(169, new KeycodeArray({ 0 /*XK_XF86Eject*/ }));
			keysyms.set(170, new KeycodeArray({ 0 /*XK_XF86Eject*/, 0 /*XK_XF86Eject*/ }));
			keysyms.set(171, new KeycodeArray({ 0 /*XK_XF86AudioNext*/ }));
			keysyms.set(172, new KeycodeArray({ 0 /*XK_XF86AudioPlay*/, 0 /*XK_XF86AudioPause*/ }));
			keysyms.set(173, new KeycodeArray({ 0 /*XK_XF86AudioPrev*/ }));
			keysyms.set(174, new KeycodeArray({ 0 /*XK_XF86AudioStop*/, 0 /*XK_XF86Eject*/ }));
			keysyms.set(175, new KeycodeArray({ 0 /*XK_XF86AudioRecord*/ }));
			keysyms.set(176, new KeycodeArray({ 0 /*XK_XF86AudioRewind*/ }));
			keysyms.set(177, new KeycodeArray({ 0 /*XK_XF86Phone*/ }));
			keysyms.set(178, new KeycodeArray({ }));
			keysyms.set(179, new KeycodeArray({ 0 /*XK_XF86Tools*/ }));
			keysyms.set(180, new KeycodeArray({ 0 /*XK_XF86HomePage*/ }));
			keysyms.set(181, new KeycodeArray({ 0 /*XK_XF86Reload*/ }));
			keysyms.set(182, new KeycodeArray({ 0 /*XK_XF86Close*/ }));
			keysyms.set(183, new KeycodeArray({ }));
			keysyms.set(184, new KeycodeArray({ }));
			keysyms.set(185, new KeycodeArray({ 0 /*XK_XF86ScrollUp*/ }));
			keysyms.set(186, new KeycodeArray({ 0 /*XK_XF86ScrollDown*/ }));
			keysyms.set(187, new KeycodeArray({ XK_parenleft }));
			keysyms.set(188, new KeycodeArray({ XK_parenright }));
			keysyms.set(189, new KeycodeArray({ 0 /*XK_XF86New*/ }));
			keysyms.set(190, new KeycodeArray({ XK_Redo }));
			keysyms.set(191, new KeycodeArray({ 0 /*XK_XF86Tools*/ }));
			keysyms.set(192, new KeycodeArray({ 0 /*XK_XF86Launch5*/ }));
			keysyms.set(193, new KeycodeArray({ 0 /*XK_XF86MenuKB*/ }));
			keysyms.set(194, new KeycodeArray({ }));
			keysyms.set(195, new KeycodeArray({ }));
			keysyms.set(196, new KeycodeArray({ }));
			keysyms.set(197, new KeycodeArray({ }));
			keysyms.set(198, new KeycodeArray({ }));
			keysyms.set(199, new KeycodeArray({ }));
			keysyms.set(200, new KeycodeArray({ 0 /*XK_XF86TouchpadToggle*/ }));
			keysyms.set(201, new KeycodeArray({ }));
			keysyms.set(202, new KeycodeArray({ }));
			keysyms.set(203, new KeycodeArray({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift }));
			keysyms.set(204, new KeycodeArray({ XK_Alt_L }));
			keysyms.set(205, new KeycodeArray({ XK_Alt_L }));
			keysyms.set(206, new KeycodeArray({ XK_Super_L }));
			keysyms.set(207, new KeycodeArray({ }));
			keysyms.set(208, new KeycodeArray({ 0 /*XK_XF86AudioPlay*/ }));
			keysyms.set(209, new KeycodeArray({ 0 /*XK_XF86AudioPause*/ }));
			keysyms.set(210, new KeycodeArray({ 0 /*XK_XF86Launch3*/ }));
			keysyms.set(211, new KeycodeArray({ 0 /*XK_XF86Launch4*/ }));
			keysyms.set(212, new KeycodeArray({ 0 /*XK_XF86LaunchB*/ }));
			keysyms.set(213, new KeycodeArray({ 0 /*XK_XF86Suspend*/ }));
			keysyms.set(214, new KeycodeArray({ 0 /*XK_XF86Close*/ }));
			keysyms.set(215, new KeycodeArray({ 0 /*XK_XF86AudioPlay*/ }));
			keysyms.set(216, new
					KeycodeArray({ 0 /*XK_XF86AudioForward*/ }));
			keysyms.set(217, new KeycodeArray({ }));
			keysyms.set(218, new KeycodeArray({ XK_Print }));
			keysyms.set(219, new KeycodeArray({ }));
			keysyms.set(220, new KeycodeArray({ 0 /*XK_XF86WebCam*/ }));
			keysyms.set(221, new KeycodeArray({ }));
			keysyms.set(222, new KeycodeArray({ }));
			keysyms.set(223, new KeycodeArray({ 0 /*XK_XF86Mail*/ }));
			keysyms.set(224, new KeycodeArray({ }));
			keysyms.set(225, new KeycodeArray({ 0 /*XK_XF86Search*/ }));
			keysyms.set(226, new KeycodeArray({ }));
			keysyms.set(227, new KeycodeArray({ 0 /*XK_XF86Finance*/ }));
			keysyms.set(228, new KeycodeArray({ }));
			keysyms.set(229, new KeycodeArray({ 0 /*XK_XF86Shop*/ }));
			keysyms.set(230, new KeycodeArray({ }));
			keysyms.set(231, new KeycodeArray({ XK_Cancel }));
			keysyms.set(232, new KeycodeArray({ 0 /*XK_XF86MonBrightnessDown*/ }));
			keysyms.set(233, new KeycodeArray({ 0 /*XK_XF86MonBrightnessUp*/ }));
			keysyms.set(234, new KeycodeArray({ 0 /*XK_XF86AudioMedia*/ }));
			keysyms.set(235, new KeycodeArray({ 0 /*XK_XF86Display*/ }));
			keysyms.set(236, new KeycodeArray({ 0 /*XK_XF86KbdLightOnOff*/ }));
			keysyms.set(237, new KeycodeArray({ 0 /*XK_XF86KbdBrightnessDown*/ }));
			keysyms.set(238, new KeycodeArray({ 0 /*XK_XF86KbdBrightnessUp*/ }));
			keysyms.set(239, new KeycodeArray({ 0 /*XK_XF86Send*/ }));
			keysyms.set(240, new KeycodeArray({ 0 /*XK_XF86Reply*/ }));
			keysyms.set(241, new KeycodeArray({ 0 /*XK_XF86MailForward*/ }));
			keysyms.set(242, new KeycodeArray({ 0 /*XK_XF86Save*/ }));
			keysyms.set(243, new KeycodeArray({ 0 /*XK_XF86Documents*/ }));
			keysyms.set(244, new KeycodeArray({ 0 /*XK_XF86Battery*/ }));
			keysyms.set(245, new KeycodeArray({ 0 /*XK_XF86Bluetooth*/ }));
			keysyms.set(246, new KeycodeArray({ 0 /*XK_XF86WLAN*/ }));
			keysyms.set(247, new KeycodeArray({ }));
			keysyms.set(248, new KeycodeArray({ }));
			keysyms.set(249, new KeycodeArray({ }));
			keysyms.set(250, new KeycodeArray({ }));
			keysyms.set(251, new KeycodeArray({ }));
			keysyms.set(252, new KeycodeArray({ }));
			keysyms.set(253, new KeycodeArray({ }));
			keysyms.set(254, new KeycodeArray({ }));
			keysyms.set(255, new KeycodeArray({ }));

			return keysyms;
		}


}

