using Gtk;
using Gdk;
using X; //keysym.h
using Posix;//system-calls

namespace NeoLayoutViewer{

	public class NeoWindow : Gtk.Window {

		private Gtk.Image image;
		public Gtk.Label status;
		private Gdk.Pixbuf[] image_buffer;
		public Gee.HashMap<string, string> config;

		public int ebene;
		public int[] active_modifier_by_keyboard;
		public int[] active_modifier_by_mouse;
		public int numblock_width;
		//private Button button;
		private bool minimized;
		private int position_num;
		private int[] position_cycle;

		/* Die Neo-Modifier unterscheiden sich zum Teil von den Normalen, für die Konstanten definiert sind. Bei der Initialisierung werden aus den Standardkonstanen die Konstenen für die Ebenen 1-6 berechnet.*/
		public int[] NEO_MODIFIER_MASK;
		public int[] MODIFIER_MASK;

		//		/* Modifier-codes für CTLR, ALT, ... */
		//		public int[] OTHER_MODIFIER_MASK;

		/* Die Keycodes von ShiftL, ShiftR, Mod3 (Alt Gr,<) und Mod4 (CapsLock, #)... in der Uni schon mal keine Übereinstimmung*/
		//private int[] MODIFIER_KEY_CODES = {65505,65506,65027,65041};//home
		//private int[] MODIFIER_KEY_CODES = {65505,65506,65406,65027};//uni

		/* Falls ein Modifier (oder eine andere Taste) gedrückt wird und schon Modifier gedrückt sind, gibt die Map an, welche Ebene dann aktiviert ist. */
		private short[,] MODIFIER_MAP = {
			{0,1,2,3,4,5},
			{1,1,4,3,4,5},
			{2,4,2,5,4,5},
			{3,3,5,3,4,5} };

		/* [0,1]^3->{0,5}, Bildet aktive Modifier auf angezeigte Ebene ab.
			 Interpretationsreihenfolge der Dimensionen: Shift,Neo-Mod3, Neo-Mod4. */
		private short[,,] MODIFIER_MAP2 = {
			{ {0 , 3}, {2 , 5 } },  // 000, 001; 010, 011
			{ {1 , 3}, {4 , 5}}	  // 100, 101; 110, 111
		};

		/* Analog zu oben für den Fall, dass eine Taste losgelassen wird. Funktioniert nicht immer.
			 Ist beispielsweise ShiftL und ShiftR gedrückt und eine wird losgelassen, so wechelt die Anzeige zur ersten Ebene.
			 Die Fehler sind imo zu vernachlässigen.
		 */
		private short[,] MODIFIER_MAP_RELEASE = {
			{0,0,0,0,0,0},
			{0,0,2,3,2,5},
			{0,1,0,3,1,3},
			{0,1,2,0,4,2} };

		/*
			Modifier können per Tastatur und Maus aktiviert werden. Diese Abbildung entscheidet,
		*/
		private short[,,,] MODIFIER_KEYBOARD_MOUSE_MAP = {
		//		 k		=				f(k,m,K,M,) and m = f(m,k,M,K)
			{ { {0, 0} , {1, 0} } ,	// 0000, 0001; 0010, 0011;
				{ {0, 0} , {1, 1} } },	// 0100, 0101; 0110, 0111(=swap);
			{ { {0, 0} , {1, 0} } , //1000, 1001; 1010, 1011(=swap);
				{ {0, 0} , {1, 1} } }//1100, 1101; 1110, 1111; //k=m=1 should be impossible
		};
		
		public NeoWindow (string sebene, Gee.HashMap<string, string> config) {
			this.config = config;
			this.minimized = true;

			this.NEO_MODIFIER_MASK = {
				0,
				Gdk.ModifierType.SHIFT_MASK, //1
				Gdk.ModifierType.MOD5_MASK+Gdk.ModifierType.LOCK_MASK, //128+2
				Gdk.ModifierType.MOD3_MASK, //32
				Gdk.ModifierType.MOD5_MASK+Gdk.ModifierType.LOCK_MASK+Gdk.ModifierType.SHIFT_MASK, //128+2+1
				Gdk.ModifierType.MOD5_MASK+Gdk.ModifierType.LOCK_MASK+Gdk.ModifierType.MOD3_MASK //128+2+32
			};
			/*
				 this.OTHER_MODIFIER_MASK = {
				 Gdk.ModifierType.CONTROL_MASK,
				 Gdk.ModifierType.MOD1_MASK
				 };*/
			this.MODIFIER_MASK = {
				0,
				Gdk.ModifierType.SHIFT_MASK, //1
				Gdk.ModifierType.MOD5_MASK,//128
				Gdk.ModifierType.MOD3_MASK, //32
				Gdk.ModifierType.CONTROL_MASK,
				Gdk.ModifierType.MOD1_MASK // Alt-Mask do not work :-(
			};
			this.active_modifier_by_keyboard = {0,0,0,0,0,0};
			this.active_modifier_by_mouse = {0,0,0,0,0,0};

			this.position_num = int.max(int.min(int.parse(config.get("position")),9),1);
			//Anlegen des Arrays, welches den Positionsdurchlauf beschreibt.
			try{
				var space = new Regex(" ");
				string[] split = space.split(config.get("position_cycle"));
				position_cycle = new int[int.max(9,split.length)];
				for(int i=0;i<split.length;i++){
					position_cycle[i] = int.max(int.min(int.parse(split[i]),9),1);//Zulässiger Bereich: 1-9
				}
			} catch (RegexError e) {
				position_cycle = {3,3,9,1,3,9,1,7,7};
			}


			this.ebene = int.parse(sebene);
			if(this.ebene<1 || this.ebene>6) {this.ebene = 1; }

			//Lade die Pngs der sechs Ebenen
			this.load_image_buffer();
			this.image = new Gtk.Image();//.from_pixbuf(this.image_buffer[ebene]);
			// Create an image and render first page to image
			//var pixbuf = new Gdk.Pixbuf (Gdk.Colorspace.RGB, false, 8, 800, 600);
			render_page ();

			var fixed = new Fixed();
			add(fixed);

			fixed.put(this.image, 0, 0);
			fixed.put( new KeyOverlay(this) , 0, 0);

			this.status = new Label("");
			int width; 
			int height;
			this.get_size2(out width, out height);
			//bad position, if numblock not shown...
			fixed.put( status, (int) ( (0.65)*width), (int) (0.40*height) );

			//Fenstereigenschaften setzen
			this.key_press_event.connect (on_key_pressed);
			this.destroy.connect (Gtk.main_quit);

			this.set_gravity(Gdk.Gravity.SOUTH);
			//this.move(-100,-100);
			/*GdkGeometry size_hints = {
				100, 50, 0, 0, 100, 50, 10, 10, 0.0, 0.0, GDK_GRAVITY_NORTH_WEST
				};

				gtk_window_set_geometry_hints (GTK_WINDOW (this), this, &size_hints,
				GDK_HINT_MIN_SIZE |  GDK_HINT_BASE_SIZE |  GDK_HINT_RESIZE_INC);
			 */
			//this.window_position = WindowPosition.CENTER;

			//this.default_height = int.parse( config.get("height") );
			//this.default_width = int.parse( config.get("width") );
			this.decorated = false;
			//this.allow_grow = false;
			//this.allow_shrink = false;
			this.skip_taskbar_hint = true;

			this.show_all();

			//Move ist erst nach show_all() erfolgreich
			this.numkeypad_move(int.parse(config.get("position")));

			//Icon des Fensters
			this.icon = this.image_buffer[0];

			//Nicht selektierbar (für virtuelle Tastatur)
			this.set_accept_focus( (config.get("window_selectable")!="0") );
			
		}

		public override void show_all(){
			this.minimized = false;
			base.show_all();
			//this.present();
			//set_visible(true);
			this.numkeypad_move(this.position_num);

			if( config.get("on_top")=="1")
				this.set_keep_above(true);
			else
				this.present();
		}

		public override void hide_all(){
			this.minimized = true;
			base.hide_all();
			//set_visible(false);
		}

		public bool toggle(){
			if(this.minimized) show_all();
			else hide_all();
			return this.minimized;
		}

		/* Falsche Werte bei „Tiled Window Managern“. */
		public void get_size2(out int width, out int height){
			width = this.image_buffer[1].width;
			height = this.image_buffer[1].height;
		}

		public void numkeypad_move(int pos){
			int screen_width = this.screen.width();
			int screen_height = this.screen.height();
			int x,y,w,h;
			this.get_size(out w,out h);

			switch (pos){
				case 0: //Zur nächsten Position wechseln
					numkeypad_move(this.position_cycle[this.position_num-1]);
					return;
				case 7:
					x = 0;
					y = 0;
					break;
				case 8:
					x = (screen_width-w)/2;
					y = 0;
					break;
				case 9:
					x = screen_width-w;
					y = 0;
					break;
				case 4:
					x = 0;
					y = (screen_height-h)/2;
					break;
				case 5:
					x = (screen_width-w)/2;
					y = (screen_height-h)/2;
					break;
				case 6:
					x = screen_width-w;
					y = (screen_height-h)/2;
					break;
				case 1:
					x = 0;
					y = screen_height-h;
					break;
				case 2:
					x = (screen_width-w)/2;
					y = screen_height-h;
					break;
					//case 3:	//=default case
					//		;
				default:
					x = screen_width-w;
					y = screen_height-h;
					break;
			}

			this.position_num = pos;
			this.move(x,y);
		}

		public Gdk.Pixbuf open_image (int ebene) {
			var bildpfad = "assets/neo2.0/tastatur_neo_Ebene%i.png".printf(ebene);
			return open_image_str(bildpfad);
			//return new Image_from_pixpuf(open_image_str(bildpfad));
		}

		public Gdk.Pixbuf open_image_str (string bildpfad) {
			try {
				return new Gdk.Pixbuf.from_file (bildpfad);
			} catch (Error e) {
				error ("%s", e.message);
			}
		}

		public void load_image_buffer () {
			this.image_buffer = new Gdk.Pixbuf[7];
			this.image_buffer[0] = open_image_str("assets/icons/Neo-Icon.png");

			int screen_width = this.screen.width();
			//int screen_height = this.screen.height();
			int max_width = (int) ( double.parse( this.config.get("max_width") )*screen_width );
			int min_width = (int) ( double.parse( this.config.get("min_width") )*screen_width );
			int width = int.min(int.max(int.parse( config.get("width") ),min_width),max_width);
			int w,h;

			for (int i=1; i<7; i++){
				this.image_buffer[i] = open_image(i);

				//Numpad-Teil abschneiden, falls gefordert
				this.numblock_width = int.parse(config.get("numblock_width"));
				if( config.get("display_numblock")=="0" ){
					var tmp =  new Gdk.Pixbuf(image_buffer[i].colorspace,image_buffer[i].has_alpha,image_buffer[i].bits_per_sample, image_buffer[i].width-numblock_width ,image_buffer[i].height);
					this.image_buffer[i].copy_area(0,0,tmp.width,tmp.height,tmp,0,0);
					this.image_buffer[i] = tmp;
				}

				//Bilder einmaling beim Laden skalieren. (Keine spätere Skalierung durch Größenänderung des Fensters)
				w = this.image_buffer[i].width;
				h = this.image_buffer[i].height;
				this.image_buffer[i] = this.image_buffer[i].scale_simple(width, h*width/w,Gdk.InterpType.BILINEAR);
			}
		}

		private bool on_key_pressed (Widget source, Gdk.EventKey key) {
			// If the key pressed was q, quit, else show the next page
			if (key.str == "q") {
				Gtk.main_quit ();
			}

			if (key.str == "h") {
				this.hide_all();
			}

			/* Erste Auswahlvariante: Zahlen 1-6 */
			var ebene_tmp = int.parse(key.str);
			if(ebene_tmp>0 && ebene_tmp<7) {
				if(this.ebene != ebene_tmp){
					this.ebene = ebene_tmp;
					render_page ();
				}
			}
			/*else{
			//Finde die aktuelle Taste und die derzeit gedrückten Modifier
			int iet1 = 0;
			int iet2 = 0;
			debug("%u".printf(key.keyval));
			if( key.keyval == MODIFIER_KEY_CODES[0] || key.keyval == MODIFIER_KEY_CODES[1]){
			iet1=1;
			}else if( key.keyval == MODIFIER_KEY_CODES[2]){
			iet1=2;
			}else if( key.keyval == MODIFIER_KEY_CODES[3]){
			iet1=3;
			}

			for(int i=0; i<6; i++){
			if( key.state == NEO_MODIFIER_MASK[i]){
			iet2=i;
			break;
			}
			}

			iet1 =  this.MODIFIER_MAP[iet1,iet2]+1;
			check_modifier(iet1);
			}*/

			/*
				 stdout.printf("Aktuell: %i  \nModifierids: %i %i %i %i\n %i %i %i %i \n %i %i %i %i %i\n\n",
				 key.state, Gdk.ModifierType.SHIFT_MASK, Gdk.ModifierType.LOCK_MASK, Gdk.ModifierType.CONTROL_MASK, Gdk.ModifierType.SUPER_MASK, Gdk.ModifierType.HYPER_MASK, Gdk.ModifierType.META_MASK, Gdk.ModifierType.RELEASE_MASK, Gdk.ModifierType.MODIFIER_MASK, Gdk.ModifierType.MOD1_MASK, Gdk.ModifierType.MOD2_MASK, Gdk.ModifierType.MOD3_MASK, Gdk.ModifierType.MOD4_MASK, Gdk.ModifierType.MOD5_MASK);*/


			return false;
		}

		/*
			Use the for values 
				- “modifier was pressed”
				- “modifier is pressed”
				- “modifier was seleted by mouseclick” and
				- “modifier is seleted by mouseclick”
			as array indizes to eval an new state.
		*/
		public void change_active_modifier(int mod_index, bool keyboard, int new_mod_state){
			int old_mod_state;
			if( keyboard ){
				//Keypress or Release of shift etc.
				old_mod_state = this.active_modifier_by_keyboard[mod_index]; 
				this.active_modifier_by_keyboard[mod_index] = MODIFIER_KEYBOARD_MOUSE_MAP[
					old_mod_state,
					this.active_modifier_by_mouse[mod_index],
					new_mod_state,
					this.active_modifier_by_mouse[mod_index]
				];
				this.active_modifier_by_mouse[mod_index] = MODIFIER_KEYBOARD_MOUSE_MAP[
					this.active_modifier_by_mouse[mod_index],
					old_mod_state,
					this.active_modifier_by_mouse[mod_index],
					new_mod_state
				];
			}else{
				//Mouseclick on shift button etc.
				old_mod_state = this.active_modifier_by_mouse[mod_index]; 
				this.active_modifier_by_mouse[mod_index] = MODIFIER_KEYBOARD_MOUSE_MAP[
					old_mod_state,
					this.active_modifier_by_keyboard[mod_index],
					new_mod_state,
					this.active_modifier_by_keyboard[mod_index]
				];
				this.active_modifier_by_keyboard[mod_index] = MODIFIER_KEYBOARD_MOUSE_MAP[
					this.active_modifier_by_keyboard[mod_index],
					old_mod_state,
					this.active_modifier_by_keyboard[mod_index],
					new_mod_state
				];
			}

		}

		public int getActiveModifierMask(int[] modifier){
			int modMask = 0;
			foreach( int i in modifier ){
				modMask += ( this.active_modifier_by_keyboard[i] | this.active_modifier_by_mouse[i] )
					*	this.MODIFIER_MASK[i];
			}
			return modMask;
		}

		private void check_modifier(int iet1){

			if(iet1 != this.ebene){
				this.ebene = iet1;
				render_page ();
			}
		}

		public void redraw(){
			var tebene = this.ebene;
			this.ebene = this.MODIFIER_MAP2[
				this.active_modifier_by_keyboard[1] | this.active_modifier_by_mouse[1], //shift
				this.active_modifier_by_keyboard[2] | this.active_modifier_by_mouse[2], //neo-mod3
				this.active_modifier_by_keyboard[3] | this.active_modifier_by_mouse[3] //neo-mod4
					] + 1;

			if( tebene != this.ebene)
				render_page();
		}


		private void render_page () {
			this.image.set_from_pixbuf(this.image_buffer[this.ebene]);
		}

		public Gdk.Pixbuf getIcon(){
			return this.image_buffer[0];
		}

		public void external_key_press(int iet1, int modifier_mask){
			for(int iet2=0; iet2<4; iet2++){
				if(this.NEO_MODIFIER_MASK[iet2]==modifier_mask){
					//debug("(Press)  e1=%i, e2=%i\n".printf(iet1,iet2));
					iet1 =  this.MODIFIER_MAP[iet1,iet2]+1;
					this.check_modifier(iet1);
					return;
				}
			}
			iet1 =  this.MODIFIER_MAP[iet1,0]+1;
			this.check_modifier(iet1);
		}

		public void external_key_release(int iet1, int modifier_mask){
			for(int iet2=0; iet2<4; iet2++){
				if(this.NEO_MODIFIER_MASK[iet2]==modifier_mask){
					//debug("(Relase) e1=%i, e2=%i\n\n".printf(iet1,iet2));
					iet1 =  this.MODIFIER_MAP_RELEASE[iet1,iet2]+1;
					this.check_modifier(iet1);
					return;
				}
			}

			iet1 =  this.MODIFIER_MAP_RELEASE[iet1,0]+1;
			this.check_modifier(iet1);
		}

		/*public void updateLayer(int iet){
			if( 0<iet && iet<7 && this.ebene==iet){
			this.ebene = iet;
			render_page();
			}
			}*/

	} //End class NeoWindow

}
