/*
 Known Problems:
  - Tab, Shift+Tab, Shift+Space, Numblock not implemented
	- Some special characters, i.e ℂ, not implemented, because the unicode numbers
	   not defined in keysymdef.h (and left in the vapi file, too).
*/
using Gtk;
using Gdk;
using X;
//using Keysym;//keysymdef.h
using Posix;//system-call


namespace NeoLayoutViewer{

				private class ArrayBox {
						public uint[] val;
						public ArrayBox(uint[] val){
							this.val = val;
						}
				}

				public class KeyOverlay : VBox {

				public Gee.HashMap<int,KeyEventBox> keyBoxes;
				public Gee.HashMap<int,ArrayBox> keysyms;
				private NeoWindow winMain;

						public KeyOverlay(NeoWindow winMain) {
								//base(true,0);
								this.set_homogeneous(false);
								this.set_spacing(0);
								this.winMain = winMain;
								this.keysyms =  generateKeysyms();

								this.keyBoxes =  new Gee.HashMap<int, KeyEventBox>();
								generateKeyevents();
						}

		public Gee.HashMap<int, ArrayBox> generateKeysyms(){
								keysyms =  new Gee.HashMap<int, ArrayBox>();

								keysyms.set(8, new ArrayBox({}));
								keysyms.set(9, new ArrayBox({XK_Escape, 0, XK_Escape}));
								keysyms.set(10, new ArrayBox({XK_1, XK_degree, XK_onesuperior, XK_onesubscript, XK_ordfeminine, 0, XK_notsign}));
								keysyms.set(11, new ArrayBox({XK_2, XK_section, XK_twosuperior, XK_twosubscript, XK_masculine, 0, XK_logicalor}));
								keysyms.set(12, new ArrayBox({XK_3, 0, XK_threesuperior, XK_threesubscript, XK_numerosign, 0, XK_logicaland}));
								keysyms.set(13, new ArrayBox({XK_4, XK_guillemotright, 0, 0, XK_Prior, XK_Prior, 0}));
								keysyms.set(14, new ArrayBox({XK_5, XK_guillemotleft, 0, 0, XK_periodcentered, 0, 0}));
								keysyms.set(15, new ArrayBox({XK_6, XK_EuroSign, XK_cent, 0, XK_sterling, 0, 0}));
								keysyms.set(16, new ArrayBox({XK_7, XK_dollar, XK_yen, XK_Greek_kappa, XK_currency, 0, XK_rightarrow}));
								keysyms.set(17, new ArrayBox({XK_8, 0, 0, 0, 0, 0, 0}));
								keysyms.set(18, new ArrayBox({XK_9, 0, 0, 0, XK_slash, 0, XK_containsas}));
								keysyms.set(19, new ArrayBox({XK_0, 0, XK_zerosubscript, XK_asterisk, 0, XK_emptyset}));
								keysyms.set(20, new ArrayBox({XK_minus, 0, 0, 0, XK_minus, 0, XK_hyphen}));
								keysyms.set(21, new ArrayBox({XK_dead_grave, 0, XK_dead_diaeresis, XK_dead_abovereversedcomma}));
								keysyms.set(22, new ArrayBox({XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace, XK_BackSpace}));
								keysyms.set(23, new ArrayBox({XK_Tab, XK_ISO_Left_Tab, XK_Multi_key}));
								keysyms.set(24, new ArrayBox({XK_x, XK_X, 0, XK_Greek_xi, 0, 0, XK_Greek_XI}));
								keysyms.set(25, new ArrayBox({XK_v, XK_V, XK_underscore, 0, XK_BackSpace, XK_BackSpace, 0}));
								keysyms.set(26, new ArrayBox({XK_l, XK_L, XK_bracketleft, XK_Greek_lamda, XK_Up, XK_Up, XK_Greek_LAMDA}));
								keysyms.set(27, new ArrayBox({XK_c, XK_C, XK_bracketright, XK_Greek_chi, XK_Delete, XK_Delete, 0}));
								keysyms.set(28, new ArrayBox({XK_w, XK_W, XK_asciicircum, XK_Greek_omega, XK_Insert, XK_Insert, XK_Greek_OMEGA}));
								keysyms.set(29, new ArrayBox({XK_k, XK_K, XK_exclam, 0, XK_exclamdown, 0, XK_radical}));
								keysyms.set(30, new ArrayBox({XK_h, XK_H, XK_less, XK_Greek_psi, XK_7, 0, XK_Greek_PSI}));
								keysyms.set(31, new ArrayBox({XK_g, XK_G, XK_greater, XK_Greek_gamma, XK_8, 0, XK_Greek_GAMMA}));
								keysyms.set(32, new ArrayBox({XK_f, XK_F, XK_equal, XK_Greek_phi, XK_9, 0, XK_Greek_PHI}));
								keysyms.set(33, new ArrayBox({XK_q, XK_Q, XK_ampersand, 0, XK_plus, 0, 0}));
								keysyms.set(34, new ArrayBox({XK_ssharp, 0, 0, XK_Greek_finalsmallsigma, 0, 0, 0}));
								keysyms.set(35, new ArrayBox({XK_dead_acute, XK_dead_cedilla, XK_dead_stroke, XK_dead_abovecomma, XK_dead_doubleacute, 0, XK_dead_abovedot}));
								keysyms.set(36, new ArrayBox({XK_Return, 0, XK_Return}));
								keysyms.set(37, new ArrayBox({XK_Control_L, 0, XK_Control_L}));
								keysyms.set(38, new ArrayBox({XK_u, XK_U, XK_backslash, 0, XK_Home, XK_Home, 0}));
								keysyms.set(39, new ArrayBox({XK_i, XK_I, XK_slash, XK_Greek_iota, XK_Left, XK_Left, XK_integral}));
								keysyms.set(40, new ArrayBox({XK_a, XK_A, XK_braceleft, XK_Greek_alpha, XK_Down, XK_Down, 0}));
								keysyms.set(41, new ArrayBox({XK_e, XK_E, XK_braceright, XK_Greek_epsilon, XK_Right, XK_Right, 0}));
								keysyms.set(42, new ArrayBox({XK_o, XK_O, XK_asterisk, XK_Greek_omicron, XK_End, XK_End, XK_elementof}));
								keysyms.set(43, new ArrayBox({XK_s, XK_S, XK_question, XK_Greek_sigma, XK_questiondown, 0, XK_Greek_SIGMA}));
								keysyms.set(44, new ArrayBox({XK_n, XK_N, XK_parenleft, XK_Greek_nu, XK_4, 0, 0}));
								keysyms.set(45, new ArrayBox({XK_r, XK_R, XK_parenright, 0, XK_5, 0, 0}));
								keysyms.set(46, new ArrayBox({XK_t, XK_T, XK_minus, XK_Greek_tau, XK_6, 0, XK_partialderivative}));
								keysyms.set(47, new ArrayBox({XK_d, XK_D, XK_colon, XK_Greek_delta, XK_comma, 0, XK_Greek_DELTA}));
								keysyms.set(48, new ArrayBox({XK_y, XK_Y, XK_at, XK_Greek_upsilon, XK_period, 0, XK_nabla}));
								keysyms.set(49, new ArrayBox({XK_dead_circumflex, XK_dead_tilde, XK_dead_abovering, XK_dead_breve, XK_dead_caron, 0, XK_dead_macron}));
								keysyms.set(50, new ArrayBox({XK_Shift_L, 0, XK_Shift_L}));
								keysyms.set(51, new ArrayBox({XK_ISO_Level3_Shift, XK_ISO_Level3_Shift, XK_Caps_Lock, XK_Caps_Lock}));
								keysyms.set(52, new ArrayBox({XK_udiaeresis, XK_Udiaeresis, XK_numbersign, 0, XK_Escape, XK_Escape, 0}));
								keysyms.set(53, new ArrayBox({XK_odiaeresis, XK_Odiaeresis, XK_dollar, 0, XK_Tab, XK_Tab, 0}));
								keysyms.set(54, new ArrayBox({XK_adiaeresis, XK_Adiaeresis, XK_bar, XK_Greek_eta, XK_Next, XK_Next, 0}));
								keysyms.set(55, new ArrayBox({XK_p, XK_P, XK_asciitilde, XK_Greek_pi, XK_Return, XK_Return, XK_Greek_PI}));
								keysyms.set(56, new ArrayBox({XK_z, XK_Z, XK_grave, XK_Greek_zeta, 0, 0, 0}));
								keysyms.set(57, new ArrayBox({XK_b, XK_B, XK_plus, XK_Greek_beta, XK_colon, 0, 0}));
								keysyms.set(58, new ArrayBox({XK_m, XK_M, XK_percent, XK_Greek_mu, XK_1, 0, XK_ifonlyif}));
								keysyms.set(59, new ArrayBox({XK_comma, 0, XK_quotedbl, XK_Greek_rho, XK_2, 0, 0}));
								keysyms.set(60, new ArrayBox({XK_period, 0, XK_apostrophe, 0, XK_3, 0, XK_Greek_THETA}));
								keysyms.set(61, new ArrayBox({XK_j, XK_J, XK_semicolon, XK_Greek_theta, XK_semicolon, 0, XK_variation}));
								keysyms.set(62, new ArrayBox({XK_Shift_R, 0, XK_Shift_R}));
								keysyms.set(63, new ArrayBox({XK_KP_Multiply, XK_KP_Multiply, 0, XK_multiply, 0, 0, 0}));
								keysyms.set(64, new ArrayBox({XK_Alt_L, XK_Meta_L, XK_Meta_L}));
								keysyms.set(65, new ArrayBox({XK_space, XK_space, XK_space, XK_nobreakspace, XK_0, 0, 0}));
								keysyms.set(66, new ArrayBox({XK_ISO_Level3_Shift, XK_ISO_Level3_Shift, XK_Caps_Lock, XK_Caps_Lock}));
								keysyms.set(67, new ArrayBox({XK_F1, 0, 0}));
								keysyms.set(68, new ArrayBox({XK_F2, 0, 0}));
								keysyms.set(69, new ArrayBox({XK_F3, 0, 0}));
								keysyms.set(70, new ArrayBox({XK_F4, 0, 0}));
								keysyms.set(71, new ArrayBox({XK_F5, 0, 0}));
								keysyms.set(72, new ArrayBox({XK_F6, 0, 0}));
								keysyms.set(73, new ArrayBox({XK_F7, 0, 0}));
								keysyms.set(74, new ArrayBox({XK_F8, 0, 0}));
								keysyms.set(75, new ArrayBox({XK_F9, 0, 0}));
								keysyms.set(76, new ArrayBox({XK_F10, 0, 0}));
								keysyms.set(77, new ArrayBox({XK_Tab, XK_ISO_Left_Tab, XK_equal, XK_approxeq, XK_notequal, 0, XK_identical}));
								keysyms.set(78, new ArrayBox({XK_Scroll_Lock, 0, XK_Scroll_Lock}));
								keysyms.set(79, new ArrayBox({XK_KP_7, 0, 0, 0, XK_KP_Home, XK_KP_Home, 0}));
								keysyms.set(80, new ArrayBox({XK_KP_8, 0, XK_uparrow, XK_intersection, XK_KP_Up, XK_KP_Up, 0}));
								keysyms.set(81, new ArrayBox({XK_KP_9, XK_KP_9, 0, 0, XK_KP_Prior, XK_KP_Prior, 0}));
								keysyms.set(82, new ArrayBox({XK_KP_Subtract, XK_KP_Subtract, 0, 0, 0, 0, 0}));
								keysyms.set(83, new ArrayBox({XK_KP_4, 0, XK_leftarrow, XK_includedin, XK_KP_Left, XK_KP_Left, 0}));
								keysyms.set(84, new ArrayBox({XK_KP_5, XK_EuroSign, XK_brokenbar, 0, XK_KP_Begin, XK_KP_Begin, 0}));
								keysyms.set(85, new ArrayBox({XK_KP_6, XK_KP_6, XK_rightarrow, XK_includes, XK_KP_Right, XK_KP_Right, 0}));
								keysyms.set(86, new ArrayBox({XK_KP_Add, XK_KP_Add, XK_plusminus, 0, 0, 0, 0}));
								keysyms.set(87, new ArrayBox({XK_KP_1, 0, 0, XK_lessthanequal, XK_KP_End, XK_KP_End, 0}));
								keysyms.set(88, new ArrayBox({XK_KP_2, 0, XK_downarrow, XK_union, XK_KP_Down, XK_KP_Down, 0}));
								keysyms.set(89, new ArrayBox({XK_KP_3, 0, 0, XK_greaterthanequal, XK_KP_Next, XK_KP_Next, 0}));
								keysyms.set(90, new ArrayBox({XK_KP_0, 0, XK_percent, 0, XK_KP_Insert, XK_KP_Insert, 0}));
								keysyms.set(91, new ArrayBox({XK_comma, XK_KP_Decimal, XK_period, XK_apostrophe, XK_KP_Delete, XK_KP_Delete, XK_quotedbl}));
								keysyms.set(92, new ArrayBox({XK_ISO_Level3_Shift, 0, XK_ISO_Level3_Shift}));
								keysyms.set(93, new ArrayBox({XK_Zenkaku_Hankaku, 0, XK_Zenkaku_Hankaku}));
								keysyms.set(94, new ArrayBox({XK_ISO_Level5_Shift, 0, XK_ISO_Level5_Shift}));
								keysyms.set(95, new ArrayBox({XK_F11, 0, 0}));
								keysyms.set(96, new ArrayBox({XK_F12, 0, 0}));
								keysyms.set(97, new ArrayBox({}));
								keysyms.set(98, new ArrayBox({XK_Katakana, 0, XK_Katakana}));
								keysyms.set(99, new ArrayBox({XK_Hiragana, 0, XK_Hiragana}));
								keysyms.set(100, new ArrayBox({XK_Henkan_Mode, 0, XK_Henkan_Mode}));
								keysyms.set(101, new ArrayBox({XK_Hiragana_Katakana, 0, XK_Hiragana_Katakana}));
								keysyms.set(102, new ArrayBox({XK_Muhenkan, 0, XK_Muhenkan}));
								keysyms.set(103, new ArrayBox({}));
								keysyms.set(104, new ArrayBox({XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter, XK_KP_Enter}));
								keysyms.set(105, new ArrayBox({XK_Control_R, 0, XK_Control_R}));
								keysyms.set(106, new ArrayBox({XK_KP_Divide, XK_KP_Divide, XK_division, 0, 0, 0, 0}));
								keysyms.set(107, new ArrayBox({XK_Print, XK_Sys_Req, XK_Sys_Req}));
								keysyms.set(108, new ArrayBox({XK_ISO_Level5_Shift, 0, XK_ISO_Level5_Shift}));
								keysyms.set(109, new ArrayBox({XK_Linefeed, 0, XK_Linefeed}));
								keysyms.set(110, new ArrayBox({XK_Home, 0, XK_Home}));
								keysyms.set(111, new ArrayBox({XK_Up, 0, XK_Up}));
								keysyms.set(112, new ArrayBox({XK_Prior, 0, XK_Prior}));
								keysyms.set(113, new ArrayBox({XK_Left, 0, XK_Left}));
								keysyms.set(114, new ArrayBox({XK_Right, 0, XK_Right}));
								keysyms.set(115, new ArrayBox({XK_End, 0, XK_End}));
								keysyms.set(116, new ArrayBox({XK_Down, 0, XK_Down}));
								keysyms.set(117, new ArrayBox({XK_Next, 0, XK_Next}));
								keysyms.set(118, new ArrayBox({XK_Insert, 0, XK_Insert}));
								keysyms.set(119, new ArrayBox({XK_Delete, 0, XK_Delete}));
								keysyms.set(120, new ArrayBox({}));
								keysyms.set(121, new ArrayBox({0, 0, 0}));
								keysyms.set(122, new ArrayBox({0, 0, 0}));
								keysyms.set(123, new ArrayBox({0, 0, 0}));
								keysyms.set(124, new ArrayBox({0, 0, 0}));
								keysyms.set(125, new ArrayBox({XK_KP_Equal, 0, XK_KP_Equal}));
								keysyms.set(126, new ArrayBox({XK_plusminus, 0, XK_plusminus}));
								keysyms.set(127, new ArrayBox({XK_Pause, XK_Break, XK_Break}));
								keysyms.set(128, new ArrayBox({}));
								keysyms.set(129, new ArrayBox({XK_KP_Separator, 0, XK_KP_Separator}));
								keysyms.set(130, new ArrayBox({XK_Hangul, 0, XK_Hangul}));
								keysyms.set(131, new ArrayBox({XK_Hangul_Hanja, 0, XK_Hangul_Hanja}));
								keysyms.set(132, new ArrayBox({}));
								keysyms.set(133, new ArrayBox({XK_Super_L, 0, XK_Super_L}));
								keysyms.set(134, new ArrayBox({XK_Super_R, 0, XK_Super_R}));
								keysyms.set(135, new ArrayBox({XK_Menu, 0, XK_Menu}));
								keysyms.set(136, new ArrayBox({XK_Cancel, 0, XK_Cancel}));
								keysyms.set(137, new ArrayBox({XK_Redo, 0, XK_Redo}));
								keysyms.set(138, new ArrayBox({0, 0, 0}));
								keysyms.set(139, new ArrayBox({XK_Undo, 0, XK_Undo}));
								keysyms.set(140, new ArrayBox({0, 0, 0}));
								keysyms.set(141, new ArrayBox({0, 0, 0}));
								keysyms.set(142, new ArrayBox({0, 0, 0}));
								keysyms.set(143, new ArrayBox({0, 0, 0}));
								keysyms.set(144, new ArrayBox({XK_Find, 0, XK_Find}));
								keysyms.set(145, new ArrayBox({0, 0, 0}));
								keysyms.set(146, new ArrayBox({XK_Help, 0, XK_Help}));
								keysyms.set(147, new ArrayBox({0, 0, 0}));
								keysyms.set(148, new ArrayBox({0, 0, 0}));
								keysyms.set(149, new ArrayBox({}));
								keysyms.set(150, new ArrayBox({0, 0, 0}));
								keysyms.set(151, new ArrayBox({0, 0, 0}));
								keysyms.set(152, new ArrayBox({0, 0, 0}));
								keysyms.set(153, new ArrayBox({0, 0, 0}));
								keysyms.set(154, new ArrayBox({}));
								keysyms.set(155, new ArrayBox({0, 0, 0}));
								keysyms.set(156, new ArrayBox({0, 0, 0}));
								keysyms.set(157, new ArrayBox({0, 0, 0}));
								keysyms.set(158, new ArrayBox({0, 0, 0}));
								keysyms.set(159, new ArrayBox({0, 0, 0}));
								keysyms.set(160, new ArrayBox({0, 0, 0}));
								keysyms.set(161, new ArrayBox({}));
								keysyms.set(162, new ArrayBox({0, 0, 0}));
								keysyms.set(163, new ArrayBox({0, 0, 0}));
								keysyms.set(164, new ArrayBox({0, 0, 0}));
								keysyms.set(165, new ArrayBox({0, 0, 0}));
								keysyms.set(166, new ArrayBox({0, 0, 0}));
								keysyms.set(167, new ArrayBox({0, 0, 0}));
								keysyms.set(168, new ArrayBox({}));
								keysyms.set(169, new ArrayBox({0, 0, 0}));
								keysyms.set(170, new ArrayBox({0, 0, 0}));
								keysyms.set(171, new ArrayBox({0, 0, 0}));
								keysyms.set(172, new ArrayBox({0, 0, 0}));
								keysyms.set(173, new ArrayBox({0, 0, 0}));
								keysyms.set(174, new ArrayBox({0, 0, 0}));
								keysyms.set(175, new ArrayBox({0, 0, 0}));
								keysyms.set(176, new ArrayBox({0, 0, 0}));
								keysyms.set(177, new ArrayBox({0, 0, 0}));
								keysyms.set(178, new ArrayBox({}));
								keysyms.set(179, new ArrayBox({0, 0, 0}));
								keysyms.set(180, new ArrayBox({0, 0, 0}));
								keysyms.set(181, new ArrayBox({0, 0, 0}));
								keysyms.set(182, new ArrayBox({0, 0, 0}));
								keysyms.set(183, new ArrayBox({}));
								keysyms.set(184, new ArrayBox({}));
								keysyms.set(185, new ArrayBox({0, 0, 0}));
								keysyms.set(186, new ArrayBox({0, 0, 0}));
								keysyms.set(187, new ArrayBox({XK_parenleft, 0, XK_parenleft}));
								keysyms.set(188, new ArrayBox({XK_parenright, 0, XK_parenright}));
								keysyms.set(189, new ArrayBox({0, 0, 0}));
								keysyms.set(190, new ArrayBox({XK_Redo, 0, XK_Redo}));
								keysyms.set(191, new ArrayBox({}));
								keysyms.set(192, new ArrayBox({}));
								keysyms.set(193, new ArrayBox({}));
								keysyms.set(194, new ArrayBox({}));
								keysyms.set(195, new ArrayBox({}));
								keysyms.set(196, new ArrayBox({}));
								keysyms.set(197, new ArrayBox({}));
								keysyms.set(198, new ArrayBox({}));
								keysyms.set(199, new ArrayBox({}));
								keysyms.set(200, new ArrayBox({}));
								keysyms.set(201, new ArrayBox({}));
								keysyms.set(202, new ArrayBox({}));
								keysyms.set(203, new ArrayBox({XK_Mode_switch, 0, XK_Mode_switch}));
								keysyms.set(204, new ArrayBox({0, XK_Alt_L, XK_Alt_L}));
								keysyms.set(205, new ArrayBox({0, XK_Meta_L, XK_Meta_L}));
								keysyms.set(206, new ArrayBox({0, XK_Super_L, XK_Super_L}));
								keysyms.set(207, new ArrayBox({0, XK_Hyper_L, XK_Hyper_L}));
								keysyms.set(208, new ArrayBox({0, 0, 0}));
								keysyms.set(209, new ArrayBox({0, 0, 0}));
								keysyms.set(210, new ArrayBox({0, 0, 0}));
								keysyms.set(211, new ArrayBox({0, 0, 0}));
								keysyms.set(212, new ArrayBox({}));
								keysyms.set(213, new ArrayBox({0, 0, 0}));
								keysyms.set(214, new ArrayBox({0, 0, 0}));
								keysyms.set(215, new ArrayBox({0, 0, 0}));
								keysyms.set(216, new ArrayBox({0, 0, 0}));
								keysyms.set(217, new ArrayBox({}));
								keysyms.set(218, new ArrayBox({XK_Print, 0, XK_Print}));
								keysyms.set(219, new ArrayBox({}));
								keysyms.set(220, new ArrayBox({0, 0, 0}));
								keysyms.set(221, new ArrayBox({}));
								keysyms.set(222, new ArrayBox({}));
								keysyms.set(223, new ArrayBox({0, 0, 0}));
								keysyms.set(224, new ArrayBox({}));
								keysyms.set(225, new ArrayBox({0, 0, 0}));
								keysyms.set(226, new ArrayBox({}));
								keysyms.set(227, new ArrayBox({0, 0, 0}));
								keysyms.set(228, new ArrayBox({}));
								keysyms.set(229, new ArrayBox({0, 0, 0}));
								keysyms.set(230, new ArrayBox({}));
								keysyms.set(231, new ArrayBox({XK_Cancel, 0, XK_Cancel}));
								keysyms.set(232, new ArrayBox({0, 0, 0}));
								keysyms.set(233, new ArrayBox({0, 0, 0}));
								keysyms.set(234, new ArrayBox({0, 0, 0}));
								keysyms.set(235, new ArrayBox({0, 0, 0}));
								keysyms.set(236, new ArrayBox({0, 0, 0}));
								keysyms.set(237, new ArrayBox({0, 0, 0}));
								keysyms.set(238, new ArrayBox({0, 0, 0}));
								keysyms.set(239, new ArrayBox({0, 0, 0}));
								keysyms.set(240, new ArrayBox({0, 0, 0}));
								keysyms.set(241, new ArrayBox({0, 0, 0}));
								keysyms.set(242, new ArrayBox({0, 0, 0}));
								keysyms.set(243, new ArrayBox({0, 0, 0}));
								keysyms.set(244, new ArrayBox({0, 0, 0}));
								keysyms.set(245, new ArrayBox({0, 0, 0}));
								keysyms.set(246, new ArrayBox({0, 0, 0}));
								keysyms.set(247, new ArrayBox({}));
								keysyms.set(248, new ArrayBox({}));
								keysyms.set(249, new ArrayBox({}));
								keysyms.set(250, new ArrayBox({}));
								keysyms.set(251, new ArrayBox({}));
								keysyms.set(252, new ArrayBox({}));
								keysyms.set(253, new ArrayBox({}));
								keysyms.set(254, new ArrayBox({}));
								keysyms.set(255, new ArrayBox({}));


			return keysyms;
		}

		public void generateKeyevents() {
		  HBox[] hboxes = { 
		    new HBox(false, 0),
		    new HBox(false, 0),
		    new HBox(false, 0),
		    new HBox(false, 0),
		    new HBox(false, 0)
		    };
		  this.pack_start( hboxes[0], false, true, 0 ); 
		  this.pack_start( hboxes[1], false, true, 0 ); 
		  this.pack_start( hboxes[2], false, true, 0 ); 
		  this.pack_start( hboxes[3], false, true, 0 ); 
		  this.pack_start( hboxes[4], false, true, 0 ); 

			double winWidthUnscaled = 1000.0;
			double winHeightUnscaled = 220.0;
			if( winMain.config.get("display_numblock")=="0" )
				winWidthUnscaled	-=	winMain.numblock_width;
			int width, height;
			winMain.get_size2(out width, out height);

			double scaleX = width/winWidthUnscaled;
			double scaleY = height/winHeightUnscaled;

			double posXUnscaled = 0.0;
			double posYUnscaled = 0.0;
			int posX = 0;
			int posY = 0;

			GLib.stdout.printf(@"$winWidthUnscaled , $width , $scaleX\n");

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

				if( winMain.config.get("display_numblock")!="0" ){
					scaledBox(78.0-1.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 22 , false, winMain, hboxes[0], 0);
								//free space
								scaledBox(174.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[0], 3);
								//num key, divide, times, and minus
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 77 , false, winMain, hboxes[0], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 106 , false, winMain, hboxes[0], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 63 , false, winMain, hboxes[0], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 82 , true, winMain, hboxes[0], 0);
				}else{
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

if( winMain.config.get("display_numblock")!="0" ){
								//Halve of Return/Enter
								scaledBox(62.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 36 , false, winMain, hboxes[1], 0);
								//free space
								scaledBox(174.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[1], 3);
								//7, 8, 9, and halve of plus
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 79 , false, winMain, hboxes[1], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 80 , false, winMain, hboxes[1], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 81 , false, winMain, hboxes[1], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 86 , true, winMain, hboxes[1], 0);
				}else{
								//Halve of Return/Enter
								scaledBox(62.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 36 , true, winMain, hboxes[1], 0);
				}

		//Reset right shift. 
		posXUnscaled = 0.0;
		posX = 0;

//++ End second row ++
//++ third row ++
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

if( winMain.config.get("display_numblock")!="0" ){
								//Second halve of Enter/Return
								scaledBox(49.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 36 , false, winMain, hboxes[2], 0);
								//free space
								scaledBox(174.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[2], 3);
								//4, 5, 6, and halve of plus
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 83 , false, winMain, hboxes[2], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 84 , false, winMain, hboxes[2], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 85 , false, winMain, hboxes[2], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 86 , true, winMain, hboxes[2], 0);
				}else{
								//Second halve of Enter/Return
								scaledBox(49.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 36 , true, winMain, hboxes[2], 0);
				}

		//Reset right shift. 
		posXUnscaled = 0.0;
		posX = 0;
//++ End third row ++
//++ fourth row ++
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
if( winMain.config.get("display_numblock")!="0" ){
								//right shift
								scaledBox(114.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 1 /*62*/ , false, winMain, hboxes[3], 1);
								//free space
								scaledBox(174.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[3], 3);
								//1, 2, 3, and halve of enter 
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 87 , false, winMain, hboxes[3], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 88 , false, winMain, hboxes[3], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 89 , false, winMain, hboxes[3], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 104 , true, winMain, hboxes[3], 0);
				}else{
								//right shift
								scaledBox(114.0-1,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 1 /*62*/ , true, winMain, hboxes[3], 1);
				}
		//Reset right shift. 
		posXUnscaled = 0.0;
		posX = 0;
//++ End fourth row ++
//++ fivth row ++
//left ctrl, 37
scaledBox(61.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 4/*37*/ , false, winMain, hboxes[4], 2);
//free space
scaledBox(48.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[4], 3);
//alt
scaledBox(61.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 5/*64*/ , false, winMain, hboxes[4], 2);
//space
scaledBox(316.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 65 , false, winMain, hboxes[4], 0);
//mod4
scaledBox(61.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 3/*94*/ , false, winMain, hboxes[4], 1);
//free space
scaledBox(40.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[4], 3);

if( winMain.config.get("display_numblock")!="0" ){
								// right ctrl
								scaledBox(61.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 4/*105*/ , false, winMain, hboxes[4], 2);
								//free space
								scaledBox(174.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , -1 , false, winMain, hboxes[4], 3);
								//0, comma, and halve of enter 
								scaledBox(88.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 90 , false, winMain, hboxes[4], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 91 , false, winMain, hboxes[4], 0);
								scaledBox(44.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 104 , false, winMain, hboxes[4], 0);
				}else{
								// right ctrl
								scaledBox(61.0,44.0,ref posXUnscaled, ref posYUnscaled, ref posX, ref posY, scaleX, scaleY , 4/*105*/ , false, winMain, hboxes[4], 2);
				}

//++ End fivth row ++
		}


 /*
 Gibt skalierte EventBox zurück. Damit sich die Rundungfehler durch int-Cast nicht aufzusummieren,
 basieren die Werte auf der bis zu diesem Zeitpunkt zu erwartenden Gesamtbreite/höhe.
*/
         private KeyEventBox scaledBox(double widthUnscaled, double heightUnscaled,
				ref double posXUnscaled, ref double posYUnscaled,
				ref int posX, ref int posY,
				double scaleX, double scaleY,
				int keycode, bool vertical, NeoWindow winMain, Box box, int boxtype ){
	   
			int width = (int) GLib.Math.floor( (posXUnscaled + widthUnscaled)*scaleX - posX ) ;
			int height = (int) GLib.Math.floor( (posYUnscaled + heightUnscaled)*scaleY - posY);

	    if( vertical){ 
	      posYUnscaled += heightUnscaled;
	      posY += height;
	    }else{
	      posXUnscaled += widthUnscaled;
	      posX += width;
	    }

			KeyEventBox keybox;
			if( boxtype == 0 ){
			// Normale Taste
				ArrayBox ks = this.keysyms.get(keycode);
				keybox = new KeyEventBox(winMain, width, height, ref ks.val );
				this.keyBoxes.set(keycode, keybox);
				box.pack_start(keybox, false, true, 0 );
			}else if( boxtype == 1){
			// Modifier, die andere Buchstabenebenen aktivieren. Zusätzlich Ebenen-Bild einblenden.
				keybox = new KeyEventBox.modifier(winMain, width, height, keycode /*=modifier array index*/ );
				this.keyBoxes.set(keycode, keybox);
				box.pack_start(keybox, false, true, 0 );
			}else if( boxtype == 2){
			//Andere Modifier (CTRL, Alt,... )
				keybox = new KeyEventBox.modifier2(winMain, width, height, keycode /*modifier array index */ );
				this.keyBoxes.set(keycode, keybox);
				box.pack_start(keybox, false, true, 0 );
			}else{
			// Fläche ohne Funktion
				keybox = new KeyEventBox.freeArea(winMain, width, height );
				this.keyBoxes.set(keycode, keybox);
				box.pack_start(keybox, false, true, 0 );
			}


			return keybox;
	 }


} //End Class KeyOverlay



public class KeyEventBox : EventBox{
	//private double widthPercent;
	//private double heightPercent;
	//static bool flip = true;

	private uint[] keysym;// or
	private int modifier_index;

	private NeoWindow winMain;
	private int width;
	private int height;
	private string cmd;

  /*
		Die Reihenfolge der Zeichen in keysyms passt nicht
		zur Nummerierung der Ebenen in winMain. Mit diesem Array
		wird der Wert permutiert.
	*/
	private static const short[] layer_permutation = {0,1,2,3,5,4,7};

	private KeyEventBox.all(NeoWindow winMain, int width, int height){
		this.winMain = winMain;
		this.width = width;
		this.height = height;

		/*
		if( flip ){
			flip = false;
	    this.set_visible_window(false);
		}else{
			flip = true;
		}
		*/
	  this.set_visible_window(false);
	}

	public KeyEventBox(NeoWindow winMain, int width, int height , ref uint[] keysym){
		//base();
		this.all(winMain, width, height);
		this.keysym = keysym;

		GLib.stdout.printf("Ww: %i, Wh: %i\n", width, height);

		this.button_press_event.connect ((event) => {
			 uint ks = this.keysym[this.layer_permutation[winMain.ebene]-1];
			 int modi = winMain.active_modifier[4]*winMain.MODIFIER_MASK[4]
								+ winMain.active_modifier[5]*winMain.MODIFIER_MASK[5];
		   if( ks < 1 ) return false;

			 keysend(ks,modi);
		   return false;
		});
	}

	public KeyEventBox.modifier(NeoWindow winMain, int width, int height , int modifier_index ){
		this.all(winMain, width, height);
		this.modifier_index = modifier_index;

		this.button_press_event.connect ((event) => {
			if( winMain.active_modifier[this.modifier_index] == 0){
				winMain.active_modifier[this.modifier_index] = 1;
				winMain.status.set_label(@"Activate Modifier $(this.modifier_index)");
			}else{
				winMain.active_modifier[this.modifier_index] = 0;
				winMain.status.set_label(@"Deactivate Modifier $(this.modifier_index)");
			}
				winMain.redraw();

			 return false;
		});
	}

	public KeyEventBox.modifier2(NeoWindow winMain, int width, int height , int modifier_index ){
		this.all(winMain, width, height);
		this.modifier_index = modifier_index;

		this.button_press_event.connect ((event) => {
			if( winMain.active_modifier[this.modifier_index] == 0){
				winMain.active_modifier[this.modifier_index] = 1;
				//deactivate modifier, which select other charakters
				//winMain.active_modifier[0] = 0;//egal
				winMain.active_modifier[1] = 0;
				winMain.active_modifier[2] = 0;
				winMain.active_modifier[3] = 0;
				winMain.status.set_label(@"Activate Modifier $(this.modifier_index)");
			}else{
				winMain.active_modifier[this.modifier_index] = 0;
				winMain.status.set_label(@"Deactivate Modifier $(this.modifier_index)");
			}
				winMain.redraw();
			 return false;
		});
	}

	public KeyEventBox.freeArea(NeoWindow winMain, int width, int height ){
		this.all(winMain, width, height);
	}
    /*
     * This method Gtk+ is calling on a widget to ask
     * the widget how large it wishes to be. It's not guaranteed
     * that Gtk+ will actually give this size to the widget.
     */
    public override void size_request (out Gtk.Requisition requisition) {
        //int width, height;
        // In this case, we say that we want to be as big as the
        // text is, plus a little border around it.
        //this.layout.get_size (out width, out height);
        requisition.width = width ;// / Pango.SCALE;
        requisition.height = height; // /  Pango.SCALE;

	GLib.stdout.printf("W: %i, H: %i, Sc: %f\n",width, height, Pango.SCALE);
    }



  }
}

