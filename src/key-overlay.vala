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

	public class ArrayBox {

		public uint[] val;

		public ArrayBox(uint[] val){
			this.val = val;
		}
	}

	public class KeyOverlay : Box {

		public Gee.HashMap<int,KeyEventBox> keyBoxes;
		public Gee.HashMap<int,ArrayBox> keysyms;
		private NeoWindow winMain;

		public KeyOverlay(NeoWindow winMain) {

			this.set_orientation(Gtk.Orientation.VERTICAL);
			this.set_homogeneous(false);
			this.set_spacing(0);
			this.winMain = winMain;
			this.keysyms =  generateKeysyms();
			this.keyBoxes =  new Gee.HashMap<int, KeyEventBox>();

			generateKeyevents();

			this.show();
		}

		public Gee.HashMap<int, ArrayBox> generateKeysyms(){
			keysyms =  new Gee.HashMap<int, ArrayBox>();

			/* Define keyboard layout. this object maps the keycodes to the list of keycodes of each keyboard layer. */
			keysyms.set(8, new ArrayBox({}));
			keysyms.set( 9, new ArrayBox({ XK_Escape, XK_Escape, XK_Escape, XK_Escape, XK_Escape }));
			keysyms.set( 10, new ArrayBox({ XK_1, XK_degree, XK_onesuperior, XK_onesubscript, XK_ordfeminine, XK_notsign, 0 /*NoSymbol*/ }));
			keysyms.set( 11, new ArrayBox({ XK_2, XK_section, XK_twosuperior, XK_twosubscript, XK_masculine, XK_logicalor, 0 /*NoSymbol*/ }));
			keysyms.set( 12, new ArrayBox({ XK_3, (uint)X.string_to_keysym("U2113"), XK_threesuperior, XK_threesubscript, XK_numerosign, XK_logicaland, 0 /*NoSymbol*/ }));
			keysyms.set( 13, new ArrayBox({ XK_4, XK_guillemotright, (uint)X.string_to_keysym("U203A"), XK_femalesymbol, 0 /*NoSymbol*/, (uint)X.string_to_keysym("U22A5"), 0 /*NoSymbol*/ }));
			keysyms.set( 14, new ArrayBox({ XK_5, XK_guillemotleft, (uint)X.string_to_keysym("U2039"), XK_malesymbol, XK_periodcentered, (uint)X.string_to_keysym("U2221"), 0 /*NoSymbol*/ }));
			keysyms.set( 15, new ArrayBox({ XK_6, XK_dollar, XK_cent, (uint)X.string_to_keysym("U26A5"), XK_sterling, (uint)X.string_to_keysym("U2225"), 0 /*NoSymbol*/ }));
			keysyms.set( 16, new ArrayBox({ XK_7, XK_EuroSign, XK_yen, (uint)X.string_to_keysym("U03F0"), XK_currency, XK_rightarrow, 0 /*NoSymbol*/ }));
			keysyms.set( 17, new ArrayBox({ XK_8, XK_doublelowquotemark, XK_singlelowquotemark, (uint)X.string_to_keysym("U27E8"), XK_Tab, (uint)X.string_to_keysym("U221E"), 0 /*NoSymbol*/ }));
			keysyms.set( 18, new ArrayBox({ XK_9, XK_leftdoublequotemark, XK_leftsinglequotemark, (uint)X.string_to_keysym("U27E9"), XK_KP_Divide, XK_variation, 0 /*NoSymbol*/ }));
			keysyms.set( 19, new ArrayBox({ XK_0, XK_rightdoublequotemark, XK_rightsinglequotemark, XK_zerosubscript, XK_KP_Multiply, XK_emptyset, 0 /*NoSymbol*/ }));
			keysyms.set( 20, new ArrayBox({ XK_minus, XK_emdash, 0 /*NoSymbol*/, (uint)X.string_to_keysym("U2011"), XK_KP_Subtract, XK_hyphen, 0 /*NoSymbol*/ }));
			keysyms.set( 21, new ArrayBox({ XK_dead_grave, XK_dead_cedilla, XK_dead_abovering, XK_dead_abovereversedcomma, XK_dead_diaeresis, XK_dead_macron, 0 /*NoSymbol*/ }));
			keysyms.set( 22, new ArrayBox({ XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace }));
			keysyms.set( 23, new ArrayBox({ XK_Tab, XK_ISO_Left_Tab, XK_Multi_key, XK_ISO_Level5_Lock, 0 /*NoSymbol*/, 0 /*NoSymbol*/, XK_ISO_Level5_Lock }));
			keysyms.set( 24, new ArrayBox({ XK_x, XK_X, XK_ellipsis, XK_Greek_xi, XK_Prior, XK_Greek_XI, 0 /*NoSymbol*/ }));
			keysyms.set( 25, new ArrayBox({ XK_v, XK_V, XK_underscore, 0 /*NoSymbol*/, XK_BackSpace, XK_radical, 0 /*NoSymbol*/ }));
			keysyms.set( 26, new ArrayBox({ XK_l, XK_L, XK_bracketleft, XK_Greek_lamda, XK_Up, XK_Greek_LAMDA, 0 /*NoSymbol*/ }));
			keysyms.set( 27, new ArrayBox({ XK_c, XK_C, XK_bracketright, XK_Greek_chi, XK_Delete, (uint)X.string_to_keysym("U2102"), 0 /*NoSymbol*/ }));
			keysyms.set( 28, new ArrayBox({ XK_w, XK_W, XK_asciicircum, XK_Greek_omega, XK_Next, XK_Greek_OMEGA, 0 /*NoSymbol*/ }));
			keysyms.set( 29, new ArrayBox({ XK_k, XK_K, XK_exclam, XK_Greek_kappa, XK_exclamdown, XK_multiply, 0 /*NoSymbol*/ }));
			keysyms.set( 30, new ArrayBox({ XK_h, XK_H, XK_less, XK_Greek_psi, XK_KP_7, XK_Greek_PSI, 0 /*NoSymbol*/ }));
			keysyms.set( 31, new ArrayBox({ XK_g, XK_G, XK_greater, XK_Greek_gamma, XK_KP_8, XK_Greek_GAMMA, 0 /*NoSymbol*/ }));
			keysyms.set( 32, new ArrayBox({ XK_f, XK_F, XK_equal, XK_Greek_phi, XK_KP_9, XK_Greek_PHI, 0 /*NoSymbol*/ }));
			keysyms.set( 33, new ArrayBox({ XK_q, XK_Q, XK_ampersand, (uint)X.string_to_keysym("U03D5"), XK_KP_Add, (uint)X.string_to_keysym("U211A"), 0 /*NoSymbol*/ }));
			keysyms.set( 34, new ArrayBox({ XK_ssharp, (uint)X.string_to_keysym("U1E9E"), (uint)X.string_to_keysym("U017F"), XK_Greek_finalsmallsigma, (uint)X.string_to_keysym("U2212"), XK_jot, 0 /*NoSymbol*/ }));
			keysyms.set( 35, new ArrayBox({ XK_dead_acute, XK_dead_tilde, XK_dead_stroke, XK_dead_abovecomma, XK_dead_doubleacute, XK_dead_breve, 0 /*NoSymbol*/ }));
			keysyms.set( 36, new ArrayBox({ XK_Return, XK_Return, XK_Return, XK_Return, XK_Return }));
			keysyms.set( 37, new ArrayBox({ XK_Control_L, XK_Control_L, XK_Control_L, XK_Control_L, XK_Control_L }));
			keysyms.set( 38, new ArrayBox({ XK_u, XK_U, XK_backslash, 0 /*NoSymbol*/, XK_Home, XK_includedin, 0 /*NoSymbol*/ }));
			keysyms.set( 39, new ArrayBox({ XK_i, XK_I, XK_slash, XK_Greek_iota, XK_Left, XK_integral, 0 /*NoSymbol*/ }));
			keysyms.set( 40, new ArrayBox({ XK_a, XK_A, XK_braceleft, XK_Greek_alpha, XK_Down, (uint)X.string_to_keysym("U2200"), 0 /*NoSymbol*/ }));
			keysyms.set( 41, new ArrayBox({ XK_e, XK_E, XK_braceright, XK_Greek_epsilon, XK_Right, (uint)X.string_to_keysym("U2203"), 0 /*NoSymbol*/ }));
			keysyms.set( 42, new ArrayBox({ XK_o, XK_O, XK_asterisk, XK_Greek_omicron, XK_End, XK_elementof, 0 /*NoSymbol*/ }));
			keysyms.set( 43, new ArrayBox({ XK_s, XK_S, XK_question, XK_Greek_sigma, XK_questiondown, XK_Greek_SIGMA, 0 /*NoSymbol*/ }));
			keysyms.set( 44, new ArrayBox({ XK_n, XK_N, XK_parenleft, XK_Greek_nu, XK_KP_4, (uint)X.string_to_keysym("U2115"), 0 /*NoSymbol*/ }));
			keysyms.set( 45, new ArrayBox({ XK_r, XK_R, XK_parenright, XK_Greek_rho, XK_KP_5, (uint)X.string_to_keysym("U211D"), 0 /*NoSymbol*/ }));
			keysyms.set( 46, new ArrayBox({ XK_t, XK_T, XK_minus, XK_Greek_tau, XK_KP_6, XK_partialderivative, 0 /*NoSymbol*/ }));
			keysyms.set( 47, new ArrayBox({ XK_d, XK_D, XK_colon, XK_Greek_delta, XK_KP_Separator, XK_Greek_DELTA, 0 /*NoSymbol*/ }));
			keysyms.set( 48, new ArrayBox({ XK_y, XK_Y, XK_at, XK_Greek_upsilon, XK_period, XK_nabla, 0 /*NoSymbol*/ }));
			keysyms.set( 49, new ArrayBox({ XK_dead_circumflex, XK_dead_caron, (uint)X.string_to_keysym("U21BB"), (uint)X.string_to_keysym("U02DE"), XK_dead_abovedot, XK_dead_belowdot, 0 /*NoSymbol*/ }));
			keysyms.set( 50, new ArrayBox({ XK_Shift_L, XK_Caps_Lock }));
			keysyms.set( 51, new ArrayBox({ XK_ISO_Level3_Shift }));
			keysyms.set( 52, new ArrayBox({ XK_udiaeresis, XK_Udiaeresis, XK_numbersign, 0 /*NoSymbol*/, XK_Escape, XK_union, 0 /*NoSymbol*/ }));
			keysyms.set( 53, new ArrayBox({ XK_odiaeresis, XK_Odiaeresis, XK_dollar, (uint)X.string_to_keysym("U03F5"), XK_Tab, XK_intersection, 0 /*NoSymbol*/ }));
			keysyms.set( 54, new ArrayBox({ XK_adiaeresis, XK_Adiaeresis, XK_bar, XK_Greek_eta, XK_Insert, (uint)X.string_to_keysym("U2135"), 0 /*NoSymbol*/ }));
			keysyms.set( 55, new ArrayBox({ XK_p, XK_P, XK_asciitilde, XK_Greek_pi, XK_Return, XK_Greek_PI, 0 /*NoSymbol*/ }));
			keysyms.set( 56, new ArrayBox({ XK_z, XK_Z, XK_grave, XK_Greek_zeta, XK_Undo, (uint)X.string_to_keysym("U2124"), 0 /*NoSymbol*/ }));
			keysyms.set( 57, new ArrayBox({ XK_b, XK_B, XK_plus, XK_Greek_beta, XK_colon, (uint)X.string_to_keysym("U21D0"), 0 /*NoSymbol*/ }));
			keysyms.set( 58, new ArrayBox({ XK_m, XK_M, XK_percent, XK_Greek_mu, XK_KP_1, XK_ifonlyif, 0 /*NoSymbol*/ }));
			keysyms.set( 59, new ArrayBox({ XK_comma, XK_endash, XK_quotedbl, (uint)X.string_to_keysym("U03F1"), XK_KP_2, (uint)X.string_to_keysym("U21D2"), 0 /*NoSymbol*/ }));
			keysyms.set( 60, new ArrayBox({ XK_period, XK_enfilledcircbullet, XK_apostrophe, (uint)X.string_to_keysym("U03D1"), XK_KP_3, (uint)X.string_to_keysym("U21A6"), 0 /*NoSymbol*/ }));
			keysyms.set( 61, new ArrayBox({ XK_j, XK_J, XK_semicolon, XK_Greek_theta, XK_semicolon, XK_Greek_THETA, 0 /*NoSymbol*/ }));
			keysyms.set( 62, new ArrayBox({ XK_Shift_R, XK_Caps_Lock }));
			keysyms.set( 63, new ArrayBox({ XK_KP_Multiply, XK_KP_Multiply, (uint)X.string_to_keysym("U2219"), (uint)X.string_to_keysym("U2299"), XK_multiply, (uint)X.string_to_keysym("U2297"), 0 /*NoSymbol*/ }));
			keysyms.set( 64, new ArrayBox({ XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L, XK_Alt_L }));
			keysyms.set( 65, new ArrayBox({ XK_space, XK_space, XK_space, XK_nobreakspace, XK_KP_0, (uint)X.string_to_keysym("U202F"), 0 /*NoSymbol*/ }));
			keysyms.set( 66, new ArrayBox({ XK_ISO_Level3_Shift }));
			keysyms.set( 67, new ArrayBox({ XK_F1, 0 /*XK_XF86_Switch_VT_1*/ }));
			keysyms.set( 68, new ArrayBox({ XK_F2, 0 /*XK_XF86_Switch_VT_2*/ }));
			keysyms.set( 69, new ArrayBox({ XK_F3, 0 /*XK_XF86_Switch_VT_3*/ }));
			keysyms.set( 70, new ArrayBox({ XK_F4, 0 /*XK_XF86_Switch_VT_4*/ }));
			keysyms.set( 71, new ArrayBox({ XK_F5, 0 /*XK_XF86_Switch_VT_5*/ }));
			keysyms.set( 72, new ArrayBox({ XK_F6, 0 /*XK_XF86_Switch_VT_6*/ }));
			keysyms.set( 73, new ArrayBox({ XK_F7, 0 /*XK_XF86_Switch_VT_7*/ }));
			keysyms.set( 74, new ArrayBox({ XK_F8, 0 /*XK_XF86_Switch_VT_8*/ }));
			keysyms.set( 75, new ArrayBox({ XK_F9, 0 /*XK_XF86_Switch_VT_9*/ }));
			keysyms.set( 76, new ArrayBox({ XK_F10, 0 /*XK_XF86_Switch_VT_10*/ }));
			keysyms.set( 77, new ArrayBox({ XK_Tab, XK_ISO_Left_Tab, XK_equal, XK_approxeq, XK_notequal, XK_identical, 0 /*NoSymbol*/ }));
			keysyms.set( 78, new ArrayBox({ XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock, XK_Scroll_Lock }));
			keysyms.set( 79, new ArrayBox({ XK_KP_7, (uint)X.string_to_keysym("U2714"), (uint)X.string_to_keysym("U2195"), (uint)X.string_to_keysym("U226A"), XK_KP_Home, XK_upstile, 0 /*NoSymbol*/ }));
			keysyms.set( 80, new ArrayBox({ XK_KP_8, (uint)X.string_to_keysym("U2718"), XK_uparrow, XK_intersection, XK_KP_Up, (uint)X.string_to_keysym("U22C2"), 
						0 /*NoSymbol*/ }));
			keysyms.set( 81, new ArrayBox({ XK_KP_9, XK_dagger, (uint)X.string_to_keysym("U20D7"), (uint)X.string_to_keysym("U226B"), XK_KP_Prior, (uint)X.string_to_keysym("U2309"), 0 /*NoSymbol*/ }));
			keysyms.set( 82, new ArrayBox({ XK_KP_Subtract, XK_KP_Subtract, (uint)X.string_to_keysym("U2212"), (uint)X.string_to_keysym("U2296"), (uint)X.string_to_keysym("U2216"), (uint)X.string_to_keysym("U2238"), 0 /*NoSymbol*/ }));
			keysyms.set( 83, new ArrayBox({ XK_KP_4, XK_club, XK_leftarrow, XK_includedin, XK_KP_Left, (uint)X.string_to_keysym("U2286"), 0 /*NoSymbol*/ }));
			keysyms.set( 84, new ArrayBox({ XK_KP_5, XK_EuroSign, XK_colon, (uint)X.string_to_keysym("U22B6"), XK_KP_Begin, (uint)X.string_to_keysym("U22B7"), 0 /*NoSymbol*/ }));
			keysyms.set( 85, new ArrayBox({ XK_KP_6, (uint)X.string_to_keysym("U2023"), XK_rightarrow, XK_includes, XK_KP_Right, (uint)X.string_to_keysym("U2287"), 0 /*NoSymbol*/ }));
			keysyms.set( 86, new ArrayBox({ XK_KP_Add, XK_KP_Add, XK_plusminus, (uint)X.string_to_keysym("U2295"), (uint)X.string_to_keysym("U2213"), (uint)X.string_to_keysym("U2214"), 0 /*NoSymbol*/ }));
			keysyms.set( 87, new ArrayBox({ XK_KP_1, XK_diamond, (uint)X.string_to_keysym("U2194"), XK_lessthanequal, XK_KP_End, XK_downstile, 0 /*NoSymbol*/ }));
			keysyms.set( 88, new ArrayBox({ XK_KP_2, XK_heart, XK_downarrow, XK_union, XK_KP_Down, (uint)X.string_to_keysym("U22C3"), 0 /*NoSymbol*/ }));
			keysyms.set( 89, new ArrayBox({ XK_KP_3, (uint)X.string_to_keysym("U2660"), (uint)X.string_to_keysym("U21CC"), XK_greaterthanequal, XK_KP_Next, (uint)X.string_to_keysym("U230B"), 0 /*NoSymbol*/ }));
			keysyms.set( 90, new ArrayBox({ XK_KP_0, (uint)X.string_to_keysym("U2423"), XK_percent, (uint)X.string_to_keysym("U2030"), XK_KP_Insert, (uint)X.string_to_keysym("U25A1"), 0 /*NoSymbol*/ }));
			keysyms.set( 91, new ArrayBox({ XK_KP_Separator, XK_period, XK_comma, XK_minutes, XK_KP_Delete, XK_seconds, 0 /*NoSymbol*/ }));
			keysyms.set( 92, new ArrayBox({ XK_ISO_Level3_Shift }));
			keysyms.set( 93, new ArrayBox({ }));
			keysyms.set( 94, new ArrayBox({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock }));
			keysyms.set( 95, new ArrayBox({ XK_F11, 0 /*XK_XF86_Switch_VT_11*/ }));
			keysyms.set( 96, new ArrayBox({ XK_F12, 0 /*XK_XF86_Switch_VT_12*/ }));
			keysyms.set( 97, new ArrayBox({ }));
			keysyms.set( 98, new ArrayBox({ XK_Katakana }));
			keysyms.set( 99, new ArrayBox({ XK_Hiragana }));
			keysyms.set(100, new ArrayBox({ XK_Henkan_Mode }));
			keysyms.set(101, new ArrayBox({ XK_Hiragana_Katakana }));
			keysyms.set(102, new ArrayBox({ XK_Muhenkan }));
			keysyms.set(103, new ArrayBox({ }));
			keysyms.set(104, new ArrayBox({ XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, 0 /*NoSymbol*/ }));
			keysyms.set(105, new ArrayBox({ XK_Control_R, XK_Control_R, XK_Control_R, XK_Control_R, XK_Control_R }));
			keysyms.set(106, new ArrayBox({ XK_KP_Divide, XK_KP_Divide, XK_division, (uint)X.string_to_keysym("U2300"), (uint)X.string_to_keysym("U2215"), (uint)X.string_to_keysym("U2223"), 0 /*NoSymbol*/ }));
			keysyms.set(107, new ArrayBox({ XK_Print, XK_Sys_Req }));
			keysyms.set(108, new ArrayBox({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock, XK_ISO_Level5_Lock }));
			keysyms.set(109, new ArrayBox({ XK_Linefeed, XK_Linefeed, XK_Linefeed, XK_Linefeed, XK_Linefeed }));
			keysyms.set(110, new ArrayBox({ XK_Home, XK_Home, XK_Home, XK_Home, XK_Home }));
			keysyms.set(111, new ArrayBox({ XK_Up, XK_Up, XK_Up, XK_Up, XK_Up }));
			keysyms.set(112, new ArrayBox({ XK_Prior, XK_Prior, XK_Prior, XK_Prior, XK_Prior }));
			keysyms.set(113, new ArrayBox({ XK_Left, XK_Left, XK_Left, XK_Left, XK_Left }));
			keysyms.set(114, new ArrayBox({ XK_Right, XK_Right, XK_Right, XK_Right, XK_Right }));
			keysyms.set(115, new ArrayBox({ XK_End, XK_End, XK_End, XK_End, XK_End }));
			keysyms.set(116, new ArrayBox({ XK_Down, XK_Down, XK_Down, XK_Down, XK_Down }));
			keysyms.set(117, new ArrayBox({ XK_Next, XK_Next, XK_Next, XK_Next, XK_Next }));
			keysyms.set(118, new ArrayBox({ XK_Insert, XK_Insert, XK_Insert, XK_Insert, XK_Insert }));
			keysyms.set(119, new ArrayBox({ XK_Delete, XK_Delete, XK_Delete, XK_Delete, XK_Delete }));
			keysyms.set(120, new ArrayBox({ }));
			keysyms.set(121, new ArrayBox({ 0 /*XK_XF86AudioMute*/ }));
			keysyms.set(122, new ArrayBox({ 0 /*XK_XF86AudioLowerVolume*/ }));
			keysyms.set(123, new ArrayBox({ 0 /*XK_XF86AudioRaiseVolume*/ }));
			keysyms.set(124, new ArrayBox({ 0 /*XK_XF86PowerOff*/ }));
			keysyms.set(125, new ArrayBox({ XK_KP_Equal, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/, 0 /*NoSymbol*/ }));
			keysyms.set(126, new ArrayBox({ XK_plusminus }));
			keysyms.set(127, new ArrayBox({ XK_Pause, XK_Break }));
			keysyms.set(128, new ArrayBox({ 0 /*XK_XF86LaunchA*/ }));
			keysyms.set(129, new ArrayBox({ XK_KP_Decimal }));
			keysyms.set(130, new ArrayBox({ XK_Hangul }));
			keysyms.set(131, new ArrayBox({ XK_Hangul_Hanja }));
			keysyms.set(132, new ArrayBox({ }));
			keysyms.set(133, new ArrayBox({ XK_Super_L }));
			keysyms.set(134, new ArrayBox({ XK_Super_R }));
			keysyms.set(135, new ArrayBox({ XK_Menu }));
			keysyms.set(136, new ArrayBox({ XK_Cancel }));
			keysyms.set(137, new ArrayBox({ XK_Redo }));
			keysyms.set(138, new ArrayBox({ 0 /*XK_SunProps*/ }));
			keysyms.set(139, new ArrayBox({ XK_Undo }));
			keysyms.set(140, new ArrayBox({ 0 /*XK_SunFront*/ }));
			keysyms.set(141, new ArrayBox({ 0 /*XK_XF86Copy*/ }));
			keysyms.set(142, new ArrayBox({ 0 /*XK_SunOpen*/ }));
			keysyms.set(143, new ArrayBox({ 0 /*XK_XF86Paste*/ }));
			keysyms.set(144, new ArrayBox({ XK_Find }));
			keysyms.set(145, new ArrayBox({ 0 /*XK_XF86Cut*/ }));
			keysyms.set(146, new ArrayBox({ XK_Help }));
			keysyms.set(147, new ArrayBox({ 0 /*XK_XF86MenuKB*/ }));
			keysyms.set(148, new ArrayBox({ 0 /*XK_XF86Calculator*/ }));
			keysyms.set(149, new ArrayBox({ }));
			keysyms.set(150, new ArrayBox({ 0 /*XK_XF86Sleep*/ }));
			keysyms.set(151, new ArrayBox({ 0 /*XK_XF86WakeUp*/ }));
			keysyms.set(152, new ArrayBox({ 0 /*XK_XF86Explorer*/ }));
			keysyms.set(153, new ArrayBox({ 0 /*XK_XF86Send*/ }));
			keysyms.set(154, new ArrayBox({ }));
			keysyms.set(155, new ArrayBox({ 0 /*XK_XF86Xfer*/ }));
			keysyms.set(156, new ArrayBox({ 0 /*XK_XF86Launch1*/ }));
			keysyms.set(157, new ArrayBox({ 0 /*XK_XF86Launch2*/ }));
			keysyms.set(158, new ArrayBox({ 0 /*XK_XF86WWW*/ }));
			keysyms.set(159, new ArrayBox({ 0 /*XK_XF86DOS*/ }));
			keysyms.set(160, new ArrayBox({ 0 /*XK_XF86ScreenSaver*/ }));
			keysyms.set(161, new ArrayBox({ }));
			keysyms.set(162, new ArrayBox({ 0 /*XK_XF86RotateWindows*/ }));
			keysyms.set(163, new ArrayBox({ 0 /*XK_XF86Mail*/ }));
			keysyms.set(164, new ArrayBox({ 0 /*XK_XF86Favorites*/ }));
			keysyms.set(165, new ArrayBox({ 0 /*XK_XF86MyComputer*/ }));
			keysyms.set(166, new ArrayBox({ 0 /*XK_XF86Back*/ }));
			keysyms.set(167, new ArrayBox({ 0 /*XK_XF86Forward*/ }));
			keysyms.set(168, new ArrayBox({ }));
			keysyms.set(169, new ArrayBox({ 0 /*XK_XF86Eject*/ }));
			keysyms.set(170, new ArrayBox({ 0 /*XK_XF86Eject*/, 0 /*XK_XF86Eject*/ }));
			keysyms.set(171, new ArrayBox({ 0 /*XK_XF86AudioNext*/ }));
			keysyms.set(172, new ArrayBox({ 0 /*XK_XF86AudioPlay*/, 0 /*XK_XF86AudioPause*/ }));
			keysyms.set(173, new ArrayBox({ 0 /*XK_XF86AudioPrev*/ }));
			keysyms.set(174, new ArrayBox({ 0 /*XK_XF86AudioStop*/, 0 /*XK_XF86Eject*/ }));
			keysyms.set(175, new ArrayBox({ 0 /*XK_XF86AudioRecord*/ }));
			keysyms.set(176, new ArrayBox({ 0 /*XK_XF86AudioRewind*/ }));
			keysyms.set(177, new ArrayBox({ 0 /*XK_XF86Phone*/ }));
			keysyms.set(178, new ArrayBox({ }));
			keysyms.set(179, new ArrayBox({ 0 /*XK_XF86Tools*/ }));
			keysyms.set(180, new ArrayBox({ 0 /*XK_XF86HomePage*/ }));
			keysyms.set(181, new ArrayBox({ 0 /*XK_XF86Reload*/ }));
			keysyms.set(182, new ArrayBox({ 0 /*XK_XF86Close*/ }));
			keysyms.set(183, new ArrayBox({ }));
			keysyms.set(184, new ArrayBox({ }));
			keysyms.set(185, new ArrayBox({ 0 /*XK_XF86ScrollUp*/ }));
			keysyms.set(186, new ArrayBox({ 0 /*XK_XF86ScrollDown*/ }));
			keysyms.set(187, new ArrayBox({ XK_parenleft }));
			keysyms.set(188, new ArrayBox({ XK_parenright }));
			keysyms.set(189, new ArrayBox({ 0 /*XK_XF86New*/ }));
			keysyms.set(190, new ArrayBox({ XK_Redo }));
			keysyms.set(191, new ArrayBox({ 0 /*XK_XF86Tools*/ }));
			keysyms.set(192, new ArrayBox({ 0 /*XK_XF86Launch5*/ }));
			keysyms.set(193, new ArrayBox({ 0 /*XK_XF86MenuKB*/ }));
			keysyms.set(194, new ArrayBox({ }));
			keysyms.set(195, new ArrayBox({ }));
			keysyms.set(196, new ArrayBox({ }));
			keysyms.set(197, new ArrayBox({ }));
			keysyms.set(198, new ArrayBox({ }));
			keysyms.set(199, new ArrayBox({ }));
			keysyms.set(200, new ArrayBox({ 0 /*XK_XF86TouchpadToggle*/ }));
			keysyms.set(201, new ArrayBox({ }));
			keysyms.set(202, new ArrayBox({ }));
			keysyms.set(203, new ArrayBox({ XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift, XK_ISO_Level5_Shift }));
			keysyms.set(204, new ArrayBox({ XK_Alt_L }));
			keysyms.set(205, new ArrayBox({ XK_Alt_L }));
			keysyms.set(206, new ArrayBox({ XK_Super_L }));
			keysyms.set(207, new ArrayBox({ }));
			keysyms.set(208, new ArrayBox({ 0 /*XK_XF86AudioPlay*/ }));
			keysyms.set(209, new ArrayBox({ 0 /*XK_XF86AudioPause*/ }));
			keysyms.set(210, new ArrayBox({ 0 /*XK_XF86Launch3*/ }));
			keysyms.set(211, new ArrayBox({ 0 /*XK_XF86Launch4*/ }));
			keysyms.set(212, new ArrayBox({ 0 /*XK_XF86LaunchB*/ }));
			keysyms.set(213, new ArrayBox({ 0 /*XK_XF86Suspend*/ }));
			keysyms.set(214, new ArrayBox({ 0 /*XK_XF86Close*/ }));
			keysyms.set(215, new ArrayBox({ 0 /*XK_XF86AudioPlay*/ }));
			keysyms.set(216, new 
					ArrayBox({ 0 /*XK_XF86AudioForward*/ }));
			keysyms.set(217, new ArrayBox({ }));
			keysyms.set(218, new ArrayBox({ XK_Print }));
			keysyms.set(219, new ArrayBox({ }));
			keysyms.set(220, new ArrayBox({ 0 /*XK_XF86WebCam*/ }));
			keysyms.set(221, new ArrayBox({ }));
			keysyms.set(222, new ArrayBox({ }));
			keysyms.set(223, new ArrayBox({ 0 /*XK_XF86Mail*/ }));
			keysyms.set(224, new ArrayBox({ }));
			keysyms.set(225, new ArrayBox({ 0 /*XK_XF86Search*/ }));
			keysyms.set(226, new ArrayBox({ }));
			keysyms.set(227, new ArrayBox({ 0 /*XK_XF86Finance*/ }));
			keysyms.set(228, new ArrayBox({ }));
			keysyms.set(229, new ArrayBox({ 0 /*XK_XF86Shop*/ }));
			keysyms.set(230, new ArrayBox({ }));
			keysyms.set(231, new ArrayBox({ XK_Cancel }));
			keysyms.set(232, new ArrayBox({ 0 /*XK_XF86MonBrightnessDown*/ }));
			keysyms.set(233, new ArrayBox({ 0 /*XK_XF86MonBrightnessUp*/ }));
			keysyms.set(234, new ArrayBox({ 0 /*XK_XF86AudioMedia*/ }));
			keysyms.set(235, new ArrayBox({ 0 /*XK_XF86Display*/ }));
			keysyms.set(236, new ArrayBox({ 0 /*XK_XF86KbdLightOnOff*/ }));
			keysyms.set(237, new ArrayBox({ 0 /*XK_XF86KbdBrightnessDown*/ }));
			keysyms.set(238, new ArrayBox({ 0 /*XK_XF86KbdBrightnessUp*/ }));
			keysyms.set(239, new ArrayBox({ 0 /*XK_XF86Send*/ }));
			keysyms.set(240, new ArrayBox({ 0 /*XK_XF86Reply*/ }));
			keysyms.set(241, new ArrayBox({ 0 /*XK_XF86MailForward*/ }));
			keysyms.set(242, new ArrayBox({ 0 /*XK_XF86Save*/ }));
			keysyms.set(243, new ArrayBox({ 0 /*XK_XF86Documents*/ }));
			keysyms.set(244, new ArrayBox({ 0 /*XK_XF86Battery*/ }));
			keysyms.set(245, new ArrayBox({ 0 /*XK_XF86Bluetooth*/ }));
			keysyms.set(246, new ArrayBox({ 0 /*XK_XF86WLAN*/ }));
			keysyms.set(247, new ArrayBox({ }));
			keysyms.set(248, new ArrayBox({ }));
			keysyms.set(249, new ArrayBox({ }));
			keysyms.set(250, new ArrayBox({ }));
			keysyms.set(251, new ArrayBox({ }));
			keysyms.set(252, new ArrayBox({ }));
			keysyms.set(253, new ArrayBox({ }));
			keysyms.set(254, new ArrayBox({ }));
			keysyms.set(255, new ArrayBox({ }));

			return keysyms;
		}

		private Box genHBox(){
			Box b = new Box(Gtk.Orientation.HORIZONTAL, 0);
			b.set_homogeneous(false);
			return b;
		}

		public void generateKeyevents() {

			Box[] hboxes = {
				genHBox(), // top row (1,2,3,…)
				genHBox(), // upper row (x,v,l,…)
				genHBox(), // home row (u,i,a,…)
				genHBox(), // lower row (ü,ö,ä,…)
				genHBox(), // space row
				genHBox() //function key row
			};

			if (winMain.config.get("display_function_keys") != "0") {
				this.pack_start( hboxes[5], false, true, 0 );
			}

			this.pack_start( hboxes[0], false, true, 0 );
			this.pack_start( hboxes[1], false, true, 0 );
			this.pack_start( hboxes[2], false, true, 0 );
			this.pack_start( hboxes[3], false, true, 0 );
			this.pack_start( hboxes[4], false, true, 0 );

			foreach( var hbox in hboxes ) {
				hbox.show();
			}

			double winWidthUnscaled = 1000.0;
			double winHeightUnscaled = 250.0;

			if (winMain.config.get("display_function_keys") == "0") {
				winHeightUnscaled -= winMain.function_keys_height;
			}

			if (winMain.config.get("display_numpad") == "0") {
				winWidthUnscaled -= winMain.numpad_width;
			}

			int width, height;
			winMain.get_size2(out width, out height);

			double scaleX = width/winWidthUnscaled;
			double scaleY = height/winHeightUnscaled;

			double posXUnscaled = 0.0;
			double posYUnscaled = 0.0;
			int posX = 0;
			int posY = 0;

			if (winMain.config.get("display_function_keys") != "0") {
				//esc
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 9, false, winMain, hboxes[5], 0);
				//free space
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[5], -1);
				// F1-F4
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 67, false, winMain, hboxes[5], 0);
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 68, false, winMain, hboxes[5], 0);
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 69, false, winMain, hboxes[5], 0);
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 70, false, winMain, hboxes[5], 0);
				//free space
				scaledBox(22.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[5], -1);
				// F5-F8
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 71, false, winMain, hboxes[5], 0);
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 72, false, winMain, hboxes[5], 0);
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 73, false, winMain, hboxes[5], 0);
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 74, false, winMain, hboxes[5], 0);
				//free space
				scaledBox(22.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[5], -1);
				// F9-F11
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 75, false, winMain, hboxes[5], 0);
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 76, false, winMain, hboxes[5], 0);
				scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 95, false, winMain, hboxes[5], 0);

				if (winMain.config.get("display_numpad") != "0") {
					//F12
					scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 96, false, winMain, hboxes[5], 0);
					//free space
					scaledBox(22.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[5], -1);
					// print,scroll,break
					scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 107, true, winMain, hboxes[5], 0);
					scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 78, true, winMain, hboxes[5], 0);
					scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 127, true, winMain, hboxes[5], 0);

				} else {
					//F12
					scaledBox(44.0,30.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 96, true, winMain, hboxes[5], 0);
				}

				//Reset right shift. 
				posXUnscaled = 0.0;
				posX = 0;
			}

			//++ Top row ++
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 49, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 10, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 11, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 12, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 13, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 14, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 15, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 16, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 17, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 18, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 19, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 20, false, winMain, hboxes[0], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 21 , false, winMain, hboxes[0], 0);

			if (winMain.config.get("display_numpad") != "0") {
				scaledBox(78.0-1.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 22 , false, winMain, hboxes[0], 0);
				//free space
				scaledBox(22.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[0], -1);
				//ins home page_up
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 118 , false, winMain, hboxes[0], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 110 , false, winMain, hboxes[0], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 112 , false, winMain, hboxes[0], 0);
				//free space
				scaledBox(22.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[0], -1);
				//num key, divide, times, and minus
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 77 , false, winMain, hboxes[0], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 106 , false, winMain, hboxes[0], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 63 , false, winMain, hboxes[0], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 82 , true, winMain, hboxes[0], 0);
			} else {
				scaledBox(78.0-1.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 22 , true, winMain, hboxes[0], 0);
			}
			//Reset right shift. 
			posXUnscaled = 0.0;
			posX = 0;
			//++ End top row ++
			//++ Second row ++
			scaledBox(60.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 23 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 24 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 25 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 26 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 27 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 28 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 29 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 30 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 31 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 32 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 33 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 34 , false, winMain, hboxes[1], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 35 , false, winMain, hboxes[1], 0);

			if (winMain.config.get("display_numpad") != "0") {
				//Halve of Return/Enter
				scaledBox(62.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 36 , false, winMain, hboxes[1], 0);
				//free space
				scaledBox(22.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[1], -1);
				//entf end page_down
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 119 , false, winMain, hboxes[1], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 115 , false, winMain, hboxes[1], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 117 , false, winMain, hboxes[1], 0);
				//free space
				scaledBox(22.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[1], -1);
				//7, 8, 9, and halve of plus
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 79 , false, winMain, hboxes[1], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 80 , false, winMain, hboxes[1], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 81 , false, winMain, hboxes[1], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 86 , true, winMain, hboxes[1], 0);
			} else {
				//Halve of Return/Enter
				scaledBox(62.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 36 , true, winMain, hboxes[1], 0);
			}

			//Reset right shift. 
			posXUnscaled = 0.0;
			posX = 0;

			//++ End upper row ++
			//++ home row ++
			//left mod3
			scaledBox(73.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 2/*37*/ , false, winMain, hboxes[2], 1);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 38 , false, winMain, hboxes[2], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 39 , false, winMain, hboxes[2], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 40 , false, winMain, hboxes[2], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 41 , false, winMain, hboxes[2], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 42 , false, winMain, hboxes[2], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 43 , false, winMain, hboxes[2], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 44 , false, winMain, hboxes[2], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 45 , false, winMain, hboxes[2], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 46 , false, winMain, hboxes[2], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 47 , false, winMain, hboxes[2], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 48 , false, winMain, hboxes[2], 0);
			//right mod3
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 2/*51*/ , false, winMain, hboxes[2], 1);

			if (winMain.config.get("display_numpad") != "0") {
				//Second halve of Enter/Return
				scaledBox(49.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 36 , false, winMain, hboxes[2], 0);
				//free space
				scaledBox(174.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[2], -1);
				//4, 5, 6, and halve of plus
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 83 , false, winMain, hboxes[2], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 84 , false, winMain, hboxes[2], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 85 , false, winMain, hboxes[2], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 86 , true, winMain, hboxes[2], 0);
			} else {
				//Second halve of Enter/Return
				scaledBox(49.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 36 , true, winMain, hboxes[2], 0);
			}

			//Reset right shift. 
			posXUnscaled = 0.0;
			posX = 0;
			//++ End home row ++
			//++ lower row ++
			//left shift
			scaledBox(52.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 1/*50*/ , false, winMain, hboxes[3], 1);
			//mod4
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 3/*94*/ , false, winMain, hboxes[3], 1);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 52 , false, winMain, hboxes[3], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 53 , false, winMain, hboxes[3], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 54 , false, winMain, hboxes[3], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 55 , false, winMain, hboxes[3], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 56 , false, winMain, hboxes[3], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 57 , false, winMain, hboxes[3], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 58 , false, winMain, hboxes[3], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 59 , false, winMain, hboxes[3], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 60 , false, winMain, hboxes[3], 0);
			scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 61 , false, winMain, hboxes[3], 0);

			if (winMain.config.get("display_numpad") != "0") {
				//right shift
				scaledBox(114.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 1 /*62*/ , false, winMain, hboxes[3], 1);
				//free space
				scaledBox(66.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[3], -1);
				// up
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 111 , false, winMain, hboxes[3], 0);
				//free space
				scaledBox(66.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[3], -1);
				//1, 2, 3, and halve of enter 
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 87 , false, winMain, hboxes[3], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 88 , false, winMain, hboxes[3], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 89 , false, winMain, hboxes[3], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 104 , true, winMain, hboxes[3], 0);
			} else {
				//right shift
				scaledBox(114.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 1 /*62*/ , true, winMain, hboxes[3], 1);
			}
			//Reset right shift. 
			posXUnscaled = 0.0;
			posX = 0;
			//++ End lower row ++
			//++ last/space row ++
			//left ctrl, 37
			scaledBox(61.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 4/*37*/ , false, winMain, hboxes[4], 2);
			//free space
			scaledBox(48.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[4], -1);
			//alt
			scaledBox(61.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 5/*64*/ , false, winMain, hboxes[4], 4);
			//space
			scaledBox(316.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 65 , false, winMain, hboxes[4], 0);
			//mod4
			scaledBox(61.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 3/*94*/ , false, winMain, hboxes[4], 1);
			//free space
			scaledBox(40.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[4], -1);

			if (winMain.config.get("display_numpad") != "0") {
				// right ctrl
				scaledBox(61.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 4/*105*/ , false, winMain, hboxes[4], 3);
				//free space
				scaledBox(22.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[4], -1);
				//left, down, right
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 113 , false, winMain, hboxes[4], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 116 , false, winMain, hboxes[4], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 114 , false, winMain, hboxes[4], 0);
				//free space
				scaledBox(22.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[4], -1);
				//0, comma, and halve of enter 
				scaledBox(88.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 90 , false, winMain, hboxes[4], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 91 , false, winMain, hboxes[4], 0);
				scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 104 , false, winMain, hboxes[4], 0);
			} else {  
				// right ctrl
				scaledBox(61.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 4/*105*/ , false, winMain, hboxes[4], 3);
			}

			//++ End last/space row ++
		}


		/*
			 Gibt skalierte EventBox zurück. Damit sich die Rundungfehler durch int-Cast nicht aufzusummieren,
			 basieren die Werte auf der bis zu diesem Zeitpunkt zu erwartenden Gesamtbreite/höhe.
		 */
		private KeyEventBox scaledBox(double widthUnscaled, double heightUnscaled,
				ref double posXUnscaled, ref double posYUnscaled,
				ref int posX, ref int posY,
				double scaleX, double scaleY,
				int keycode, bool vertical, NeoWindow winMain, Box box, int boxtype) {

			int width = (int)GLib.Math.floor((posXUnscaled + widthUnscaled) * scaleX - posX );
			int height = (int)GLib.Math.floor((posYUnscaled + heightUnscaled) * scaleY - posY);

			if (vertical) { 
				posYUnscaled += heightUnscaled;
				posY += height;
			} else {
				posXUnscaled += widthUnscaled;
				posX += width;
			}

			KeyEventBox keybox;
			switch (boxtype) {
				case 0:
					// Normale Taste
					ArrayBox ks = this.keysyms.get(keycode);
					keybox = new KeyEventBox(winMain, width, height, ref ks.val );
					this.keyBoxes.set(keycode, keybox);
					box.pack_start(keybox, false, true, 0 );
					break;
				case 1:
					// Modifier, die andere Buchstabenebenen aktivieren. Zusätzlich Ebenen-Bild einblenden.
					keybox = new KeyEventBox.modifier(winMain, width, height, keycode /*=modifier array index*/ );
					this.keyBoxes.set(keycode, keybox);
					box.pack_start(keybox, false, true, 0 );
					break;
					//Andere Modifier (CTRL, Alt,... )
				case 2: //left ctrl
					keybox = new KeyEventBox.modifier2(winMain, width, height, keycode /*modifier array index */, "tastatur_ctrl_left_2.png" );
					this.keyBoxes.set(keycode, keybox);
					box.pack_start(keybox, false, true, 0 );
					break;
				case 3: //right ctrl
					keybox = new KeyEventBox.modifier2(winMain, width, height, keycode /*modifier array index */, "tastatur_ctrl_right_2.png" );
					this.keyBoxes.set(keycode, keybox);
					box.pack_start(keybox, false, true, 0 );
					break;
				case 4: //left alt
					keybox = new KeyEventBox.modifier2(winMain, width, height, keycode /*modifier array index */, "tastatur_alt_left_2.png" );
					this.keyBoxes.set(keycode, keybox);
					box.pack_start(keybox, false, true, 0 );
					break;
				default:
					// Fläche ohne Funktion
					keybox = new KeyEventBox.freeArea(winMain, width, height );
					this.keyBoxes.set(keycode, keybox);
					box.pack_start(keybox, false, true, 0 );
					break;
				}


			return keybox;
		}


	} //End Class KeyOverlay



	public class KeyEventBox : EventBox{

		private uint[] keysym;// or
		private int modifier_index;

		private NeoWindow winMain;
		private int width;
		private int height;
		private Gtk.Image image;

		/*
			 Die Reihenfolge der Zeichen in keysyms passt nicht
			 zur Nummerierung der Ebenen in winMain. Mit diesem Array
			 wird der Wert permutiert.
			 Achtung, mittlerweile ist es die Identitätsabbildung, da die zwei
			 redundanten Layer, die durch Caps-Lock entstehen, entfernt wurden.
		 */
		private static const short[] layer_permutation = {0,1,2,3,5,4,6};

		private KeyEventBox.all(NeoWindow winMain, int width, int height) {
			this.winMain = winMain;
			this.width = width;
			this.height = height;

			this.set_visible_window(false);
			this.show();
		}

		public KeyEventBox(NeoWindow winMain, int width, int height , ref uint[] keysym) {
			this.all(winMain, width, height);
			this.keysym = keysym;

			this.button_press_event.connect ((event) => {
				if (event.button != 1){
					return false;
				}

				uint ks = this.keysym[NeoLayoutViewer.KeyEventBox.layer_permutation[winMain.layer] - 1];
				int modi = winMain.getActiveModifierMask({4,5}); //ctrl+alt mask
				if (ks < 1) return false;

#if _NO_WIN
				if (modi == 0 || true) {
					// Alt-Mask do not work :-(
					keysend(ks,modi);
				} else {
					//debug("Variante mit zweitem Modifier.");
					keysend2(ks,modi & Gdk.ModifierType.CONTROL_MASK, modi & Gdk.ModifierType.MOD1_MASK);
				}
#endif

				return false;
			});
		}

		public KeyEventBox.modifier(NeoWindow winMain, int width, int height , int modifier_index) {
			this.all(winMain, width, height);
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

		public KeyEventBox.modifier2(NeoWindow winMain, int width, int height , int modifier_index, string pressed_key_image ){
			this.all(winMain, width, height);
			this.modifier_index = modifier_index;

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

			// Image of pressed Button
			Gdk.Pixbuf image_buffer = winMain.open_image_str(@"$(winMain.config.get("asset_folder"))/neo2.0/$(pressed_key_image)");
			var w = image_buffer.width;
			var h = image_buffer.height;
			image_buffer = image_buffer.scale_simple(width, h*width/w,Gdk.InterpType.BILINEAR);

			this.image = new Gtk.Image();
			this.image.set_from_pixbuf(image_buffer);
			this.image.hide();

			add(this.image);

			winMain.modifier_key_images.add(  new Modkey(ref this.image, this.modifier_index) );

		}

		public KeyEventBox.freeArea(NeoWindow winMain, int width, int height) {
			this.all(winMain, width, height);
		}

		/*
		 * This method Gtk+ is calling on a widget to ask
		 * the widget how large it wishes to be. It's not guaranteed
		 * that Gtk+ will actually give this size to the widget.
		 */

		public override void get_preferred_width(out int minimum_width, out int natural_width){
			minimum_width = width;
			natural_width = width;
		}
		public override void get_preferred_height(out int minimum_height, out int natural_height){
			minimum_height = height;
			natural_height = height;
		}

	}
}

