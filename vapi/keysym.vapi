/***********************************************************
Copyright 1987, 1994, 1998  The Open Group

Permission to use, copy, modify, distribute, and sell this software and its
documentation for any purpose is hereby granted without fee, provided that
the above copyright notice appear in all copies and that both that
copyright notice and this permission notice appear in supporting
documentation.

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE OPEN GROUP BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of The Open Group shall
not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization
from The Open Group.


Copyright 1987 by Digital Equipment Corporation, Maynard, Massachusetts

                        All Rights Reserved

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose and without fee is hereby granted,
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in
supporting documentation, and that the name of Digital not be
used in advertising or publicity pertaining to distribution of the
software without specific, written prior permission.

DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
SOFTWARE.

******************************************************************/

/*
 * The "X11 Window System Protocol" standard defines in Appendix A the
 * keysym codes. These 29-bit integer values identify characters or
 * functions associated with each key (e.g., via the visible
 * engraving) of a keyboard layout. This file assigns mnemonic macro
 * names for these keysyms.
 *
 * This file is also compiled (by src/util/makekeys.c in libX11) into
 * hash tables that can be accessed with X11 library functions such as
 * XStringToKeysym() and XKeysymToString().
 *
 * Where a keysym corresponds one-to-one to an ISO 10646 / Unicode
 * character, this is noted in a comment that provides both the U+xxxx
 * Unicode position, as well as the official Unicode name of the
 * character.
 *
 * Where the correspondence is either not one-to-one or semantically
 * unclear, the Unicode position and name are enclosed in
 * parentheses. Such legacy keysyms should be considered deprecated
 * and are not recommended for use in future keyboard mappings.
 *
 * For any future extension of the keysyms with characters already
 * found in ISO 10646 / Unicode, the following algorithm shall be
 * used. The new keysym code position will simply be the character's
 * Unicode number plus;
 *;
 * characters in the range U+0100 to U+10FFFF.
 * 
 * While most newer Unicode-based X11 clients do already accept
 * Unicode-mapped keysyms in the range;
 * will remain necessary for clients -- in the interest of
 * compatibility with existing servers -- to also understand the
 * existing legacy keysym values in the range;
 *
 * Where several mnemonic names are defined for the same keysym in this
 * file, all but the first one listed should be considered deprecated.
 *
 * Mnemonic names for keysyms are defined in this file with lines
 * that match one of these Perl regular expressions:
 *
		public const uint XK_([a-zA-Z_0-9]+)\s+; \s*\/\* U+([0-9A-F]{4,6}) (.*) \*\/\s*$/
		public const uint XK_([a-zA-Z_0-9]+)\s+; \s*\/\*\(U+([0-9A-F]{4,6}) (.*)\)\*\/\s*$/
		public const uint XK_([a-zA-Z_0-9]+)\s+; \s*(\/\*\s*(.*)\s*\*\/)?\s*$/
 *
 * Before adding new keysyms, please do consider the following: In
 * addition to the keysym names defined in this file, the
 * XStringToKeysym() and XKeysymToString() functions will also handle
 * any keysym string of the form "U0020" to "U007E" and "U00A0" to
 * "U10FFFF" for all possible Unicode characters. In other words,
 * every possible Unicode character has already a keysym string
 * defined algorithmically, even if it is not listed here. Therefore,
 * defining an additional keysym macro is only necessary where a
 * non-hexadecimal mnemonic name is needed, or where the new keysym
 * does not represent any existing Unicode character.
 *
 * When adding new keysyms to this file, do not forget to also update the
 * following:
 *
 *   - the mappings in src/KeyBind.c in the repo
 *     git://anongit.freedesktop.org/xorg/lib/libX11
 *
 *   - the protocol specification in specs/XProtocol/X11.keysyms
 *     in the repo git://anongit.freedesktop.org/xorg/doc/xorg-docs
 *
 */

[CCode (lower_case_cprefix ="", cheader_filename="X11/keysym.h")]
namespace X
	{
	/* ***********************************************************************************
	 * FILE: keysym.h
	 */
		/* default keysyms */
		public const uint XK_MISCELLANY;
		public const uint XK_XKB_KEYS;
		public const uint XK_LATIN1;
		public const uint XK_LATIN2;
		public const uint XK_LATIN3;
		public const uint XK_LATIN4;
		public const uint XK_LATIN8;
		public const uint XK_LATIN9;
		public const uint XK_CAUCASUS;
		public const uint XK_GREEK;
		public const uint XK_KATAKANA;
		public const uint XK_ARABIC;
		public const uint XK_CYRILLIC;
		public const uint XK_HEBREW;
		public const uint XK_THAI;
		public const uint XK_KOREAN;
		public const uint XK_ARMENIAN;
		public const uint XK_GEORGIAN;
		public const uint XK_VIETNAMESE;
		public const uint XK_CURRENCY;
		public const uint XK_MATHEMATICAL;
		public const uint XK_BRAILLE;

	}

[CCode (lower_case_cprefix ="", cheader_filename="X11/keysymdef.h")]
namespace X
	{
	/* ***********************************************************************************
	 * FILE: keysymdef.h
	 */

		public const uint XK_VoidSymbol; /* Void symbol */

/*
 * TTY function keys, cleverly chosen to map to ASCII, for convenience of
 * programming, but could have been arbitrary (at the cost of lookup
 * tables in client code).
 */

		public const uint XK_BackSpace; /* Back space, back char */
		public const uint XK_Tab;
		public const uint XK_Linefeed; /* Linefeed, LF */
		public const uint XK_Clear;
		public const uint XK_Return; /* Return, enter */
		public const uint XK_Pause; /* Pause, hold */
		//already defined in x11.vapi
		//public const uint XK_Scroll_Lock;
		public const uint XK_Sys_Req;
		public const uint XK_Escape;
		public const uint XK_Delete; /* Delete, rubout */



/* International & multi-key character composition */

		public const uint XK_Multi_key; /* Multi-key character compose */
		public const uint XK_Codeinput;
		public const uint XK_SingleCandidate;
		public const uint XK_MultipleCandidate;
		public const uint XK_PreviousCandidate;

/* Japanese keyboard support */

		public const uint XK_Kanji; /* Kanji, Kanji convert */
		public const uint XK_Muhenkan; /* Cancel Conversion */
		public const uint XK_Henkan_Mode; /* Start/Stop Conversion */
		public const uint XK_Henkan; /* Alias for Henkan_Mode */
		public const uint XK_Romaji; /* to Romaji */
		public const uint XK_Hiragana; /* to Hiragana */
		public const uint XK_Katakana; /* to Katakana */
		public const uint XK_Hiragana_Katakana; /* Hiragana/Katakana toggle */
		public const uint XK_Zenkaku; /* to Zenkaku */
		public const uint XK_Hankaku; /* to Hankaku */
		public const uint XK_Zenkaku_Hankaku; /* Zenkaku/Hankaku toggle */
		public const uint XK_Touroku; /* Add to Dictionary */
		public const uint XK_Massyo; /* Delete from Dictionary */
		public const uint XK_Kana_Lock; /* Kana Lock */
		public const uint XK_Kana_Shift; /* Kana Shift */
		public const uint XK_Eisu_Shift; /* Alphanumeric Shift */
		public const uint XK_Eisu_toggle; /* Alphanumeric toggle */
		public const uint XK_Kanji_Bangou; /* Codeinput */
		public const uint XK_Zen_Koho; /* Multiple/All Candidate(s) */
		public const uint XK_Mae_Koho; /* Previous Candidate */

/*; /

/* Cursor control & motion */

		public const uint XK_Home;
		public const uint XK_Left; /* Move left, left arrow */
		public const uint XK_Up; /* Move up, up arrow */
		public const uint XK_Right; /* Move right, right arrow */
		public const uint XK_Down; /* Move down, down arrow */
		public const uint XK_Prior; /* Prior, previous */
		public const uint XK_Page_Up;
		public const uint XK_Next; /* Next */
		public const uint XK_Page_Down;
		public const uint XK_End; /* EOL */
		public const uint XK_Begin; /* BOL */


/* Misc functions */

		public const uint XK_Select; /* Select, mark */
		public const uint XK_Print;
		public const uint XK_Execute; /* Execute, run, do */
		public const uint XK_Insert; /* Insert, insert here */
		public const uint XK_Undo;
		public const uint XK_Redo; /* Redo, again */
		public const uint XK_Menu;
		public const uint XK_Find; /* Find, search */
		public const uint XK_Cancel; /* Cancel, stop, abort, exit */
		public const uint XK_Help; /* Help */
		public const uint XK_Break;
		public const uint XK_Mode_switch; /* Character set switch */
		public const uint XK_script_switch; /* Alias for mode_switch */
		//already defined in x11.vapi
		//public const uint XK_Num_Lock;

/* Keypad functions, keypad numbers cleverly chosen to map to ASCII */

		public const uint XK_KP_Space; /* Space */
		public const uint XK_KP_Tab;
		public const uint XK_KP_Enter; /* Enter */
		public const uint XK_KP_F1; /* PF1, KP_A, ... */
		public const uint XK_KP_F2;
		public const uint XK_KP_F3;
		public const uint XK_KP_F4;
		public const uint XK_KP_Home;
		public const uint XK_KP_Left;
		public const uint XK_KP_Up;
		public const uint XK_KP_Right;
		public const uint XK_KP_Down;
		public const uint XK_KP_Prior;
		public const uint XK_KP_Page_Up;
		public const uint XK_KP_Next;
		public const uint XK_KP_Page_Down;
		public const uint XK_KP_End;
		public const uint XK_KP_Begin;
		public const uint XK_KP_Insert;
		public const uint XK_KP_Delete;
		public const uint XK_KP_Equal; /* Equals */
		public const uint XK_KP_Multiply;
		public const uint XK_KP_Add;
		public const uint XK_KP_Separator; /* Separator, often comma */
		public const uint XK_KP_Subtract;
		public const uint XK_KP_Decimal;
		public const uint XK_KP_Divide;

		public const uint XK_KP_0;
		public const uint XK_KP_1;
		public const uint XK_KP_2;
		public const uint XK_KP_3;
		public const uint XK_KP_4;
		public const uint XK_KP_5;
		public const uint XK_KP_6;
		public const uint XK_KP_7;
		public const uint XK_KP_8;
		public const uint XK_KP_9;



/*
 * Auxiliary functions; note the duplicate definitions for left and right
 * function keys;  Sun keyboards and a few other manufacturers have such
 * function key groups on the left and/or right sides of the keyboard.
 * We've not found a keyboard with more than 35 function keys total.
 */

		public const uint XK_F1;
		public const uint XK_F2;
		public const uint XK_F3;
		public const uint XK_F4;
		public const uint XK_F5;
		public const uint XK_F6;
		public const uint XK_F7;
		public const uint XK_F8;
		public const uint XK_F9;
		public const uint XK_F10;
		public const uint XK_F11;
		public const uint XK_L1;
		public const uint XK_F12;
		public const uint XK_L2;
		public const uint XK_F13;
		public const uint XK_L3;
		public const uint XK_F14;
		public const uint XK_L4;
		public const uint XK_F15;
		public const uint XK_L5;
		public const uint XK_F16;
		public const uint XK_L6;
		public const uint XK_F17;
		public const uint XK_L7;
		public const uint XK_F18;
		public const uint XK_L8;
		public const uint XK_F19;
		public const uint XK_L9;
		public const uint XK_F20;
		public const uint XK_L10;
		public const uint XK_F21;
		public const uint XK_R1;
		public const uint XK_F22;
		public const uint XK_R2;
		public const uint XK_F23;
		public const uint XK_R3;
		public const uint XK_F24;
		public const uint XK_R4;
		public const uint XK_F25;
		public const uint XK_R5;
		public const uint XK_F26;
		public const uint XK_R6;
		public const uint XK_F27;
		public const uint XK_R7;
		public const uint XK_F28;
		public const uint XK_R8;
		public const uint XK_F29;
		public const uint XK_R9;
		public const uint XK_F30;
		public const uint XK_R10;
		public const uint XK_F31;
		public const uint XK_R11;
		public const uint XK_F32;
		public const uint XK_R12;
		public const uint XK_F33;
		public const uint XK_R13;
		public const uint XK_F34;
		public const uint XK_R14;
		public const uint XK_F35;
		public const uint XK_R15;

/* Modifiers */

		public const uint XK_Shift_L; /* Left shift */
		public const uint XK_Shift_R; /* Right shift */
		public const uint XK_Control_L; /* Left control */
		public const uint XK_Control_R; /* Right control */
		public const uint XK_Caps_Lock; /* Caps lock */
		public const uint XK_Shift_Lock; /* Shift lock */

		public const uint XK_Meta_L; /* Left meta */
		public const uint XK_Meta_R; /* Right meta */
		public const uint XK_Alt_L; /* Left alt */
		public const uint XK_Alt_R; /* Right alt */
		//already defined in x11.vapi
//		public const uint XK_Super_L; /* Left super */
//		public const uint XK_Super_R; /* Right super */
		public const uint XK_Hyper_L; /* Left hyper */
		public const uint XK_Hyper_R; /* Right hyper */

/*
 * Keyboard (XKB) Extension function and modifier keys
 * (from Appendix C of "The X Keyboard Extension: Protocol Specification")
 * Byte 3 =;
 */

		public const uint XK_ISO_Lock;
		public const uint XK_ISO_Level2_Latch;
		public const uint XK_ISO_Level3_Shift;
		public const uint XK_ISO_Level3_Latch;
		public const uint XK_ISO_Level3_Lock;
		public const uint XK_ISO_Level5_Shift;
		public const uint XK_ISO_Level5_Latch;
		public const uint XK_ISO_Level5_Lock;
		public const uint XK_ISO_Group_Shift; /* Alias for mode_switch */
		public const uint XK_ISO_Group_Latch;
		public const uint XK_ISO_Group_Lock;
		public const uint XK_ISO_Next_Group;
		public const uint XK_ISO_Next_Group_Lock;
		public const uint XK_ISO_Prev_Group;
		public const uint XK_ISO_Prev_Group_Lock;
		public const uint XK_ISO_First_Group;
		public const uint XK_ISO_First_Group_Lock;
		public const uint XK_ISO_Last_Group;
		public const uint XK_ISO_Last_Group_Lock;

		public const uint XK_ISO_Left_Tab;
		public const uint XK_ISO_Move_Line_Up;
		public const uint XK_ISO_Move_Line_Down;
		public const uint XK_ISO_Partial_Line_Up;
		public const uint XK_ISO_Partial_Line_Down;
		public const uint XK_ISO_Partial_Space_Left;
		public const uint XK_ISO_Partial_Space_Right;
		public const uint XK_ISO_Set_Margin_Left;
		public const uint XK_ISO_Set_Margin_Right;
		public const uint XK_ISO_Release_Margin_Left;
		public const uint XK_ISO_Release_Margin_Right;
		public const uint XK_ISO_Release_Both_Margins;
		public const uint XK_ISO_Fast_Cursor_Left;
		public const uint XK_ISO_Fast_Cursor_Right;
		public const uint XK_ISO_Fast_Cursor_Up;
		public const uint XK_ISO_Fast_Cursor_Down;
		public const uint XK_ISO_Continuous_Underline;
		public const uint XK_ISO_Discontinuous_Underline;
		public const uint XK_ISO_Emphasize;
		public const uint XK_ISO_Center_Object;
		public const uint XK_ISO_Enter;

		public const uint XK_dead_grave;
		public const uint XK_dead_acute;
		public const uint XK_dead_circumflex;
		public const uint XK_dead_tilde;
		public const uint XK_dead_perispomeni; /* alias for dead_tilde */
		public const uint XK_dead_macron;
		public const uint XK_dead_breve;
		public const uint XK_dead_abovedot;
		public const uint XK_dead_diaeresis;
		public const uint XK_dead_abovering;
		public const uint XK_dead_doubleacute;
		public const uint XK_dead_caron;
		public const uint XK_dead_cedilla;
		public const uint XK_dead_ogonek;
		public const uint XK_dead_iota;
		public const uint XK_dead_voiced_sound;
		public const uint XK_dead_semivoiced_sound;
		public const uint XK_dead_belowdot;
		public const uint XK_dead_hook;
		public const uint XK_dead_horn;
		public const uint XK_dead_stroke;
		public const uint XK_dead_abovecomma;
		public const uint XK_dead_psili; /* alias for dead_abovecomma */
		public const uint XK_dead_abovereversedcomma;
		public const uint XK_dead_dasia; /* alias for dead_abovereversedcomma */
		public const uint XK_dead_doublegrave;
		public const uint XK_dead_belowring;
		public const uint XK_dead_belowmacron;
		public const uint XK_dead_belowcircumflex;
		public const uint XK_dead_belowtilde;
		public const uint XK_dead_belowbreve;
		public const uint XK_dead_belowdiaeresis;
		public const uint XK_dead_invertedbreve;
		public const uint XK_dead_belowcomma;
		public const uint XK_dead_currency;

/* dead vowels for universal syllable entry */
		public const uint XK_dead_a;
		public const uint XK_dead_A;
		public const uint XK_dead_e;
		public const uint XK_dead_E;
		public const uint XK_dead_i;
		public const uint XK_dead_I;
		public const uint XK_dead_o;
		public const uint XK_dead_O;
		public const uint XK_dead_u;
		public const uint XK_dead_U;
		public const uint XK_dead_small_schwa;
		public const uint XK_dead_capital_schwa;

		public const uint XK_First_Virtual_Screen;
		public const uint XK_Prev_Virtual_Screen;
		public const uint XK_Next_Virtual_Screen;
		public const uint XK_Last_Virtual_Screen;
		public const uint XK_Terminate_Server;

		public const uint XK_AccessX_Enable;
		public const uint XK_AccessX_Feedback_Enable;
		public const uint XK_RepeatKeys_Enable;
		public const uint XK_SlowKeys_Enable;
		public const uint XK_BounceKeys_Enable;
		public const uint XK_StickyKeys_Enable;
		public const uint XK_MouseKeys_Enable;
		public const uint XK_MouseKeys_Accel_Enable;
		public const uint XK_Overlay1_Enable;
		public const uint XK_Overlay2_Enable;
		public const uint XK_AudibleBell_Enable;

		public const uint XK_Pointer_Left;
		public const uint XK_Pointer_Right;
		public const uint XK_Pointer_Up;
		public const uint XK_Pointer_Down;
		public const uint XK_Pointer_UpLeft;
		public const uint XK_Pointer_UpRight;
		public const uint XK_Pointer_DownLeft;
		public const uint XK_Pointer_DownRight;
		public const uint XK_Pointer_Button_Dflt;
		public const uint XK_Pointer_Button1;
		public const uint XK_Pointer_Button2;
		public const uint XK_Pointer_Button3;
		public const uint XK_Pointer_Button4;
		public const uint XK_Pointer_Button5;
		public const uint XK_Pointer_DblClick_Dflt;
		public const uint XK_Pointer_DblClick1;
		public const uint XK_Pointer_DblClick2;
		public const uint XK_Pointer_DblClick3;
		public const uint XK_Pointer_DblClick4;
		public const uint XK_Pointer_DblClick5;
		public const uint XK_Pointer_Drag_Dflt;
		public const uint XK_Pointer_Drag1;
		public const uint XK_Pointer_Drag2;
		public const uint XK_Pointer_Drag3;
		public const uint XK_Pointer_Drag4;
		public const uint XK_Pointer_Drag5;

		public const uint XK_Pointer_EnableKeys;
		public const uint XK_Pointer_Accelerate;
		public const uint XK_Pointer_DfltBtnNext;
		public const uint XK_Pointer_DfltBtnPrev;


/*
 * 3270 Terminal Keys
 * Byte 3 =;
 */

		public const uint XK_3270_Duplicate;
		public const uint XK_3270_FieldMark;
		public const uint XK_3270_Right2;
		public const uint XK_3270_Left2;
		public const uint XK_3270_BackTab;
		public const uint XK_3270_EraseEOF;
		public const uint XK_3270_EraseInput;
		public const uint XK_3270_Reset;
		public const uint XK_3270_Quit;
		public const uint XK_3270_PA1;
		public const uint XK_3270_PA2;
		public const uint XK_3270_PA3;
		public const uint XK_3270_Test;
		public const uint XK_3270_Attn;
		public const uint XK_3270_CursorBlink;
		public const uint XK_3270_AltCursor;
		public const uint XK_3270_KeyClick;
		public const uint XK_3270_Jump;
		public const uint XK_3270_Ident;
		public const uint XK_3270_Rule;
		public const uint XK_3270_Copy;
		public const uint XK_3270_Play;
		public const uint XK_3270_Setup;
		public const uint XK_3270_Record;
		public const uint XK_3270_ChangeScreen;
		public const uint XK_3270_DeleteWord;
		public const uint XK_3270_ExSelect;
		public const uint XK_3270_CursorSelect;
		public const uint XK_3270_PrintScreen;
		public const uint XK_3270_Enter;

/*
 * Latin 1
 * (ISO/IEC 8859-1 = Unicode U+0020..U+00FF)
 * Byte 3 = 0
 */
		public const uint XK_space; /* U+0020 SPACE */
		public const uint XK_exclam; /* U+0021 EXCLAMATION MARK */
		public const uint XK_quotedbl; /* U+0022 QUOTATION MARK */
		public const uint XK_numbersign; /* U+0023 NUMBER SIGN */
		public const uint XK_dollar; /* U+0024 DOLLAR SIGN */
		public const uint XK_percent; /* U+0025 PERCENT SIGN */
		public const uint XK_ampersand; /* U+0026 AMPERSAND */
		public const uint XK_apostrophe; /* U+0027 APOSTROPHE */
		public const uint XK_quoteright; /* deprecated */
		public const uint XK_parenleft; /* U+0028 LEFT PARENTHESIS */
		public const uint XK_parenright; /* U+0029 RIGHT PARENTHESIS */
		public const uint XK_asterisk; /* U+002A ASTERISK */
		public const uint XK_plus; /* U+002B PLUS SIGN */
		public const uint XK_comma; /* U+002C COMMA */
		public const uint XK_minus; /* U+002D HYPHEN-MINUS */
		public const uint XK_period; /* U+002E FULL STOP */
		public const uint XK_slash; /* U+002F SOLIDUS */
		public const uint XK_0; /* U+0030 DIGIT ZERO */
		public const uint XK_1; /* U+0031 DIGIT ONE */
		public const uint XK_2; /* U+0032 DIGIT TWO */
		public const uint XK_3; /* U+0033 DIGIT THREE */
		public const uint XK_4; /* U+0034 DIGIT FOUR */
		public const uint XK_5; /* U+0035 DIGIT FIVE */
		public const uint XK_6; /* U+0036 DIGIT SIX */
		public const uint XK_7; /* U+0037 DIGIT SEVEN */
		public const uint XK_8; /* U+0038 DIGIT EIGHT */
		public const uint XK_9; /* U+0039 DIGIT NINE */
		public const uint XK_colon; /* U+003A COLON */
		public const uint XK_semicolon; /* U+003B SEMICOLON */
		public const uint XK_less; /* U+003C LESS-THAN SIGN */
		public const uint XK_equal; /* U+003D EQUALS SIGN */
		public const uint XK_greater; /* U+003E GREATER-THAN SIGN */
		public const uint XK_question; /* U+003F QUESTION MARK */
		public const uint XK_at; /* U+0040 COMMERCIAL AT */
		public const uint XK_A; /* U+0041 LATIN CAPITAL LETTER A */
		public const uint XK_B; /* U+0042 LATIN CAPITAL LETTER B */
		public const uint XK_C; /* U+0043 LATIN CAPITAL LETTER C */
		public const uint XK_D; /* U+0044 LATIN CAPITAL LETTER D */
		public const uint XK_E; /* U+0045 LATIN CAPITAL LETTER E */
		public const uint XK_F; /* U+0046 LATIN CAPITAL LETTER F */
		public const uint XK_G; /* U+0047 LATIN CAPITAL LETTER G */
		public const uint XK_H; /* U+0048 LATIN CAPITAL LETTER H */
		public const uint XK_I; /* U+0049 LATIN CAPITAL LETTER I */
		public const uint XK_J; /* U+004A LATIN CAPITAL LETTER J */
		public const uint XK_K; /* U+004B LATIN CAPITAL LETTER K */
		public const uint XK_L; /* U+004C LATIN CAPITAL LETTER L */
		public const uint XK_M; /* U+004D LATIN CAPITAL LETTER M */
		public const uint XK_N; /* U+004E LATIN CAPITAL LETTER N */
		public const uint XK_O; /* U+004F LATIN CAPITAL LETTER O */
		public const uint XK_P; /* U+0050 LATIN CAPITAL LETTER P */
		public const uint XK_Q; /* U+0051 LATIN CAPITAL LETTER Q */
		public const uint XK_R; /* U+0052 LATIN CAPITAL LETTER R */
		public const uint XK_S; /* U+0053 LATIN CAPITAL LETTER S */
		public const uint XK_T; /* U+0054 LATIN CAPITAL LETTER T */
		public const uint XK_U; /* U+0055 LATIN CAPITAL LETTER U */
		public const uint XK_V; /* U+0056 LATIN CAPITAL LETTER V */
		public const uint XK_W; /* U+0057 LATIN CAPITAL LETTER W */
		public const uint XK_X; /* U+0058 LATIN CAPITAL LETTER X */
		public const uint XK_Y; /* U+0059 LATIN CAPITAL LETTER Y */
		public const uint XK_Z; /* U+005A LATIN CAPITAL LETTER Z */
		public const uint XK_bracketleft; /* U+005B LEFT SQUARE BRACKET */
		public const uint XK_backslash; /* U+005C REVERSE SOLIDUS */
		public const uint XK_bracketright; /* U+005D RIGHT SQUARE BRACKET */
		public const uint XK_asciicircum; /* U+005E CIRCUMFLEX ACCENT */
		public const uint XK_underscore; /* U+005F LOW LINE */
		public const uint XK_grave; /* U+0060 GRAVE ACCENT */
		public const uint XK_quoteleft; /* deprecated */
		public const uint XK_a; /* U+0061 LATIN SMALL LETTER A */
		public const uint XK_b; /* U+0062 LATIN SMALL LETTER B */
		public const uint XK_c; /* U+0063 LATIN SMALL LETTER C */
		public const uint XK_d; /* U+0064 LATIN SMALL LETTER D */
		public const uint XK_e; /* U+0065 LATIN SMALL LETTER E */
		public const uint XK_f; /* U+0066 LATIN SMALL LETTER F */
		public const uint XK_g; /* U+0067 LATIN SMALL LETTER G */
		public const uint XK_h; /* U+0068 LATIN SMALL LETTER H */
		public const uint XK_i; /* U+0069 LATIN SMALL LETTER I */
		public const uint XK_j; /* U+006A LATIN SMALL LETTER J */
		public const uint XK_k; /* U+006B LATIN SMALL LETTER K */
		public const uint XK_l; /* U+006C LATIN SMALL LETTER L */
		public const uint XK_m; /* U+006D LATIN SMALL LETTER M */
		public const uint XK_n; /* U+006E LATIN SMALL LETTER N */
		public const uint XK_o; /* U+006F LATIN SMALL LETTER O */
		public const uint XK_p; /* U+0070 LATIN SMALL LETTER P */
		public const uint XK_q; /* U+0071 LATIN SMALL LETTER Q */
		public const uint XK_r; /* U+0072 LATIN SMALL LETTER R */
		public const uint XK_s; /* U+0073 LATIN SMALL LETTER S */
		public const uint XK_t; /* U+0074 LATIN SMALL LETTER T */
		public const uint XK_u; /* U+0075 LATIN SMALL LETTER U */
		public const uint XK_v; /* U+0076 LATIN SMALL LETTER V */
		public const uint XK_w; /* U+0077 LATIN SMALL LETTER W */
		public const uint XK_x; /* U+0078 LATIN SMALL LETTER X */
		public const uint XK_y; /* U+0079 LATIN SMALL LETTER Y */
		public const uint XK_z; /* U+007A LATIN SMALL LETTER Z */
		public const uint XK_braceleft; /* U+007B LEFT CURLY BRACKET */
		public const uint XK_bar; /* U+007C VERTICAL LINE */
		public const uint XK_braceright; /* U+007D RIGHT CURLY BRACKET */
		public const uint XK_asciitilde; /* U+007E TILDE */

		public const uint XK_nobreakspace; /* U+00A0 NO-BREAK SPACE */
		public const uint XK_exclamdown; /* U+00A1 INVERTED EXCLAMATION MARK */
		public const uint XK_cent; /* U+00A2 CENT SIGN */
		public const uint XK_sterling; /* U+00A3 POUND SIGN */
		public const uint XK_currency; /* U+00A4 CURRENCY SIGN */
		public const uint XK_yen; /* U+00A5 YEN SIGN */
		public const uint XK_brokenbar; /* U+00A6 BROKEN BAR */
		public const uint XK_section; /* U+00A7 SECTION SIGN */
		public const uint XK_diaeresis; /* U+00A8 DIAERESIS */
		public const uint XK_copyright; /* U+00A9 COPYRIGHT SIGN */
		public const uint XK_ordfeminine; /* U+00AA FEMININE ORDINAL INDICATOR */
		public const uint XK_guillemotleft; /* U+00AB LEFT-POINTING DOUBLE ANGLE QUOTATION MARK */
		public const uint XK_notsign; /* U+00AC NOT SIGN */
		public const uint XK_hyphen; /* U+00AD SOFT HYPHEN */
		public const uint XK_registered; /* U+00AE REGISTERED SIGN */
		public const uint XK_macron; /* U+00AF MACRON */
		public const uint XK_degree; /* U+00B0 DEGREE SIGN */
		public const uint XK_plusminus; /* U+00B1 PLUS-MINUS SIGN */
		public const uint XK_twosuperior; /* U+00B2 SUPERSCRIPT TWO */
		public const uint XK_threesuperior; /* U+00B3 SUPERSCRIPT THREE */
		public const uint XK_acute; /* U+00B4 ACUTE ACCENT */
		public const uint XK_mu; /* U+00B5 MICRO SIGN */
		public const uint XK_paragraph; /* U+00B6 PILCROW SIGN */
		public const uint XK_periodcentered; /* U+00B7 MIDDLE DOT */
		public const uint XK_cedilla; /* U+00B8 CEDILLA */
		public const uint XK_onesuperior; /* U+00B9 SUPERSCRIPT ONE */
		public const uint XK_masculine; /* U+00BA MASCULINE ORDINAL INDICATOR */
		public const uint XK_guillemotright; /* U+00BB RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK */
		public const uint XK_onequarter; /* U+00BC VULGAR FRACTION ONE QUARTER */
		public const uint XK_onehalf; /* U+00BD VULGAR FRACTION ONE HALF */
		public const uint XK_threequarters; /* U+00BE VULGAR FRACTION THREE QUARTERS */
		public const uint XK_questiondown; /* U+00BF INVERTED QUESTION MARK */
		public const uint XK_Agrave; /* U+00C0 LATIN CAPITAL LETTER A WITH GRAVE */
		public const uint XK_Aacute; /* U+00C1 LATIN CAPITAL LETTER A WITH ACUTE */
		public const uint XK_Acircumflex; /* U+00C2 LATIN CAPITAL LETTER A WITH CIRCUMFLEX */
		public const uint XK_Atilde; /* U+00C3 LATIN CAPITAL LETTER A WITH TILDE */
		public const uint XK_Adiaeresis; /* U+00C4 LATIN CAPITAL LETTER A WITH DIAERESIS */
		public const uint XK_Aring; /* U+00C5 LATIN CAPITAL LETTER A WITH RING ABOVE */
		public const uint XK_AE; /* U+00C6 LATIN CAPITAL LETTER AE */
		public const uint XK_Ccedilla; /* U+00C7 LATIN CAPITAL LETTER C WITH CEDILLA */
		public const uint XK_Egrave; /* U+00C8 LATIN CAPITAL LETTER E WITH GRAVE */
		public const uint XK_Eacute; /* U+00C9 LATIN CAPITAL LETTER E WITH ACUTE */
		public const uint XK_Ecircumflex; /* U+00CA LATIN CAPITAL LETTER E WITH CIRCUMFLEX */
		public const uint XK_Ediaeresis; /* U+00CB LATIN CAPITAL LETTER E WITH DIAERESIS */
		public const uint XK_Igrave; /* U+00CC LATIN CAPITAL LETTER I WITH GRAVE */
		public const uint XK_Iacute; /* U+00CD LATIN CAPITAL LETTER I WITH ACUTE */
		public const uint XK_Icircumflex; /* U+00CE LATIN CAPITAL LETTER I WITH CIRCUMFLEX */
		public const uint XK_Idiaeresis; /* U+00CF LATIN CAPITAL LETTER I WITH DIAERESIS */
		public const uint XK_ETH; /* U+00D0 LATIN CAPITAL LETTER ETH */
		public const uint XK_Eth; /* deprecated */
		public const uint XK_Ntilde; /* U+00D1 LATIN CAPITAL LETTER N WITH TILDE */
		public const uint XK_Ograve; /* U+00D2 LATIN CAPITAL LETTER O WITH GRAVE */
		public const uint XK_Oacute; /* U+00D3 LATIN CAPITAL LETTER O WITH ACUTE */
		public const uint XK_Ocircumflex; /* U+00D4 LATIN CAPITAL LETTER O WITH CIRCUMFLEX */
		public const uint XK_Otilde; /* U+00D5 LATIN CAPITAL LETTER O WITH TILDE */
		public const uint XK_Odiaeresis; /* U+00D6 LATIN CAPITAL LETTER O WITH DIAERESIS */
		public const uint XK_multiply; /* U+00D7 MULTIPLICATION SIGN */
		public const uint XK_Oslash; /* U+00D8 LATIN CAPITAL LETTER O WITH STROKE */
		public const uint XK_Ooblique; /* U+00D8 LATIN CAPITAL LETTER O WITH STROKE */
		public const uint XK_Ugrave; /* U+00D9 LATIN CAPITAL LETTER U WITH GRAVE */
		public const uint XK_Uacute; /* U+00DA LATIN CAPITAL LETTER U WITH ACUTE */
		public const uint XK_Ucircumflex; /* U+00DB LATIN CAPITAL LETTER U WITH CIRCUMFLEX */
		public const uint XK_Udiaeresis; /* U+00DC LATIN CAPITAL LETTER U WITH DIAERESIS */
		public const uint XK_Yacute; /* U+00DD LATIN CAPITAL LETTER Y WITH ACUTE */
		public const uint XK_THORN; /* U+00DE LATIN CAPITAL LETTER THORN */
		public const uint XK_Thorn; /* deprecated */
		public const uint XK_ssharp; /* U+00DF LATIN SMALL LETTER SHARP S */
		public const uint XK_agrave; /* U+00E0 LATIN SMALL LETTER A WITH GRAVE */
		public const uint XK_aacute; /* U+00E1 LATIN SMALL LETTER A WITH ACUTE */
		public const uint XK_acircumflex; /* U+00E2 LATIN SMALL LETTER A WITH CIRCUMFLEX */
		public const uint XK_atilde; /* U+00E3 LATIN SMALL LETTER A WITH TILDE */
		public const uint XK_adiaeresis; /* U+00E4 LATIN SMALL LETTER A WITH DIAERESIS */
		public const uint XK_aring; /* U+00E5 LATIN SMALL LETTER A WITH RING ABOVE */
		public const uint XK_ae; /* U+00E6 LATIN SMALL LETTER AE */
		public const uint XK_ccedilla; /* U+00E7 LATIN SMALL LETTER C WITH CEDILLA */
		public const uint XK_egrave; /* U+00E8 LATIN SMALL LETTER E WITH GRAVE */
		public const uint XK_eacute; /* U+00E9 LATIN SMALL LETTER E WITH ACUTE */
		public const uint XK_ecircumflex; /* U+00EA LATIN SMALL LETTER E WITH CIRCUMFLEX */
		public const uint XK_ediaeresis; /* U+00EB LATIN SMALL LETTER E WITH DIAERESIS */
		public const uint XK_igrave; /* U+00EC LATIN SMALL LETTER I WITH GRAVE */
		public const uint XK_iacute; /* U+00ED LATIN SMALL LETTER I WITH ACUTE */
		public const uint XK_icircumflex; /* U+00EE LATIN SMALL LETTER I WITH CIRCUMFLEX */
		public const uint XK_idiaeresis; /* U+00EF LATIN SMALL LETTER I WITH DIAERESIS */
		public const uint XK_eth; /* U+00F0 LATIN SMALL LETTER ETH */
		public const uint XK_ntilde; /* U+00F1 LATIN SMALL LETTER N WITH TILDE */
		public const uint XK_ograve; /* U+00F2 LATIN SMALL LETTER O WITH GRAVE */
		public const uint XK_oacute; /* U+00F3 LATIN SMALL LETTER O WITH ACUTE */
		public const uint XK_ocircumflex; /* U+00F4 LATIN SMALL LETTER O WITH CIRCUMFLEX */
		public const uint XK_otilde; /* U+00F5 LATIN SMALL LETTER O WITH TILDE */
		public const uint XK_odiaeresis; /* U+00F6 LATIN SMALL LETTER O WITH DIAERESIS */
		public const uint XK_division; /* U+00F7 DIVISION SIGN */
		public const uint XK_oslash; /* U+00F8 LATIN SMALL LETTER O WITH STROKE */
		public const uint XK_ooblique; /* U+00F8 LATIN SMALL LETTER O WITH STROKE */
		public const uint XK_ugrave; /* U+00F9 LATIN SMALL LETTER U WITH GRAVE */
		public const uint XK_uacute; /* U+00FA LATIN SMALL LETTER U WITH ACUTE */
		public const uint XK_ucircumflex; /* U+00FB LATIN SMALL LETTER U WITH CIRCUMFLEX */
		public const uint XK_udiaeresis; /* U+00FC LATIN SMALL LETTER U WITH DIAERESIS */
		public const uint XK_yacute; /* U+00FD LATIN SMALL LETTER Y WITH ACUTE */
		public const uint XK_thorn; /* U+00FE LATIN SMALL LETTER THORN */
		public const uint XK_ydiaeresis; /* U+00FF LATIN SMALL LETTER Y WITH DIAERESIS */

/*
 * Latin 2
 * Byte 3 = 1
 */

		public const uint XK_Aogonek; /* U+0104 LATIN CAPITAL LETTER A WITH OGONEK */
		public const uint XK_breve; /* U+02D8 BREVE */
		public const uint XK_Lstroke; /* U+0141 LATIN CAPITAL LETTER L WITH STROKE */
		public const uint XK_Lcaron; /* U+013D LATIN CAPITAL LETTER L WITH CARON */
		public const uint XK_Sacute; /* U+015A LATIN CAPITAL LETTER S WITH ACUTE */
		public const uint XK_Scaron; /* U+0160 LATIN CAPITAL LETTER S WITH CARON */
		public const uint XK_Scedilla; /* U+015E LATIN CAPITAL LETTER S WITH CEDILLA */
		public const uint XK_Tcaron; /* U+0164 LATIN CAPITAL LETTER T WITH CARON */
		public const uint XK_Zacute; /* U+0179 LATIN CAPITAL LETTER Z WITH ACUTE */
		public const uint XK_Zcaron; /* U+017D LATIN CAPITAL LETTER Z WITH CARON */
		public const uint XK_Zabovedot; /* U+017B LATIN CAPITAL LETTER Z WITH DOT ABOVE */
		public const uint XK_aogonek; /* U+0105 LATIN SMALL LETTER A WITH OGONEK */
		public const uint XK_ogonek; /* U+02DB OGONEK */
		public const uint XK_lstroke; /* U+0142 LATIN SMALL LETTER L WITH STROKE */
		public const uint XK_lcaron; /* U+013E LATIN SMALL LETTER L WITH CARON */
		public const uint XK_sacute; /* U+015B LATIN SMALL LETTER S WITH ACUTE */
		public const uint XK_caron; /* U+02C7 CARON */
		public const uint XK_scaron; /* U+0161 LATIN SMALL LETTER S WITH CARON */
		public const uint XK_scedilla; /* U+015F LATIN SMALL LETTER S WITH CEDILLA */
		public const uint XK_tcaron; /* U+0165 LATIN SMALL LETTER T WITH CARON */
		public const uint XK_zacute; /* U+017A LATIN SMALL LETTER Z WITH ACUTE */
		public const uint XK_doubleacute; /* U+02DD DOUBLE ACUTE ACCENT */
		public const uint XK_zcaron; /* U+017E LATIN SMALL LETTER Z WITH CARON */
		public const uint XK_zabovedot; /* U+017C LATIN SMALL LETTER Z WITH DOT ABOVE */
		public const uint XK_Racute; /* U+0154 LATIN CAPITAL LETTER R WITH ACUTE */
		public const uint XK_Abreve; /* U+0102 LATIN CAPITAL LETTER A WITH BREVE */
		public const uint XK_Lacute; /* U+0139 LATIN CAPITAL LETTER L WITH ACUTE */
		public const uint XK_Cacute; /* U+0106 LATIN CAPITAL LETTER C WITH ACUTE */
		public const uint XK_Ccaron; /* U+010C LATIN CAPITAL LETTER C WITH CARON */
		public const uint XK_Eogonek; /* U+0118 LATIN CAPITAL LETTER E WITH OGONEK */
		public const uint XK_Ecaron; /* U+011A LATIN CAPITAL LETTER E WITH CARON */
		public const uint XK_Dcaron; /* U+010E LATIN CAPITAL LETTER D WITH CARON */
		public const uint XK_Dstroke; /* U+0110 LATIN CAPITAL LETTER D WITH STROKE */
		public const uint XK_Nacute; /* U+0143 LATIN CAPITAL LETTER N WITH ACUTE */
		public const uint XK_Ncaron; /* U+0147 LATIN CAPITAL LETTER N WITH CARON */
		public const uint XK_Odoubleacute; /* U+0150 LATIN CAPITAL LETTER O WITH DOUBLE ACUTE */
		public const uint XK_Rcaron; /* U+0158 LATIN CAPITAL LETTER R WITH CARON */
		public const uint XK_Uring; /* U+016E LATIN CAPITAL LETTER U WITH RING ABOVE */
		public const uint XK_Udoubleacute; /* U+0170 LATIN CAPITAL LETTER U WITH DOUBLE ACUTE */
		public const uint XK_Tcedilla; /* U+0162 LATIN CAPITAL LETTER T WITH CEDILLA */
		public const uint XK_racute; /* U+0155 LATIN SMALL LETTER R WITH ACUTE */
		public const uint XK_abreve; /* U+0103 LATIN SMALL LETTER A WITH BREVE */
		public const uint XK_lacute; /* U+013A LATIN SMALL LETTER L WITH ACUTE */
		public const uint XK_cacute; /* U+0107 LATIN SMALL LETTER C WITH ACUTE */
		public const uint XK_ccaron; /* U+010D LATIN SMALL LETTER C WITH CARON */
		public const uint XK_eogonek; /* U+0119 LATIN SMALL LETTER E WITH OGONEK */
		public const uint XK_ecaron; /* U+011B LATIN SMALL LETTER E WITH CARON */
		public const uint XK_dcaron; /* U+010F LATIN SMALL LETTER D WITH CARON */
		public const uint XK_dstroke; /* U+0111 LATIN SMALL LETTER D WITH STROKE */
		public const uint XK_nacute; /* U+0144 LATIN SMALL LETTER N WITH ACUTE */
		public const uint XK_ncaron; /* U+0148 LATIN SMALL LETTER N WITH CARON */
		public const uint XK_odoubleacute; /* U+0151 LATIN SMALL LETTER O WITH DOUBLE ACUTE */
		public const uint XK_udoubleacute; /* U+0171 LATIN SMALL LETTER U WITH DOUBLE ACUTE */
		public const uint XK_rcaron; /* U+0159 LATIN SMALL LETTER R WITH CARON */
		public const uint XK_uring; /* U+016F LATIN SMALL LETTER U WITH RING ABOVE */
		public const uint XK_tcedilla; /* U+0163 LATIN SMALL LETTER T WITH CEDILLA */
		public const uint XK_abovedot; /* U+02D9 DOT ABOVE */

/*
 * Latin 3
 * Byte 3 = 2
 */

		public const uint XK_Hstroke; /* U+0126 LATIN CAPITAL LETTER H WITH STROKE */
		public const uint XK_Hcircumflex; /* U+0124 LATIN CAPITAL LETTER H WITH CIRCUMFLEX */
		public const uint XK_Iabovedot; /* U+0130 LATIN CAPITAL LETTER I WITH DOT ABOVE */
		public const uint XK_Gbreve; /* U+011E LATIN CAPITAL LETTER G WITH BREVE */
		public const uint XK_Jcircumflex; /* U+0134 LATIN CAPITAL LETTER J WITH CIRCUMFLEX */
		public const uint XK_hstroke; /* U+0127 LATIN SMALL LETTER H WITH STROKE */
		public const uint XK_hcircumflex; /* U+0125 LATIN SMALL LETTER H WITH CIRCUMFLEX */
		public const uint XK_idotless; /* U+0131 LATIN SMALL LETTER DOTLESS I */
		public const uint XK_gbreve; /* U+011F LATIN SMALL LETTER G WITH BREVE */
		public const uint XK_jcircumflex; /* U+0135 LATIN SMALL LETTER J WITH CIRCUMFLEX */
		public const uint XK_Cabovedot; /* U+010A LATIN CAPITAL LETTER C WITH DOT ABOVE */
		public const uint XK_Ccircumflex; /* U+0108 LATIN CAPITAL LETTER C WITH CIRCUMFLEX */
		public const uint XK_Gabovedot; /* U+0120 LATIN CAPITAL LETTER G WITH DOT ABOVE */
		public const uint XK_Gcircumflex; /* U+011C LATIN CAPITAL LETTER G WITH CIRCUMFLEX */
		public const uint XK_Ubreve; /* U+016C LATIN CAPITAL LETTER U WITH BREVE */
		public const uint XK_Scircumflex; /* U+015C LATIN CAPITAL LETTER S WITH CIRCUMFLEX */
		public const uint XK_cabovedot; /* U+010B LATIN SMALL LETTER C WITH DOT ABOVE */
		public const uint XK_ccircumflex; /* U+0109 LATIN SMALL LETTER C WITH CIRCUMFLEX */
		public const uint XK_gabovedot; /* U+0121 LATIN SMALL LETTER G WITH DOT ABOVE */
		public const uint XK_gcircumflex; /* U+011D LATIN SMALL LETTER G WITH CIRCUMFLEX */
		public const uint XK_ubreve; /* U+016D LATIN SMALL LETTER U WITH BREVE */
		public const uint XK_scircumflex; /* U+015D LATIN SMALL LETTER S WITH CIRCUMFLEX */


/*
 * Latin 4
 * Byte 3 = 3
 */

		public const uint XK_kra; /* U+0138 LATIN SMALL LETTER KRA */
		public const uint XK_kappa; /* deprecated */
		public const uint XK_Rcedilla; /* U+0156 LATIN CAPITAL LETTER R WITH CEDILLA */
		public const uint XK_Itilde; /* U+0128 LATIN CAPITAL LETTER I WITH TILDE */
		public const uint XK_Lcedilla; /* U+013B LATIN CAPITAL LETTER L WITH CEDILLA */
		public const uint XK_Emacron; /* U+0112 LATIN CAPITAL LETTER E WITH MACRON */
		public const uint XK_Gcedilla; /* U+0122 LATIN CAPITAL LETTER G WITH CEDILLA */
		public const uint XK_Tslash; /* U+0166 LATIN CAPITAL LETTER T WITH STROKE */
		public const uint XK_rcedilla; /* U+0157 LATIN SMALL LETTER R WITH CEDILLA */
		public const uint XK_itilde; /* U+0129 LATIN SMALL LETTER I WITH TILDE */
		public const uint XK_lcedilla; /* U+013C LATIN SMALL LETTER L WITH CEDILLA */
		public const uint XK_emacron; /* U+0113 LATIN SMALL LETTER E WITH MACRON */
		public const uint XK_gcedilla; /* U+0123 LATIN SMALL LETTER G WITH CEDILLA */
		public const uint XK_tslash; /* U+0167 LATIN SMALL LETTER T WITH STROKE */
		public const uint XK_ENG; /* U+014A LATIN CAPITAL LETTER ENG */
		public const uint XK_eng; /* U+014B LATIN SMALL LETTER ENG */
		public const uint XK_Amacron; /* U+0100 LATIN CAPITAL LETTER A WITH MACRON */
		public const uint XK_Iogonek; /* U+012E LATIN CAPITAL LETTER I WITH OGONEK */
		public const uint XK_Eabovedot; /* U+0116 LATIN CAPITAL LETTER E WITH DOT ABOVE */
		public const uint XK_Imacron; /* U+012A LATIN CAPITAL LETTER I WITH MACRON */
		public const uint XK_Ncedilla; /* U+0145 LATIN CAPITAL LETTER N WITH CEDILLA */
		public const uint XK_Omacron; /* U+014C LATIN CAPITAL LETTER O WITH MACRON */
		public const uint XK_Kcedilla; /* U+0136 LATIN CAPITAL LETTER K WITH CEDILLA */
		public const uint XK_Uogonek; /* U+0172 LATIN CAPITAL LETTER U WITH OGONEK */
		public const uint XK_Utilde; /* U+0168 LATIN CAPITAL LETTER U WITH TILDE */
		public const uint XK_Umacron; /* U+016A LATIN CAPITAL LETTER U WITH MACRON */
		public const uint XK_amacron; /* U+0101 LATIN SMALL LETTER A WITH MACRON */
		public const uint XK_iogonek; /* U+012F LATIN SMALL LETTER I WITH OGONEK */
		public const uint XK_eabovedot; /* U+0117 LATIN SMALL LETTER E WITH DOT ABOVE */
		public const uint XK_imacron; /* U+012B LATIN SMALL LETTER I WITH MACRON */
		public const uint XK_ncedilla; /* U+0146 LATIN SMALL LETTER N WITH CEDILLA */
		public const uint XK_omacron; /* U+014D LATIN SMALL LETTER O WITH MACRON */
		public const uint XK_kcedilla; /* U+0137 LATIN SMALL LETTER K WITH CEDILLA */
		public const uint XK_uogonek; /* U+0173 LATIN SMALL LETTER U WITH OGONEK */
		public const uint XK_utilde; /* U+0169 LATIN SMALL LETTER U WITH TILDE */
		public const uint XK_umacron; /* U+016B LATIN SMALL LETTER U WITH MACRON */

/*
 * Latin 8
 */
		public const uint XK_Babovedot; /* U+1E02 LATIN CAPITAL LETTER B WITH DOT ABOVE */
		public const uint XK_babovedot; /* U+1E03 LATIN SMALL LETTER B WITH DOT ABOVE */
		public const uint XK_Dabovedot; /* U+1E0A LATIN CAPITAL LETTER D WITH DOT ABOVE */
		public const uint XK_Wgrave; /* U+1E80 LATIN CAPITAL LETTER W WITH GRAVE */
		public const uint XK_Wacute; /* U+1E82 LATIN CAPITAL LETTER W WITH ACUTE */
		public const uint XK_dabovedot; /* U+1E0B LATIN SMALL LETTER D WITH DOT ABOVE */
		public const uint XK_Ygrave; /* U+1EF2 LATIN CAPITAL LETTER Y WITH GRAVE */
		public const uint XK_Fabovedot; /* U+1E1E LATIN CAPITAL LETTER F WITH DOT ABOVE */
		public const uint XK_fabovedot; /* U+1E1F LATIN SMALL LETTER F WITH DOT ABOVE */
		public const uint XK_Mabovedot; /* U+1E40 LATIN CAPITAL LETTER M WITH DOT ABOVE */
		public const uint XK_mabovedot; /* U+1E41 LATIN SMALL LETTER M WITH DOT ABOVE */
		public const uint XK_Pabovedot; /* U+1E56 LATIN CAPITAL LETTER P WITH DOT ABOVE */
		public const uint XK_wgrave; /* U+1E81 LATIN SMALL LETTER W WITH GRAVE */
		public const uint XK_pabovedot; /* U+1E57 LATIN SMALL LETTER P WITH DOT ABOVE */
		public const uint XK_wacute; /* U+1E83 LATIN SMALL LETTER W WITH ACUTE */
		public const uint XK_Sabovedot; /* U+1E60 LATIN CAPITAL LETTER S WITH DOT ABOVE */
		public const uint XK_ygrave; /* U+1EF3 LATIN SMALL LETTER Y WITH GRAVE */
		public const uint XK_Wdiaeresis; /* U+1E84 LATIN CAPITAL LETTER W WITH DIAERESIS */
		public const uint XK_wdiaeresis; /* U+1E85 LATIN SMALL LETTER W WITH DIAERESIS */
		public const uint XK_sabovedot; /* U+1E61 LATIN SMALL LETTER S WITH DOT ABOVE */
		public const uint XK_Wcircumflex; /* U+0174 LATIN CAPITAL LETTER W WITH CIRCUMFLEX */
		public const uint XK_Tabovedot; /* U+1E6A LATIN CAPITAL LETTER T WITH DOT ABOVE */
		public const uint XK_Ycircumflex; /* U+0176 LATIN CAPITAL LETTER Y WITH CIRCUMFLEX */
		public const uint XK_wcircumflex; /* U+0175 LATIN SMALL LETTER W WITH CIRCUMFLEX */
		public const uint XK_tabovedot; /* U+1E6B LATIN SMALL LETTER T WITH DOT ABOVE */
		public const uint XK_ycircumflex; /* U+0177 LATIN SMALL LETTER Y WITH CIRCUMFLEX */

/*
 * Latin 9
 * Byte 3 =;
 */

		public const uint XK_OE; /* U+0152 LATIN CAPITAL LIGATURE OE */
		public const uint XK_oe; /* U+0153 LATIN SMALL LIGATURE OE */
		public const uint XK_Ydiaeresis; /* U+0178 LATIN CAPITAL LETTER Y WITH DIAERESIS */

/*
 * Katakana
 * Byte 3 = 4
 */

		public const uint XK_overline; /* U+203E OVERLINE */
		public const uint XK_kana_fullstop; /* U+3002 IDEOGRAPHIC FULL STOP */
		public const uint XK_kana_openingbracket; /* U+300C LEFT CORNER BRACKET */
		public const uint XK_kana_closingbracket; /* U+300D RIGHT CORNER BRACKET */
		public const uint XK_kana_comma; /* U+3001 IDEOGRAPHIC COMMA */
		public const uint XK_kana_conjunctive; /* U+30FB KATAKANA MIDDLE DOT */
		public const uint XK_kana_middledot; /* deprecated */
		public const uint XK_kana_WO; /* U+30F2 KATAKANA LETTER WO */
		public const uint XK_kana_a; /* U+30A1 KATAKANA LETTER SMALL A */
		public const uint XK_kana_i; /* U+30A3 KATAKANA LETTER SMALL I */
		public const uint XK_kana_u; /* U+30A5 KATAKANA LETTER SMALL U */
		public const uint XK_kana_e; /* U+30A7 KATAKANA LETTER SMALL E */
		public const uint XK_kana_o; /* U+30A9 KATAKANA LETTER SMALL O */
		public const uint XK_kana_ya; /* U+30E3 KATAKANA LETTER SMALL YA */
		public const uint XK_kana_yu; /* U+30E5 KATAKANA LETTER SMALL YU */
		public const uint XK_kana_yo; /* U+30E7 KATAKANA LETTER SMALL YO */
		public const uint XK_kana_tsu; /* U+30C3 KATAKANA LETTER SMALL TU */
		public const uint XK_kana_tu; /* deprecated */
		public const uint XK_prolongedsound; /* U+30FC KATAKANA-HIRAGANA PROLONGED SOUND MARK */
		public const uint XK_kana_A; /* U+30A2 KATAKANA LETTER A */
		public const uint XK_kana_I; /* U+30A4 KATAKANA LETTER I */
		public const uint XK_kana_U; /* U+30A6 KATAKANA LETTER U */
		public const uint XK_kana_E; /* U+30A8 KATAKANA LETTER E */
		public const uint XK_kana_O; /* U+30AA KATAKANA LETTER O */
		public const uint XK_kana_KA; /* U+30AB KATAKANA LETTER KA */
		public const uint XK_kana_KI; /* U+30AD KATAKANA LETTER KI */
		public const uint XK_kana_KU; /* U+30AF KATAKANA LETTER KU */
		public const uint XK_kana_KE; /* U+30B1 KATAKANA LETTER KE */
		public const uint XK_kana_KO; /* U+30B3 KATAKANA LETTER KO */
		public const uint XK_kana_SA; /* U+30B5 KATAKANA LETTER SA */
		public const uint XK_kana_SHI; /* U+30B7 KATAKANA LETTER SI */
		public const uint XK_kana_SU; /* U+30B9 KATAKANA LETTER SU */
		public const uint XK_kana_SE; /* U+30BB KATAKANA LETTER SE */
		public const uint XK_kana_SO; /* U+30BD KATAKANA LETTER SO */
		public const uint XK_kana_TA; /* U+30BF KATAKANA LETTER TA */
		public const uint XK_kana_CHI; /* U+30C1 KATAKANA LETTER TI */
		public const uint XK_kana_TI; /* deprecated */
		public const uint XK_kana_TSU; /* U+30C4 KATAKANA LETTER TU */
		public const uint XK_kana_TU; /* deprecated */
		public const uint XK_kana_TE; /* U+30C6 KATAKANA LETTER TE */
		public const uint XK_kana_TO; /* U+30C8 KATAKANA LETTER TO */
		public const uint XK_kana_NA; /* U+30CA KATAKANA LETTER NA */
		public const uint XK_kana_NI; /* U+30CB KATAKANA LETTER NI */
		public const uint XK_kana_NU; /* U+30CC KATAKANA LETTER NU */
		public const uint XK_kana_NE; /* U+30CD KATAKANA LETTER NE */
		public const uint XK_kana_NO; /* U+30CE KATAKANA LETTER NO */
		public const uint XK_kana_HA; /* U+30CF KATAKANA LETTER HA */
		public const uint XK_kana_HI; /* U+30D2 KATAKANA LETTER HI */
		public const uint XK_kana_FU; /* U+30D5 KATAKANA LETTER HU */
		public const uint XK_kana_HU; /* deprecated */
		public const uint XK_kana_HE; /* U+30D8 KATAKANA LETTER HE */
		public const uint XK_kana_HO; /* U+30DB KATAKANA LETTER HO */
		public const uint XK_kana_MA; /* U+30DE KATAKANA LETTER MA */
		public const uint XK_kana_MI; /* U+30DF KATAKANA LETTER MI */
		public const uint XK_kana_MU; /* U+30E0 KATAKANA LETTER MU */
		public const uint XK_kana_ME; /* U+30E1 KATAKANA LETTER ME */
		public const uint XK_kana_MO; /* U+30E2 KATAKANA LETTER MO */
		public const uint XK_kana_YA; /* U+30E4 KATAKANA LETTER YA */
		public const uint XK_kana_YU; /* U+30E6 KATAKANA LETTER YU */
		public const uint XK_kana_YO; /* U+30E8 KATAKANA LETTER YO */
		public const uint XK_kana_RA; /* U+30E9 KATAKANA LETTER RA */
		public const uint XK_kana_RI; /* U+30EA KATAKANA LETTER RI */
		public const uint XK_kana_RU; /* U+30EB KATAKANA LETTER RU */
		public const uint XK_kana_RE; /* U+30EC KATAKANA LETTER RE */
		public const uint XK_kana_RO; /* U+30ED KATAKANA LETTER RO */
		public const uint XK_kana_WA; /* U+30EF KATAKANA LETTER WA */
		public const uint XK_kana_N; /* U+30F3 KATAKANA LETTER N */
		public const uint XK_voicedsound; /* U+309B KATAKANA-HIRAGANA VOICED SOUND MARK */
		public const uint XK_semivoicedsound; /* U+309C KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK */
		public const uint XK_kana_switch; /* Alias for mode_switch */

/*
 * Arabic
 * Byte 3 = 5
 */

		public const uint XK_Farsi_0; /* U+06F0 EXTENDED ARABIC-INDIC DIGIT ZERO */
		public const uint XK_Farsi_1; /* U+06F1 EXTENDED ARABIC-INDIC DIGIT ONE */
		public const uint XK_Farsi_2; /* U+06F2 EXTENDED ARABIC-INDIC DIGIT TWO */
		public const uint XK_Farsi_3; /* U+06F3 EXTENDED ARABIC-INDIC DIGIT THREE */
		public const uint XK_Farsi_4; /* U+06F4 EXTENDED ARABIC-INDIC DIGIT FOUR */
		public const uint XK_Farsi_5; /* U+06F5 EXTENDED ARABIC-INDIC DIGIT FIVE */
		public const uint XK_Farsi_6; /* U+06F6 EXTENDED ARABIC-INDIC DIGIT SIX */
		public const uint XK_Farsi_7; /* U+06F7 EXTENDED ARABIC-INDIC DIGIT SEVEN */
		public const uint XK_Farsi_8; /* U+06F8 EXTENDED ARABIC-INDIC DIGIT EIGHT */
		public const uint XK_Farsi_9; /* U+06F9 EXTENDED ARABIC-INDIC DIGIT NINE */
		public const uint XK_Arabic_percent; /* U+066A ARABIC PERCENT SIGN */
		public const uint XK_Arabic_superscript_alef; /* U+0670 ARABIC LETTER SUPERSCRIPT ALEF */
		public const uint XK_Arabic_tteh; /* U+0679 ARABIC LETTER TTEH */
		public const uint XK_Arabic_peh; /* U+067E ARABIC LETTER PEH */
		public const uint XK_Arabic_tcheh; /* U+0686 ARABIC LETTER TCHEH */
		public const uint XK_Arabic_ddal; /* U+0688 ARABIC LETTER DDAL */
		public const uint XK_Arabic_rreh; /* U+0691 ARABIC LETTER RREH */
		public const uint XK_Arabic_comma; /* U+060C ARABIC COMMA */
		public const uint XK_Arabic_fullstop; /* U+06D4 ARABIC FULL STOP */
		public const uint XK_Arabic_0; /* U+0660 ARABIC-INDIC DIGIT ZERO */
		public const uint XK_Arabic_1; /* U+0661 ARABIC-INDIC DIGIT ONE */
		public const uint XK_Arabic_2; /* U+0662 ARABIC-INDIC DIGIT TWO */
		public const uint XK_Arabic_3; /* U+0663 ARABIC-INDIC DIGIT THREE */
		public const uint XK_Arabic_4; /* U+0664 ARABIC-INDIC DIGIT FOUR */
		public const uint XK_Arabic_5; /* U+0665 ARABIC-INDIC DIGIT FIVE */
		public const uint XK_Arabic_6; /* U+0666 ARABIC-INDIC DIGIT SIX */
		public const uint XK_Arabic_7; /* U+0667 ARABIC-INDIC DIGIT SEVEN */
		public const uint XK_Arabic_8; /* U+0668 ARABIC-INDIC DIGIT EIGHT */
		public const uint XK_Arabic_9; /* U+0669 ARABIC-INDIC DIGIT NINE */
		public const uint XK_Arabic_semicolon; /* U+061B ARABIC SEMICOLON */
		public const uint XK_Arabic_question_mark; /* U+061F ARABIC QUESTION MARK */
		public const uint XK_Arabic_hamza; /* U+0621 ARABIC LETTER HAMZA */
		public const uint XK_Arabic_maddaonalef; /* U+0622 ARABIC LETTER ALEF WITH MADDA ABOVE */
		public const uint XK_Arabic_hamzaonalef; /* U+0623 ARABIC LETTER ALEF WITH HAMZA ABOVE */
		public const uint XK_Arabic_hamzaonwaw; /* U+0624 ARABIC LETTER WAW WITH HAMZA ABOVE */
		public const uint XK_Arabic_hamzaunderalef; /* U+0625 ARABIC LETTER ALEF WITH HAMZA BELOW */
		public const uint XK_Arabic_hamzaonyeh; /* U+0626 ARABIC LETTER YEH WITH HAMZA ABOVE */
		public const uint XK_Arabic_alef; /* U+0627 ARABIC LETTER ALEF */
		public const uint XK_Arabic_beh; /* U+0628 ARABIC LETTER BEH */
		public const uint XK_Arabic_tehmarbuta; /* U+0629 ARABIC LETTER TEH MARBUTA */
		public const uint XK_Arabic_teh; /* U+062A ARABIC LETTER TEH */
		public const uint XK_Arabic_theh; /* U+062B ARABIC LETTER THEH */
		public const uint XK_Arabic_jeem; /* U+062C ARABIC LETTER JEEM */
		public const uint XK_Arabic_hah; /* U+062D ARABIC LETTER HAH */
		public const uint XK_Arabic_khah; /* U+062E ARABIC LETTER KHAH */
		public const uint XK_Arabic_dal; /* U+062F ARABIC LETTER DAL */
		public const uint XK_Arabic_thal; /* U+0630 ARABIC LETTER THAL */
		public const uint XK_Arabic_ra; /* U+0631 ARABIC LETTER REH */
		public const uint XK_Arabic_zain; /* U+0632 ARABIC LETTER ZAIN */
		public const uint XK_Arabic_seen; /* U+0633 ARABIC LETTER SEEN */
		public const uint XK_Arabic_sheen; /* U+0634 ARABIC LETTER SHEEN */
		public const uint XK_Arabic_sad; /* U+0635 ARABIC LETTER SAD */
		public const uint XK_Arabic_dad; /* U+0636 ARABIC LETTER DAD */
		public const uint XK_Arabic_tah; /* U+0637 ARABIC LETTER TAH */
		public const uint XK_Arabic_zah; /* U+0638 ARABIC LETTER ZAH */
		public const uint XK_Arabic_ain; /* U+0639 ARABIC LETTER AIN */
		public const uint XK_Arabic_ghain; /* U+063A ARABIC LETTER GHAIN */
		public const uint XK_Arabic_tatweel; /* U+0640 ARABIC TATWEEL */
		public const uint XK_Arabic_feh; /* U+0641 ARABIC LETTER FEH */
		public const uint XK_Arabic_qaf; /* U+0642 ARABIC LETTER QAF */
		public const uint XK_Arabic_kaf; /* U+0643 ARABIC LETTER KAF */
		public const uint XK_Arabic_lam; /* U+0644 ARABIC LETTER LAM */
		public const uint XK_Arabic_meem; /* U+0645 ARABIC LETTER MEEM */
		public const uint XK_Arabic_noon; /* U+0646 ARABIC LETTER NOON */
		public const uint XK_Arabic_ha; /* U+0647 ARABIC LETTER HEH */
		public const uint XK_Arabic_heh; /* deprecated */
		public const uint XK_Arabic_waw; /* U+0648 ARABIC LETTER WAW */
		public const uint XK_Arabic_alefmaksura; /* U+0649 ARABIC LETTER ALEF MAKSURA */
		public const uint XK_Arabic_yeh; /* U+064A ARABIC LETTER YEH */
		public const uint XK_Arabic_fathatan; /* U+064B ARABIC FATHATAN */
		public const uint XK_Arabic_dammatan; /* U+064C ARABIC DAMMATAN */
		public const uint XK_Arabic_kasratan; /* U+064D ARABIC KASRATAN */
		public const uint XK_Arabic_fatha; /* U+064E ARABIC FATHA */
		public const uint XK_Arabic_damma; /* U+064F ARABIC DAMMA */
		public const uint XK_Arabic_kasra; /* U+0650 ARABIC KASRA */
		public const uint XK_Arabic_shadda; /* U+0651 ARABIC SHADDA */
		public const uint XK_Arabic_sukun; /* U+0652 ARABIC SUKUN */
		public const uint XK_Arabic_madda_above; /* U+0653 ARABIC MADDAH ABOVE */
		public const uint XK_Arabic_hamza_above; /* U+0654 ARABIC HAMZA ABOVE */
		public const uint XK_Arabic_hamza_below; /* U+0655 ARABIC HAMZA BELOW */
		public const uint XK_Arabic_jeh; /* U+0698 ARABIC LETTER JEH */
		public const uint XK_Arabic_veh; /* U+06A4 ARABIC LETTER VEH */
		public const uint XK_Arabic_keheh; /* U+06A9 ARABIC LETTER KEHEH */
		public const uint XK_Arabic_gaf; /* U+06AF ARABIC LETTER GAF */
		public const uint XK_Arabic_noon_ghunna; /* U+06BA ARABIC LETTER NOON GHUNNA */
		public const uint XK_Arabic_heh_doachashmee; /* U+06BE ARABIC LETTER HEH DOACHASHMEE */
		public const uint XK_Farsi_yeh; /* U+06CC ARABIC LETTER FARSI YEH */
		public const uint XK_Arabic_farsi_yeh; /* U+06CC ARABIC LETTER FARSI YEH */
		public const uint XK_Arabic_yeh_baree; /* U+06D2 ARABIC LETTER YEH BARREE */
		public const uint XK_Arabic_heh_goal; /* U+06C1 ARABIC LETTER HEH GOAL */
		public const uint XK_Arabic_switch; /* Alias for mode_switch */

/*
 * Cyrillic
 * Byte 3 = 6
 */
		public const uint XK_Cyrillic_GHE_bar; /* U+0492 CYRILLIC CAPITAL LETTER GHE WITH STROKE */
		public const uint XK_Cyrillic_ghe_bar; /* U+0493 CYRILLIC SMALL LETTER GHE WITH STROKE */
		public const uint XK_Cyrillic_ZHE_descender; /* U+0496 CYRILLIC CAPITAL LETTER ZHE WITH DESCENDER */
		public const uint XK_Cyrillic_zhe_descender; /* U+0497 CYRILLIC SMALL LETTER ZHE WITH DESCENDER */
		public const uint XK_Cyrillic_KA_descender; /* U+049A CYRILLIC CAPITAL LETTER KA WITH DESCENDER */
		public const uint XK_Cyrillic_ka_descender; /* U+049B CYRILLIC SMALL LETTER KA WITH DESCENDER */
		public const uint XK_Cyrillic_KA_vertstroke; /* U+049C CYRILLIC CAPITAL LETTER KA WITH VERTICAL STROKE */
		public const uint XK_Cyrillic_ka_vertstroke; /* U+049D CYRILLIC SMALL LETTER KA WITH VERTICAL STROKE */
		public const uint XK_Cyrillic_EN_descender; /* U+04A2 CYRILLIC CAPITAL LETTER EN WITH DESCENDER */
		public const uint XK_Cyrillic_en_descender; /* U+04A3 CYRILLIC SMALL LETTER EN WITH DESCENDER */
		public const uint XK_Cyrillic_U_straight; /* U+04AE CYRILLIC CAPITAL LETTER STRAIGHT U */
		public const uint XK_Cyrillic_u_straight; /* U+04AF CYRILLIC SMALL LETTER STRAIGHT U */
		public const uint XK_Cyrillic_U_straight_bar; /* U+04B0 CYRILLIC CAPITAL LETTER STRAIGHT U WITH STROKE */
		public const uint XK_Cyrillic_u_straight_bar; /* U+04B1 CYRILLIC SMALL LETTER STRAIGHT U WITH STROKE */
		public const uint XK_Cyrillic_HA_descender; /* U+04B2 CYRILLIC CAPITAL LETTER HA WITH DESCENDER */
		public const uint XK_Cyrillic_ha_descender; /* U+04B3 CYRILLIC SMALL LETTER HA WITH DESCENDER */
		public const uint XK_Cyrillic_CHE_descender; /* U+04B6 CYRILLIC CAPITAL LETTER CHE WITH DESCENDER */
		public const uint XK_Cyrillic_che_descender; /* U+04B7 CYRILLIC SMALL LETTER CHE WITH DESCENDER */
		public const uint XK_Cyrillic_CHE_vertstroke; /* U+04B8 CYRILLIC CAPITAL LETTER CHE WITH VERTICAL STROKE */
		public const uint XK_Cyrillic_che_vertstroke; /* U+04B9 CYRILLIC SMALL LETTER CHE WITH VERTICAL STROKE */
		public const uint XK_Cyrillic_SHHA; /* U+04BA CYRILLIC CAPITAL LETTER SHHA */
		public const uint XK_Cyrillic_shha; /* U+04BB CYRILLIC SMALL LETTER SHHA */

		public const uint XK_Cyrillic_SCHWA; /* U+04D8 CYRILLIC CAPITAL LETTER SCHWA */
		public const uint XK_Cyrillic_schwa; /* U+04D9 CYRILLIC SMALL LETTER SCHWA */
		public const uint XK_Cyrillic_I_macron; /* U+04E2 CYRILLIC CAPITAL LETTER I WITH MACRON */
		public const uint XK_Cyrillic_i_macron; /* U+04E3 CYRILLIC SMALL LETTER I WITH MACRON */
		public const uint XK_Cyrillic_O_bar; /* U+04E8 CYRILLIC CAPITAL LETTER BARRED O */
		public const uint XK_Cyrillic_o_bar; /* U+04E9 CYRILLIC SMALL LETTER BARRED O */
		public const uint XK_Cyrillic_U_macron; /* U+04EE CYRILLIC CAPITAL LETTER U WITH MACRON */
		public const uint XK_Cyrillic_u_macron; /* U+04EF CYRILLIC SMALL LETTER U WITH MACRON */

		public const uint XK_Serbian_dje; /* U+0452 CYRILLIC SMALL LETTER DJE */
		public const uint XK_Macedonia_gje; /* U+0453 CYRILLIC SMALL LETTER GJE */
		public const uint XK_Cyrillic_io; /* U+0451 CYRILLIC SMALL LETTER IO */
		public const uint XK_Ukrainian_ie; /* U+0454 CYRILLIC SMALL LETTER UKRAINIAN IE */
		public const uint XK_Ukranian_je; /* deprecated */
		public const uint XK_Macedonia_dse; /* U+0455 CYRILLIC SMALL LETTER DZE */
		public const uint XK_Ukrainian_i; /* U+0456 CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I */
		public const uint XK_Ukranian_i; /* deprecated */
		public const uint XK_Ukrainian_yi; /* U+0457 CYRILLIC SMALL LETTER YI */
		public const uint XK_Ukranian_yi; /* deprecated */
		public const uint XK_Cyrillic_je; /* U+0458 CYRILLIC SMALL LETTER JE */
		public const uint XK_Serbian_je; /* deprecated */
		public const uint XK_Cyrillic_lje; /* U+0459 CYRILLIC SMALL LETTER LJE */
		public const uint XK_Serbian_lje; /* deprecated */
		public const uint XK_Cyrillic_nje; /* U+045A CYRILLIC SMALL LETTER NJE */
		public const uint XK_Serbian_nje; /* deprecated */
		public const uint XK_Serbian_tshe; /* U+045B CYRILLIC SMALL LETTER TSHE */
		public const uint XK_Macedonia_kje; /* U+045C CYRILLIC SMALL LETTER KJE */
		public const uint XK_Ukrainian_ghe_with_upturn; /* U+0491 CYRILLIC SMALL LETTER GHE WITH UPTURN */
		public const uint XK_Byelorussian_shortu; /* U+045E CYRILLIC SMALL LETTER SHORT U */
		public const uint XK_Cyrillic_dzhe; /* U+045F CYRILLIC SMALL LETTER DZHE */
		public const uint XK_Serbian_dze; /* deprecated */
		public const uint XK_numerosign; /* U+2116 NUMERO SIGN */
		public const uint XK_Serbian_DJE; /* U+0402 CYRILLIC CAPITAL LETTER DJE */
		public const uint XK_Macedonia_GJE; /* U+0403 CYRILLIC CAPITAL LETTER GJE */
		public const uint XK_Cyrillic_IO; /* U+0401 CYRILLIC CAPITAL LETTER IO */
		public const uint XK_Ukrainian_IE; /* U+0404 CYRILLIC CAPITAL LETTER UKRAINIAN IE */
		public const uint XK_Ukranian_JE; /* deprecated */
		public const uint XK_Macedonia_DSE; /* U+0405 CYRILLIC CAPITAL LETTER DZE */
		public const uint XK_Ukrainian_I; /* U+0406 CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I */
		public const uint XK_Ukranian_I; /* deprecated */
		public const uint XK_Ukrainian_YI; /* U+0407 CYRILLIC CAPITAL LETTER YI */
		public const uint XK_Ukranian_YI; /* deprecated */
		public const uint XK_Cyrillic_JE; /* U+0408 CYRILLIC CAPITAL LETTER JE */
		public const uint XK_Serbian_JE; /* deprecated */
		public const uint XK_Cyrillic_LJE; /* U+0409 CYRILLIC CAPITAL LETTER LJE */
		public const uint XK_Serbian_LJE; /* deprecated */
		public const uint XK_Cyrillic_NJE; /* U+040A CYRILLIC CAPITAL LETTER NJE */
		public const uint XK_Serbian_NJE; /* deprecated */
		public const uint XK_Serbian_TSHE; /* U+040B CYRILLIC CAPITAL LETTER TSHE */
		public const uint XK_Macedonia_KJE; /* U+040C CYRILLIC CAPITAL LETTER KJE */
		public const uint XK_Ukrainian_GHE_WITH_UPTURN; /* U+0490 CYRILLIC CAPITAL LETTER GHE WITH UPTURN */
		public const uint XK_Byelorussian_SHORTU; /* U+040E CYRILLIC CAPITAL LETTER SHORT U */
		public const uint XK_Cyrillic_DZHE; /* U+040F CYRILLIC CAPITAL LETTER DZHE */
		public const uint XK_Serbian_DZE; /* deprecated */
		public const uint XK_Cyrillic_yu; /* U+044E CYRILLIC SMALL LETTER YU */
		public const uint XK_Cyrillic_a; /* U+0430 CYRILLIC SMALL LETTER A */
		public const uint XK_Cyrillic_be; /* U+0431 CYRILLIC SMALL LETTER BE */
		public const uint XK_Cyrillic_tse; /* U+0446 CYRILLIC SMALL LETTER TSE */
		public const uint XK_Cyrillic_de; /* U+0434 CYRILLIC SMALL LETTER DE */
		public const uint XK_Cyrillic_ie; /* U+0435 CYRILLIC SMALL LETTER IE */
		public const uint XK_Cyrillic_ef; /* U+0444 CYRILLIC SMALL LETTER EF */
		public const uint XK_Cyrillic_ghe; /* U+0433 CYRILLIC SMALL LETTER GHE */
		public const uint XK_Cyrillic_ha; /* U+0445 CYRILLIC SMALL LETTER HA */
		public const uint XK_Cyrillic_i; /* U+0438 CYRILLIC SMALL LETTER I */
		public const uint XK_Cyrillic_shorti; /* U+0439 CYRILLIC SMALL LETTER SHORT I */
		public const uint XK_Cyrillic_ka; /* U+043A CYRILLIC SMALL LETTER KA */
		public const uint XK_Cyrillic_el; /* U+043B CYRILLIC SMALL LETTER EL */
		public const uint XK_Cyrillic_em; /* U+043C CYRILLIC SMALL LETTER EM */
		public const uint XK_Cyrillic_en; /* U+043D CYRILLIC SMALL LETTER EN */
		public const uint XK_Cyrillic_o; /* U+043E CYRILLIC SMALL LETTER O */
		public const uint XK_Cyrillic_pe; /* U+043F CYRILLIC SMALL LETTER PE */
		public const uint XK_Cyrillic_ya; /* U+044F CYRILLIC SMALL LETTER YA */
		public const uint XK_Cyrillic_er; /* U+0440 CYRILLIC SMALL LETTER ER */
		public const uint XK_Cyrillic_es; /* U+0441 CYRILLIC SMALL LETTER ES */
		public const uint XK_Cyrillic_te; /* U+0442 CYRILLIC SMALL LETTER TE */
		public const uint XK_Cyrillic_u; /* U+0443 CYRILLIC SMALL LETTER U */
		public const uint XK_Cyrillic_zhe; /* U+0436 CYRILLIC SMALL LETTER ZHE */
		public const uint XK_Cyrillic_ve; /* U+0432 CYRILLIC SMALL LETTER VE */
		public const uint XK_Cyrillic_softsign; /* U+044C CYRILLIC SMALL LETTER SOFT SIGN */
		public const uint XK_Cyrillic_yeru; /* U+044B CYRILLIC SMALL LETTER YERU */
		public const uint XK_Cyrillic_ze; /* U+0437 CYRILLIC SMALL LETTER ZE */
		public const uint XK_Cyrillic_sha; /* U+0448 CYRILLIC SMALL LETTER SHA */
		public const uint XK_Cyrillic_e; /* U+044D CYRILLIC SMALL LETTER E */
		public const uint XK_Cyrillic_shcha; /* U+0449 CYRILLIC SMALL LETTER SHCHA */
		public const uint XK_Cyrillic_che; /* U+0447 CYRILLIC SMALL LETTER CHE */
		public const uint XK_Cyrillic_hardsign; /* U+044A CYRILLIC SMALL LETTER HARD SIGN */
		public const uint XK_Cyrillic_YU; /* U+042E CYRILLIC CAPITAL LETTER YU */
		public const uint XK_Cyrillic_A; /* U+0410 CYRILLIC CAPITAL LETTER A */
		public const uint XK_Cyrillic_BE; /* U+0411 CYRILLIC CAPITAL LETTER BE */
		public const uint XK_Cyrillic_TSE; /* U+0426 CYRILLIC CAPITAL LETTER TSE */
		public const uint XK_Cyrillic_DE; /* U+0414 CYRILLIC CAPITAL LETTER DE */
		public const uint XK_Cyrillic_IE; /* U+0415 CYRILLIC CAPITAL LETTER IE */
		public const uint XK_Cyrillic_EF; /* U+0424 CYRILLIC CAPITAL LETTER EF */
		public const uint XK_Cyrillic_GHE; /* U+0413 CYRILLIC CAPITAL LETTER GHE */
		public const uint XK_Cyrillic_HA; /* U+0425 CYRILLIC CAPITAL LETTER HA */
		public const uint XK_Cyrillic_I; /* U+0418 CYRILLIC CAPITAL LETTER I */
		public const uint XK_Cyrillic_SHORTI; /* U+0419 CYRILLIC CAPITAL LETTER SHORT I */
		public const uint XK_Cyrillic_KA; /* U+041A CYRILLIC CAPITAL LETTER KA */
		public const uint XK_Cyrillic_EL; /* U+041B CYRILLIC CAPITAL LETTER EL */
		public const uint XK_Cyrillic_EM; /* U+041C CYRILLIC CAPITAL LETTER EM */
		public const uint XK_Cyrillic_EN; /* U+041D CYRILLIC CAPITAL LETTER EN */
		public const uint XK_Cyrillic_O; /* U+041E CYRILLIC CAPITAL LETTER O */
		public const uint XK_Cyrillic_PE; /* U+041F CYRILLIC CAPITAL LETTER PE */
		public const uint XK_Cyrillic_YA; /* U+042F CYRILLIC CAPITAL LETTER YA */
		public const uint XK_Cyrillic_ER; /* U+0420 CYRILLIC CAPITAL LETTER ER */
		public const uint XK_Cyrillic_ES; /* U+0421 CYRILLIC CAPITAL LETTER ES */
		public const uint XK_Cyrillic_TE; /* U+0422 CYRILLIC CAPITAL LETTER TE */
		public const uint XK_Cyrillic_U; /* U+0423 CYRILLIC CAPITAL LETTER U */
		public const uint XK_Cyrillic_ZHE; /* U+0416 CYRILLIC CAPITAL LETTER ZHE */
		public const uint XK_Cyrillic_VE; /* U+0412 CYRILLIC CAPITAL LETTER VE */
		public const uint XK_Cyrillic_SOFTSIGN; /* U+042C CYRILLIC CAPITAL LETTER SOFT SIGN */
		public const uint XK_Cyrillic_YERU; /* U+042B CYRILLIC CAPITAL LETTER YERU */
		public const uint XK_Cyrillic_ZE; /* U+0417 CYRILLIC CAPITAL LETTER ZE */
		public const uint XK_Cyrillic_SHA; /* U+0428 CYRILLIC CAPITAL LETTER SHA */
		public const uint XK_Cyrillic_E; /* U+042D CYRILLIC CAPITAL LETTER E */
		public const uint XK_Cyrillic_SHCHA; /* U+0429 CYRILLIC CAPITAL LETTER SHCHA */
		public const uint XK_Cyrillic_CHE; /* U+0427 CYRILLIC CAPITAL LETTER CHE */
		public const uint XK_Cyrillic_HARDSIGN; /* U+042A CYRILLIC CAPITAL LETTER HARD SIGN */

/*
 * Greek
 * (based on an early draft of, and not quite identical to, ISO/IEC 8859-7)
 * Byte 3 = 7
 */

		public const uint XK_Greek_ALPHAaccent; /* U+0386 GREEK CAPITAL LETTER ALPHA WITH TONOS */
		public const uint XK_Greek_EPSILONaccent; /* U+0388 GREEK CAPITAL LETTER EPSILON WITH TONOS */
		public const uint XK_Greek_ETAaccent; /* U+0389 GREEK CAPITAL LETTER ETA WITH TONOS */
		public const uint XK_Greek_IOTAaccent; /* U+038A GREEK CAPITAL LETTER IOTA WITH TONOS */
		public const uint XK_Greek_IOTAdieresis; /* U+03AA GREEK CAPITAL LETTER IOTA WITH DIALYTIKA */
		public const uint XK_Greek_IOTAdiaeresis; /* old typo */
		public const uint XK_Greek_OMICRONaccent; /* U+038C GREEK CAPITAL LETTER OMICRON WITH TONOS */
		public const uint XK_Greek_UPSILONaccent; /* U+038E GREEK CAPITAL LETTER UPSILON WITH TONOS */
		public const uint XK_Greek_UPSILONdieresis; /* U+03AB GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA */
		public const uint XK_Greek_OMEGAaccent; /* U+038F GREEK CAPITAL LETTER OMEGA WITH TONOS */
		public const uint XK_Greek_accentdieresis; /* U+0385 GREEK DIALYTIKA TONOS */
		public const uint XK_Greek_horizbar; /* U+2015 HORIZONTAL BAR */
		public const uint XK_Greek_alphaaccent; /* U+03AC GREEK SMALL LETTER ALPHA WITH TONOS */
		public const uint XK_Greek_epsilonaccent; /* U+03AD GREEK SMALL LETTER EPSILON WITH TONOS */
		public const uint XK_Greek_etaaccent; /* U+03AE GREEK SMALL LETTER ETA WITH TONOS */
		public const uint XK_Greek_iotaaccent; /* U+03AF GREEK SMALL LETTER IOTA WITH TONOS */
		public const uint XK_Greek_iotadieresis; /* U+03CA GREEK SMALL LETTER IOTA WITH DIALYTIKA */
		public const uint XK_Greek_iotaaccentdieresis; /* U+0390 GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS */
		public const uint XK_Greek_omicronaccent; /* U+03CC GREEK SMALL LETTER OMICRON WITH TONOS */
		public const uint XK_Greek_upsilonaccent; /* U+03CD GREEK SMALL LETTER UPSILON WITH TONOS */
		public const uint XK_Greek_upsilondieresis; /* U+03CB GREEK SMALL LETTER UPSILON WITH DIALYTIKA */
		public const uint XK_Greek_upsilonaccentdieresis; /* U+03B0 GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS */
		public const uint XK_Greek_omegaaccent; /* U+03CE GREEK SMALL LETTER OMEGA WITH TONOS */
		public const uint XK_Greek_ALPHA; /* U+0391 GREEK CAPITAL LETTER ALPHA */
		public const uint XK_Greek_BETA; /* U+0392 GREEK CAPITAL LETTER BETA */
		public const uint XK_Greek_GAMMA; /* U+0393 GREEK CAPITAL LETTER GAMMA */
		public const uint XK_Greek_DELTA; /* U+0394 GREEK CAPITAL LETTER DELTA */
		public const uint XK_Greek_EPSILON; /* U+0395 GREEK CAPITAL LETTER EPSILON */
		public const uint XK_Greek_ZETA; /* U+0396 GREEK CAPITAL LETTER ZETA */
		public const uint XK_Greek_ETA; /* U+0397 GREEK CAPITAL LETTER ETA */
		public const uint XK_Greek_THETA; /* U+0398 GREEK CAPITAL LETTER THETA */
		public const uint XK_Greek_IOTA; /* U+0399 GREEK CAPITAL LETTER IOTA */
		public const uint XK_Greek_KAPPA; /* U+039A GREEK CAPITAL LETTER KAPPA */
		public const uint XK_Greek_LAMDA; /* U+039B GREEK CAPITAL LETTER LAMDA */
		public const uint XK_Greek_LAMBDA; /* U+039B GREEK CAPITAL LETTER LAMDA */
		public const uint XK_Greek_MU; /* U+039C GREEK CAPITAL LETTER MU */
		public const uint XK_Greek_NU; /* U+039D GREEK CAPITAL LETTER NU */
		public const uint XK_Greek_XI; /* U+039E GREEK CAPITAL LETTER XI */
		public const uint XK_Greek_OMICRON; /* U+039F GREEK CAPITAL LETTER OMICRON */
		public const uint XK_Greek_PI; /* U+03A0 GREEK CAPITAL LETTER PI */
		public const uint XK_Greek_RHO; /* U+03A1 GREEK CAPITAL LETTER RHO */
		public const uint XK_Greek_SIGMA; /* U+03A3 GREEK CAPITAL LETTER SIGMA */
		public const uint XK_Greek_TAU; /* U+03A4 GREEK CAPITAL LETTER TAU */
		public const uint XK_Greek_UPSILON; /* U+03A5 GREEK CAPITAL LETTER UPSILON */
		public const uint XK_Greek_PHI; /* U+03A6 GREEK CAPITAL LETTER PHI */
		public const uint XK_Greek_CHI; /* U+03A7 GREEK CAPITAL LETTER CHI */
		public const uint XK_Greek_PSI; /* U+03A8 GREEK CAPITAL LETTER PSI */
		public const uint XK_Greek_OMEGA; /* U+03A9 GREEK CAPITAL LETTER OMEGA */
		public const uint XK_Greek_alpha; /* U+03B1 GREEK SMALL LETTER ALPHA */
		public const uint XK_Greek_beta; /* U+03B2 GREEK SMALL LETTER BETA */
		public const uint XK_Greek_gamma; /* U+03B3 GREEK SMALL LETTER GAMMA */
		public const uint XK_Greek_delta; /* U+03B4 GREEK SMALL LETTER DELTA */
		public const uint XK_Greek_epsilon; /* U+03B5 GREEK SMALL LETTER EPSILON */
		public const uint XK_Greek_zeta; /* U+03B6 GREEK SMALL LETTER ZETA */
		public const uint XK_Greek_eta; /* U+03B7 GREEK SMALL LETTER ETA */
		public const uint XK_Greek_theta; /* U+03B8 GREEK SMALL LETTER THETA */
		public const uint XK_Greek_iota; /* U+03B9 GREEK SMALL LETTER IOTA */
		public const uint XK_Greek_kappa; /* U+03BA GREEK SMALL LETTER KAPPA */
		public const uint XK_Greek_lamda; /* U+03BB GREEK SMALL LETTER LAMDA */
		public const uint XK_Greek_lambda; /* U+03BB GREEK SMALL LETTER LAMDA */
		public const uint XK_Greek_mu; /* U+03BC GREEK SMALL LETTER MU */
		public const uint XK_Greek_nu; /* U+03BD GREEK SMALL LETTER NU */
		public const uint XK_Greek_xi; /* U+03BE GREEK SMALL LETTER XI */
		public const uint XK_Greek_omicron; /* U+03BF GREEK SMALL LETTER OMICRON */
		public const uint XK_Greek_pi; /* U+03C0 GREEK SMALL LETTER PI */
		public const uint XK_Greek_rho; /* U+03C1 GREEK SMALL LETTER RHO */
		public const uint XK_Greek_sigma; /* U+03C3 GREEK SMALL LETTER SIGMA */
		public const uint XK_Greek_finalsmallsigma; /* U+03C2 GREEK SMALL LETTER FINAL SIGMA */
		public const uint XK_Greek_tau; /* U+03C4 GREEK SMALL LETTER TAU */
		public const uint XK_Greek_upsilon; /* U+03C5 GREEK SMALL LETTER UPSILON */
		public const uint XK_Greek_phi; /* U+03C6 GREEK SMALL LETTER PHI */
		public const uint XK_Greek_chi; /* U+03C7 GREEK SMALL LETTER CHI */
		public const uint XK_Greek_psi; /* U+03C8 GREEK SMALL LETTER PSI */
		public const uint XK_Greek_omega; /* U+03C9 GREEK SMALL LETTER OMEGA */
		public const uint XK_Greek_switch; /* Alias for mode_switch */

/*
 * Technical
 * (from the DEC VT330/VT420 Technical Character Set, http://vt100.net/charsets/technical.html)
 * Byte 3 = 8
 */

		public const uint XK_leftradical; /* U+23B7 RADICAL SYMBOL BOTTOM */
		public const uint XK_topleftradical; /*(U+250C BOX DRAWINGS LIGHT DOWN AND RIGHT)*/
		public const uint XK_horizconnector; /*(U+2500 BOX DRAWINGS LIGHT HORIZONTAL)*/
		public const uint XK_topintegral; /* U+2320 TOP HALF INTEGRAL */
		public const uint XK_botintegral; /* U+2321 BOTTOM HALF INTEGRAL */
		public const uint XK_vertconnector; /*(U+2502 BOX DRAWINGS LIGHT VERTICAL)*/
		public const uint XK_topleftsqbracket; /* U+23A1 LEFT SQUARE BRACKET UPPER CORNER */
		public const uint XK_botleftsqbracket; /* U+23A3 LEFT SQUARE BRACKET LOWER CORNER */
		public const uint XK_toprightsqbracket; /* U+23A4 RIGHT SQUARE BRACKET UPPER CORNER */
		public const uint XK_botrightsqbracket; /* U+23A6 RIGHT SQUARE BRACKET LOWER CORNER */
		public const uint XK_topleftparens; /* U+239B LEFT PARENTHESIS UPPER HOOK */
		public const uint XK_botleftparens; /* U+239D LEFT PARENTHESIS LOWER HOOK */
		public const uint XK_toprightparens; /* U+239E RIGHT PARENTHESIS UPPER HOOK */
		public const uint XK_botrightparens; /* U+23A0 RIGHT PARENTHESIS LOWER HOOK */
		public const uint XK_leftmiddlecurlybrace; /* U+23A8 LEFT CURLY BRACKET MIDDLE PIECE */
		public const uint XK_rightmiddlecurlybrace; /* U+23AC RIGHT CURLY BRACKET MIDDLE PIECE */
		public const uint XK_topleftsummation;
		public const uint XK_botleftsummation;
		public const uint XK_topvertsummationconnector;
		public const uint XK_botvertsummationconnector;
		public const uint XK_toprightsummation;
		public const uint XK_botrightsummation;
		public const uint XK_rightmiddlesummation;
		public const uint XK_lessthanequal; /* U+2264 LESS-THAN OR EQUAL TO */
		public const uint XK_notequal; /* U+2260 NOT EQUAL TO */
		public const uint XK_greaterthanequal; /* U+2265 GREATER-THAN OR EQUAL TO */
		public const uint XK_integral; /* U+222B INTEGRAL */
		public const uint XK_therefore; /* U+2234 THEREFORE */
		public const uint XK_variation; /* U+221D PROPORTIONAL TO */
		public const uint XK_infinity; /* U+221E INFINITY */
		public const uint XK_nabla; /* U+2207 NABLA */
		public const uint XK_approximate; /* U+223C TILDE OPERATOR */
		public const uint XK_similarequal; /* U+2243 ASYMPTOTICALLY EQUAL TO */
		public const uint XK_ifonlyif; /* U+21D4 LEFT RIGHT DOUBLE ARROW */
		public const uint XK_implies; /* U+21D2 RIGHTWARDS DOUBLE ARROW */
		public const uint XK_identical; /* U+2261 IDENTICAL TO */
		public const uint XK_radical; /* U+221A SQUARE ROOT */
		public const uint XK_includedin; /* U+2282 SUBSET OF */
		public const uint XK_includes; /* U+2283 SUPERSET OF */
		public const uint XK_intersection; /* U+2229 INTERSECTION */
		public const uint XK_union; /* U+222A UNION */
		public const uint XK_logicaland; /* U+2227 LOGICAL AND */
		public const uint XK_logicalor; /* U+2228 LOGICAL OR */
		public const uint XK_partialderivative; /* U+2202 PARTIAL DIFFERENTIAL */
		public const uint XK_function; /* U+0192 LATIN SMALL LETTER F WITH HOOK */
		public const uint XK_leftarrow; /* U+2190 LEFTWARDS ARROW */
		public const uint XK_uparrow; /* U+2191 UPWARDS ARROW */
		public const uint XK_rightarrow; /* U+2192 RIGHTWARDS ARROW */
		public const uint XK_downarrow; /* U+2193 DOWNWARDS ARROW */

/*
 * Special
 * (from the DEC VT100 Special Graphics Character Set)
 * Byte 3 = 9
 */

		public const uint XK_blank;
		public const uint XK_soliddiamond; /* U+25C6 BLACK DIAMOND */
		public const uint XK_checkerboard; /* U+2592 MEDIUM SHADE */
		public const uint XK_ht; /* U+2409 SYMBOL FOR HORIZONTAL TABULATION */
		public const uint XK_ff; /* U+240C SYMBOL FOR FORM FEED */
		public const uint XK_cr; /* U+240D SYMBOL FOR CARRIAGE RETURN */
		public const uint XK_lf; /* U+240A SYMBOL FOR LINE FEED */
		public const uint XK_nl; /* U+2424 SYMBOL FOR NEWLINE */
		public const uint XK_vt; /* U+240B SYMBOL FOR VERTICAL TABULATION */
		public const uint XK_lowrightcorner; /* U+2518 BOX DRAWINGS LIGHT UP AND LEFT */
		public const uint XK_uprightcorner; /* U+2510 BOX DRAWINGS LIGHT DOWN AND LEFT */
		public const uint XK_upleftcorner; /* U+250C BOX DRAWINGS LIGHT DOWN AND RIGHT */
		public const uint XK_lowleftcorner; /* U+2514 BOX DRAWINGS LIGHT UP AND RIGHT */
		public const uint XK_crossinglines; /* U+253C BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL */
		public const uint XK_horizlinescan1; /* U+23BA HORIZONTAL SCAN LINE-1 */
		public const uint XK_horizlinescan3; /* U+23BB HORIZONTAL SCAN LINE-3 */
		public const uint XK_horizlinescan5; /* U+2500 BOX DRAWINGS LIGHT HORIZONTAL */
		public const uint XK_horizlinescan7; /* U+23BC HORIZONTAL SCAN LINE-7 */
		public const uint XK_horizlinescan9; /* U+23BD HORIZONTAL SCAN LINE-9 */
		public const uint XK_leftt; /* U+251C BOX DRAWINGS LIGHT VERTICAL AND RIGHT */
		public const uint XK_rightt; /* U+2524 BOX DRAWINGS LIGHT VERTICAL AND LEFT */
		public const uint XK_bott; /* U+2534 BOX DRAWINGS LIGHT UP AND HORIZONTAL */
		public const uint XK_topt; /* U+252C BOX DRAWINGS LIGHT DOWN AND HORIZONTAL */
		public const uint XK_vertbar; /* U+2502 BOX DRAWINGS LIGHT VERTICAL */

/*
 * Publishing
 * (these are probably from a long forgotten DEC Publishing
 * font that once shipped with DECwrite)
 * Byte 3 =;
 */

		public const uint XK_emspace; /* U+2003 EM SPACE */
		public const uint XK_enspace; /* U+2002 EN SPACE */
		public const uint XK_em3space; /* U+2004 THREE-PER-EM SPACE */
		public const uint XK_em4space; /* U+2005 FOUR-PER-EM SPACE */
		public const uint XK_digitspace; /* U+2007 FIGURE SPACE */
		public const uint XK_punctspace; /* U+2008 PUNCTUATION SPACE */
		public const uint XK_thinspace; /* U+2009 THIN SPACE */
		public const uint XK_hairspace; /* U+200A HAIR SPACE */
		public const uint XK_emdash; /* U+2014 EM DASH */
		public const uint XK_endash; /* U+2013 EN DASH */
		public const uint XK_signifblank; /*(U+2423 OPEN BOX)*/
		public const uint XK_ellipsis; /* U+2026 HORIZONTAL ELLIPSIS */
		public const uint XK_doubbaselinedot; /* U+2025 TWO DOT LEADER */
		public const uint XK_onethird; /* U+2153 VULGAR FRACTION ONE THIRD */
		public const uint XK_twothirds; /* U+2154 VULGAR FRACTION TWO THIRDS */
		public const uint XK_onefifth; /* U+2155 VULGAR FRACTION ONE FIFTH */
		public const uint XK_twofifths; /* U+2156 VULGAR FRACTION TWO FIFTHS */
		public const uint XK_threefifths; /* U+2157 VULGAR FRACTION THREE FIFTHS */
		public const uint XK_fourfifths; /* U+2158 VULGAR FRACTION FOUR FIFTHS */
		public const uint XK_onesixth; /* U+2159 VULGAR FRACTION ONE SIXTH */
		public const uint XK_fivesixths; /* U+215A VULGAR FRACTION FIVE SIXTHS */
		public const uint XK_careof; /* U+2105 CARE OF */
		public const uint XK_figdash; /* U+2012 FIGURE DASH */
		public const uint XK_leftanglebracket; /*(U+27E8 MATHEMATICAL LEFT ANGLE BRACKET)*/
		public const uint XK_decimalpoint; /*(U+002E FULL STOP)*/
		public const uint XK_rightanglebracket; /*(U+27E9 MATHEMATICAL RIGHT ANGLE BRACKET)*/
		public const uint XK_marker;
		public const uint XK_oneeighth; /* U+215B VULGAR FRACTION ONE EIGHTH */
		public const uint XK_threeeighths; /* U+215C VULGAR FRACTION THREE EIGHTHS */
		public const uint XK_fiveeighths; /* U+215D VULGAR FRACTION FIVE EIGHTHS */
		public const uint XK_seveneighths; /* U+215E VULGAR FRACTION SEVEN EIGHTHS */
		public const uint XK_trademark; /* U+2122 TRADE MARK SIGN */
		public const uint XK_signaturemark; /*(U+2613 SALTIRE)*/
		public const uint XK_trademarkincircle;
		public const uint XK_leftopentriangle; /*(U+25C1 WHITE LEFT-POINTING TRIANGLE)*/
		public const uint XK_rightopentriangle; /*(U+25B7 WHITE RIGHT-POINTING TRIANGLE)*/
		public const uint XK_emopencircle; /*(U+25CB WHITE CIRCLE)*/
		public const uint XK_emopenrectangle; /*(U+25AF WHITE VERTICAL RECTANGLE)*/
		public const uint XK_leftsinglequotemark; /* U+2018 LEFT SINGLE QUOTATION MARK */
		public const uint XK_rightsinglequotemark; /* U+2019 RIGHT SINGLE QUOTATION MARK */
		public const uint XK_leftdoublequotemark; /* U+201C LEFT DOUBLE QUOTATION MARK */
		public const uint XK_rightdoublequotemark; /* U+201D RIGHT DOUBLE QUOTATION MARK */
		public const uint XK_prescription; /* U+211E PRESCRIPTION TAKE */
		public const uint XK_minutes; /* U+2032 PRIME */
		public const uint XK_seconds; /* U+2033 DOUBLE PRIME */
		public const uint XK_latincross; /* U+271D LATIN CROSS */
		public const uint XK_hexagram;
		public const uint XK_filledrectbullet; /*(U+25AC BLACK RECTANGLE)*/
		public const uint XK_filledlefttribullet; /*(U+25C0 BLACK LEFT-POINTING TRIANGLE)*/
		public const uint XK_filledrighttribullet; /*(U+25B6 BLACK RIGHT-POINTING TRIANGLE)*/
		public const uint XK_emfilledcircle; /*(U+25CF BLACK CIRCLE)*/
		public const uint XK_emfilledrect; /*(U+25AE BLACK VERTICAL RECTANGLE)*/
		public const uint XK_enopencircbullet; /*(U+25E6 WHITE BULLET)*/
		public const uint XK_enopensquarebullet; /*(U+25AB WHITE SMALL SQUARE)*/
		public const uint XK_openrectbullet; /*(U+25AD WHITE RECTANGLE)*/
		public const uint XK_opentribulletup; /*(U+25B3 WHITE UP-POINTING TRIANGLE)*/
		public const uint XK_opentribulletdown; /*(U+25BD WHITE DOWN-POINTING TRIANGLE)*/
		public const uint XK_openstar; /*(U+2606 WHITE STAR)*/
		public const uint XK_enfilledcircbullet; /*(U+2022 BULLET)*/
		public const uint XK_enfilledsqbullet; /*(U+25AA BLACK SMALL SQUARE)*/
		public const uint XK_filledtribulletup; /*(U+25B2 BLACK UP-POINTING TRIANGLE)*/
		public const uint XK_filledtribulletdown; /*(U+25BC BLACK DOWN-POINTING TRIANGLE)*/
		public const uint XK_leftpointer; /*(U+261C WHITE LEFT POINTING INDEX)*/
		public const uint XK_rightpointer; /*(U+261E WHITE RIGHT POINTING INDEX)*/
		public const uint XK_club; /* U+2663 BLACK CLUB SUIT */
		public const uint XK_diamond; /* U+2666 BLACK DIAMOND SUIT */
		public const uint XK_heart; /* U+2665 BLACK HEART SUIT */
		public const uint XK_maltesecross; /* U+2720 MALTESE CROSS */
		public const uint XK_dagger; /* U+2020 DAGGER */
		public const uint XK_doubledagger; /* U+2021 DOUBLE DAGGER */
		public const uint XK_checkmark; /* U+2713 CHECK MARK */
		public const uint XK_ballotcross; /* U+2717 BALLOT X */
		public const uint XK_musicalsharp; /* U+266F MUSIC SHARP SIGN */
		public const uint XK_musicalflat; /* U+266D MUSIC FLAT SIGN */
		public const uint XK_malesymbol; /* U+2642 MALE SIGN */
		public const uint XK_femalesymbol; /* U+2640 FEMALE SIGN */
		public const uint XK_telephone; /* U+260E BLACK TELEPHONE */
		public const uint XK_telephonerecorder; /* U+2315 TELEPHONE RECORDER */
		public const uint XK_phonographcopyright; /* U+2117 SOUND RECORDING COPYRIGHT */
		public const uint XK_caret; /* U+2038 CARET */
		public const uint XK_singlelowquotemark; /* U+201A SINGLE LOW-9 QUOTATION MARK */
		public const uint XK_doublelowquotemark; /* U+201E DOUBLE LOW-9 QUOTATION MARK */
		public const uint XK_cursor;

/*
 * APL
 * Byte 3 =;
 */

		public const uint XK_leftcaret; /*(U+003C LESS-THAN SIGN)*/
		public const uint XK_rightcaret; /*(U+003E GREATER-THAN SIGN)*/
		public const uint XK_downcaret; /*(U+2228 LOGICAL OR)*/
		public const uint XK_upcaret; /*(U+2227 LOGICAL AND)*/
		public const uint XK_overbar; /*(U+00AF MACRON)*/
		public const uint XK_downtack; /* U+22A4 DOWN TACK */
		public const uint XK_upshoe; /*(U+2229 INTERSECTION)*/
		public const uint XK_downstile; /* U+230A LEFT FLOOR */
		public const uint XK_underbar; /*(U+005F LOW LINE)*/
		public const uint XK_jot; /* U+2218 RING OPERATOR */
		public const uint XK_quad; /* U+2395 APL FUNCTIONAL SYMBOL QUAD */
		public const uint XK_uptack; /* U+22A5 UP TACK */
		public const uint XK_circle; /* U+25CB WHITE CIRCLE */
		public const uint XK_upstile; /* U+2308 LEFT CEILING */
		public const uint XK_downshoe; /*(U+222A UNION)*/
		public const uint XK_rightshoe; /*(U+2283 SUPERSET OF)*/
		public const uint XK_leftshoe; /*(U+2282 SUBSET OF)*/
		public const uint XK_lefttack; /* U+22A3 LEFT TACK */
		public const uint XK_righttack; /* U+22A2 RIGHT TACK */

/*
 * Hebrew
 * Byte 3 =;
 */

		public const uint XK_hebrew_doublelowline; /* U+2017 DOUBLE LOW LINE */
		public const uint XK_hebrew_aleph; /* U+05D0 HEBREW LETTER ALEF */
		public const uint XK_hebrew_bet; /* U+05D1 HEBREW LETTER BET */
		public const uint XK_hebrew_beth; /* deprecated */
		public const uint XK_hebrew_gimel; /* U+05D2 HEBREW LETTER GIMEL */
		public const uint XK_hebrew_gimmel; /* deprecated */
		public const uint XK_hebrew_dalet; /* U+05D3 HEBREW LETTER DALET */
		public const uint XK_hebrew_daleth; /* deprecated */
		public const uint XK_hebrew_he; /* U+05D4 HEBREW LETTER HE */
		public const uint XK_hebrew_waw; /* U+05D5 HEBREW LETTER VAV */
		public const uint XK_hebrew_zain; /* U+05D6 HEBREW LETTER ZAYIN */
		public const uint XK_hebrew_zayin; /* deprecated */
		public const uint XK_hebrew_chet; /* U+05D7 HEBREW LETTER HET */
		public const uint XK_hebrew_het; /* deprecated */
		public const uint XK_hebrew_tet; /* U+05D8 HEBREW LETTER TET */
		public const uint XK_hebrew_teth; /* deprecated */
		public const uint XK_hebrew_yod; /* U+05D9 HEBREW LETTER YOD */
		public const uint XK_hebrew_finalkaph; /* U+05DA HEBREW LETTER FINAL KAF */
		public const uint XK_hebrew_kaph; /* U+05DB HEBREW LETTER KAF */
		public const uint XK_hebrew_lamed; /* U+05DC HEBREW LETTER LAMED */
		public const uint XK_hebrew_finalmem; /* U+05DD HEBREW LETTER FINAL MEM */
		public const uint XK_hebrew_mem; /* U+05DE HEBREW LETTER MEM */
		public const uint XK_hebrew_finalnun; /* U+05DF HEBREW LETTER FINAL NUN */
		public const uint XK_hebrew_nun; /* U+05E0 HEBREW LETTER NUN */
		public const uint XK_hebrew_samech; /* U+05E1 HEBREW LETTER SAMEKH */
		public const uint XK_hebrew_samekh; /* deprecated */
		public const uint XK_hebrew_ayin; /* U+05E2 HEBREW LETTER AYIN */
		public const uint XK_hebrew_finalpe; /* U+05E3 HEBREW LETTER FINAL PE */
		public const uint XK_hebrew_pe; /* U+05E4 HEBREW LETTER PE */
		public const uint XK_hebrew_finalzade; /* U+05E5 HEBREW LETTER FINAL TSADI */
		public const uint XK_hebrew_finalzadi; /* deprecated */
		public const uint XK_hebrew_zade; /* U+05E6 HEBREW LETTER TSADI */
		public const uint XK_hebrew_zadi; /* deprecated */
		public const uint XK_hebrew_qoph; /* U+05E7 HEBREW LETTER QOF */
		public const uint XK_hebrew_kuf; /* deprecated */
		public const uint XK_hebrew_resh; /* U+05E8 HEBREW LETTER RESH */
		public const uint XK_hebrew_shin; /* U+05E9 HEBREW LETTER SHIN */
		public const uint XK_hebrew_taw; /* U+05EA HEBREW LETTER TAV */
		public const uint XK_hebrew_taf; /* deprecated */
		public const uint XK_Hebrew_switch; /* Alias for mode_switch */

/*
 * Thai
 * Byte 3 =;
 */

		public const uint XK_Thai_kokai; /* U+0E01 THAI CHARACTER KO KAI */
		public const uint XK_Thai_khokhai; /* U+0E02 THAI CHARACTER KHO KHAI */
		public const uint XK_Thai_khokhuat; /* U+0E03 THAI CHARACTER KHO KHUAT */
		public const uint XK_Thai_khokhwai; /* U+0E04 THAI CHARACTER KHO KHWAI */
		public const uint XK_Thai_khokhon; /* U+0E05 THAI CHARACTER KHO KHON */
		public const uint XK_Thai_khorakhang; /* U+0E06 THAI CHARACTER KHO RAKHANG */
		public const uint XK_Thai_ngongu; /* U+0E07 THAI CHARACTER NGO NGU */
		public const uint XK_Thai_chochan; /* U+0E08 THAI CHARACTER CHO CHAN */
		public const uint XK_Thai_choching; /* U+0E09 THAI CHARACTER CHO CHING */
		public const uint XK_Thai_chochang; /* U+0E0A THAI CHARACTER CHO CHANG */
		public const uint XK_Thai_soso; /* U+0E0B THAI CHARACTER SO SO */
		public const uint XK_Thai_chochoe; /* U+0E0C THAI CHARACTER CHO CHOE */
		public const uint XK_Thai_yoying; /* U+0E0D THAI CHARACTER YO YING */
		public const uint XK_Thai_dochada; /* U+0E0E THAI CHARACTER DO CHADA */
		public const uint XK_Thai_topatak; /* U+0E0F THAI CHARACTER TO PATAK */
		public const uint XK_Thai_thothan; /* U+0E10 THAI CHARACTER THO THAN */
		public const uint XK_Thai_thonangmontho; /* U+0E11 THAI CHARACTER THO NANGMONTHO */
		public const uint XK_Thai_thophuthao; /* U+0E12 THAI CHARACTER THO PHUTHAO */
		public const uint XK_Thai_nonen; /* U+0E13 THAI CHARACTER NO NEN */
		public const uint XK_Thai_dodek; /* U+0E14 THAI CHARACTER DO DEK */
		public const uint XK_Thai_totao; /* U+0E15 THAI CHARACTER TO TAO */
		public const uint XK_Thai_thothung; /* U+0E16 THAI CHARACTER THO THUNG */
		public const uint XK_Thai_thothahan; /* U+0E17 THAI CHARACTER THO THAHAN */
		public const uint XK_Thai_thothong; /* U+0E18 THAI CHARACTER THO THONG */
		public const uint XK_Thai_nonu; /* U+0E19 THAI CHARACTER NO NU */
		public const uint XK_Thai_bobaimai; /* U+0E1A THAI CHARACTER BO BAIMAI */
		public const uint XK_Thai_popla; /* U+0E1B THAI CHARACTER PO PLA */
		public const uint XK_Thai_phophung; /* U+0E1C THAI CHARACTER PHO PHUNG */
		public const uint XK_Thai_fofa; /* U+0E1D THAI CHARACTER FO FA */
		public const uint XK_Thai_phophan; /* U+0E1E THAI CHARACTER PHO PHAN */
		public const uint XK_Thai_fofan; /* U+0E1F THAI CHARACTER FO FAN */
		public const uint XK_Thai_phosamphao; /* U+0E20 THAI CHARACTER PHO SAMPHAO */
		public const uint XK_Thai_moma; /* U+0E21 THAI CHARACTER MO MA */
		public const uint XK_Thai_yoyak; /* U+0E22 THAI CHARACTER YO YAK */
		public const uint XK_Thai_rorua; /* U+0E23 THAI CHARACTER RO RUA */
		public const uint XK_Thai_ru; /* U+0E24 THAI CHARACTER RU */
		public const uint XK_Thai_loling; /* U+0E25 THAI CHARACTER LO LING */
		public const uint XK_Thai_lu; /* U+0E26 THAI CHARACTER LU */
		public const uint XK_Thai_wowaen; /* U+0E27 THAI CHARACTER WO WAEN */
		public const uint XK_Thai_sosala; /* U+0E28 THAI CHARACTER SO SALA */
		public const uint XK_Thai_sorusi; /* U+0E29 THAI CHARACTER SO RUSI */
		public const uint XK_Thai_sosua; /* U+0E2A THAI CHARACTER SO SUA */
		public const uint XK_Thai_hohip; /* U+0E2B THAI CHARACTER HO HIP */
		public const uint XK_Thai_lochula; /* U+0E2C THAI CHARACTER LO CHULA */
		public const uint XK_Thai_oang; /* U+0E2D THAI CHARACTER O ANG */
		public const uint XK_Thai_honokhuk; /* U+0E2E THAI CHARACTER HO NOKHUK */
		public const uint XK_Thai_paiyannoi; /* U+0E2F THAI CHARACTER PAIYANNOI */
		public const uint XK_Thai_saraa; /* U+0E30 THAI CHARACTER SARA A */
		public const uint XK_Thai_maihanakat; /* U+0E31 THAI CHARACTER MAI HAN-AKAT */
		public const uint XK_Thai_saraaa; /* U+0E32 THAI CHARACTER SARA AA */
		public const uint XK_Thai_saraam; /* U+0E33 THAI CHARACTER SARA AM */
		public const uint XK_Thai_sarai; /* U+0E34 THAI CHARACTER SARA I */
		public const uint XK_Thai_saraii; /* U+0E35 THAI CHARACTER SARA II */
		public const uint XK_Thai_saraue; /* U+0E36 THAI CHARACTER SARA UE */
		public const uint XK_Thai_sarauee; /* U+0E37 THAI CHARACTER SARA UEE */
		public const uint XK_Thai_sarau; /* U+0E38 THAI CHARACTER SARA U */
		public const uint XK_Thai_sarauu; /* U+0E39 THAI CHARACTER SARA UU */
		public const uint XK_Thai_phinthu; /* U+0E3A THAI CHARACTER PHINTHU */
		public const uint XK_Thai_maihanakat_maitho;
		public const uint XK_Thai_baht; /* U+0E3F THAI CURRENCY SYMBOL BAHT */
		public const uint XK_Thai_sarae; /* U+0E40 THAI CHARACTER SARA E */
		public const uint XK_Thai_saraae; /* U+0E41 THAI CHARACTER SARA AE */
		public const uint XK_Thai_sarao; /* U+0E42 THAI CHARACTER SARA O */
		public const uint XK_Thai_saraaimaimuan; /* U+0E43 THAI CHARACTER SARA AI MAIMUAN */
		public const uint XK_Thai_saraaimaimalai; /* U+0E44 THAI CHARACTER SARA AI MAIMALAI */
		public const uint XK_Thai_lakkhangyao; /* U+0E45 THAI CHARACTER LAKKHANGYAO */
		public const uint XK_Thai_maiyamok; /* U+0E46 THAI CHARACTER MAIYAMOK */
		public const uint XK_Thai_maitaikhu; /* U+0E47 THAI CHARACTER MAITAIKHU */
		public const uint XK_Thai_maiek; /* U+0E48 THAI CHARACTER MAI EK */
		public const uint XK_Thai_maitho; /* U+0E49 THAI CHARACTER MAI THO */
		public const uint XK_Thai_maitri; /* U+0E4A THAI CHARACTER MAI TRI */
		public const uint XK_Thai_maichattawa; /* U+0E4B THAI CHARACTER MAI CHATTAWA */
		public const uint XK_Thai_thanthakhat; /* U+0E4C THAI CHARACTER THANTHAKHAT */
		public const uint XK_Thai_nikhahit; /* U+0E4D THAI CHARACTER NIKHAHIT */
		public const uint XK_Thai_leksun; /* U+0E50 THAI DIGIT ZERO */
		public const uint XK_Thai_leknung; /* U+0E51 THAI DIGIT ONE */
		public const uint XK_Thai_leksong; /* U+0E52 THAI DIGIT TWO */
		public const uint XK_Thai_leksam; /* U+0E53 THAI DIGIT THREE */
		public const uint XK_Thai_leksi; /* U+0E54 THAI DIGIT FOUR */
		public const uint XK_Thai_lekha; /* U+0E55 THAI DIGIT FIVE */
		public const uint XK_Thai_lekhok; /* U+0E56 THAI DIGIT SIX */
		public const uint XK_Thai_lekchet; /* U+0E57 THAI DIGIT SEVEN */
		public const uint XK_Thai_lekpaet; /* U+0E58 THAI DIGIT EIGHT */
		public const uint XK_Thai_lekkao; /* U+0E59 THAI DIGIT NINE */

/*
 * Korean
 * Byte 3 =;
 */


		public const uint XK_Hangul; /* Hangul start/stop(toggle) */
		public const uint XK_Hangul_Start; /* Hangul start */
		public const uint XK_Hangul_End; /* Hangul end, English start */
		public const uint XK_Hangul_Hanja; /* Start Hangul->Hanja Conversion */
		public const uint XK_Hangul_Jamo; /* Hangul Jamo mode */
		public const uint XK_Hangul_Romaja; /* Hangul Romaja mode */
		public const uint XK_Hangul_Codeinput; /* Hangul code input mode */
		public const uint XK_Hangul_Jeonja; /* Jeonja mode */
		public const uint XK_Hangul_Banja; /* Banja mode */
		public const uint XK_Hangul_PreHanja; /* Pre Hanja conversion */
		public const uint XK_Hangul_PostHanja; /* Post Hanja conversion */
		public const uint XK_Hangul_SingleCandidate; /* Single candidate */
		public const uint XK_Hangul_MultipleCandidate; /* Multiple candidate */
		public const uint XK_Hangul_PreviousCandidate; /* Previous candidate */
		public const uint XK_Hangul_Special; /* Special symbols */
		public const uint XK_Hangul_switch; /* Alias for mode_switch */

/* Hangul Consonant Characters */
		public const uint XK_Hangul_Kiyeog;
		public const uint XK_Hangul_SsangKiyeog;
		public const uint XK_Hangul_KiyeogSios;
		public const uint XK_Hangul_Nieun;
		public const uint XK_Hangul_NieunJieuj;
		public const uint XK_Hangul_NieunHieuh;
		public const uint XK_Hangul_Dikeud;
		public const uint XK_Hangul_SsangDikeud;
		public const uint XK_Hangul_Rieul;
		public const uint XK_Hangul_RieulKiyeog;
		public const uint XK_Hangul_RieulMieum;
		public const uint XK_Hangul_RieulPieub;
		public const uint XK_Hangul_RieulSios;
		public const uint XK_Hangul_RieulTieut;
		public const uint XK_Hangul_RieulPhieuf;
		public const uint XK_Hangul_RieulHieuh;
		public const uint XK_Hangul_Mieum;
		public const uint XK_Hangul_Pieub;
		public const uint XK_Hangul_SsangPieub;
		public const uint XK_Hangul_PieubSios;
		public const uint XK_Hangul_Sios;
		public const uint XK_Hangul_SsangSios;
		public const uint XK_Hangul_Ieung;
		public const uint XK_Hangul_Jieuj;
		public const uint XK_Hangul_SsangJieuj;
		public const uint XK_Hangul_Cieuc;
		public const uint XK_Hangul_Khieuq;
		public const uint XK_Hangul_Tieut;
		public const uint XK_Hangul_Phieuf;
		public const uint XK_Hangul_Hieuh;

/* Hangul Vowel Characters */
		public const uint XK_Hangul_A;
		public const uint XK_Hangul_AE;
		public const uint XK_Hangul_YA;
		public const uint XK_Hangul_YAE;
		public const uint XK_Hangul_EO;
		public const uint XK_Hangul_E;
		public const uint XK_Hangul_YEO;
		public const uint XK_Hangul_YE;
		public const uint XK_Hangul_O;
		public const uint XK_Hangul_WA;
		public const uint XK_Hangul_WAE;
		public const uint XK_Hangul_OE;
		public const uint XK_Hangul_YO;
		public const uint XK_Hangul_U;
		public const uint XK_Hangul_WEO;
		public const uint XK_Hangul_WE;
		public const uint XK_Hangul_WI;
		public const uint XK_Hangul_YU;
		public const uint XK_Hangul_EU;
		public const uint XK_Hangul_YI;
		public const uint XK_Hangul_I;

/* Hangul syllable-final (JongSeong) Characters */
		public const uint XK_Hangul_J_Kiyeog;
		public const uint XK_Hangul_J_SsangKiyeog;
		public const uint XK_Hangul_J_KiyeogSios;
		public const uint XK_Hangul_J_Nieun;
		public const uint XK_Hangul_J_NieunJieuj;
		public const uint XK_Hangul_J_NieunHieuh;
		public const uint XK_Hangul_J_Dikeud;
		public const uint XK_Hangul_J_Rieul;
		public const uint XK_Hangul_J_RieulKiyeog;
		public const uint XK_Hangul_J_RieulMieum;
		public const uint XK_Hangul_J_RieulPieub;
		public const uint XK_Hangul_J_RieulSios;
		public const uint XK_Hangul_J_RieulTieut;
		public const uint XK_Hangul_J_RieulPhieuf;
		public const uint XK_Hangul_J_RieulHieuh;
		public const uint XK_Hangul_J_Mieum;
		public const uint XK_Hangul_J_Pieub;
		public const uint XK_Hangul_J_PieubSios;
		public const uint XK_Hangul_J_Sios;
		public const uint XK_Hangul_J_SsangSios;
		public const uint XK_Hangul_J_Ieung;
		public const uint XK_Hangul_J_Jieuj;
		public const uint XK_Hangul_J_Cieuc;
		public const uint XK_Hangul_J_Khieuq;
		public const uint XK_Hangul_J_Tieut;
		public const uint XK_Hangul_J_Phieuf;
		public const uint XK_Hangul_J_Hieuh;

/* Ancient Hangul Consonant Characters */
		public const uint XK_Hangul_RieulYeorinHieuh;
		public const uint XK_Hangul_SunkyeongeumMieum;
		public const uint XK_Hangul_SunkyeongeumPieub;
		public const uint XK_Hangul_PanSios;
		public const uint XK_Hangul_KkogjiDalrinIeung;
		public const uint XK_Hangul_SunkyeongeumPhieuf;
		public const uint XK_Hangul_YeorinHieuh;

/* Ancient Hangul Vowel Characters */
		public const uint XK_Hangul_AraeA;
		public const uint XK_Hangul_AraeAE;

/* Ancient Hangul syllable-final (JongSeong) Characters */
		public const uint XK_Hangul_J_PanSios;
		public const uint XK_Hangul_J_KkogjiDalrinIeung;
		public const uint XK_Hangul_J_YeorinHieuh;

/* Korean currency symbol */
		public const uint XK_Korean_Won; /*(U+20A9 WON SIGN)*/


/*
 * Armenian
 */

		public const uint XK_Armenian_ligature_ew; /* U+0587 ARMENIAN SMALL LIGATURE ECH YIWN */
		public const uint XK_Armenian_full_stop; /* U+0589 ARMENIAN FULL STOP */
		public const uint XK_Armenian_verjaket; /* U+0589 ARMENIAN FULL STOP */
		public const uint XK_Armenian_separation_mark; /* U+055D ARMENIAN COMMA */
		public const uint XK_Armenian_but; /* U+055D ARMENIAN COMMA */
		public const uint XK_Armenian_hyphen; /* U+058A ARMENIAN HYPHEN */
		public const uint XK_Armenian_yentamna; /* U+058A ARMENIAN HYPHEN */
		public const uint XK_Armenian_exclam; /* U+055C ARMENIAN EXCLAMATION MARK */
		public const uint XK_Armenian_amanak; /* U+055C ARMENIAN EXCLAMATION MARK */
		public const uint XK_Armenian_accent; /* U+055B ARMENIAN EMPHASIS MARK */
		public const uint XK_Armenian_shesht; /* U+055B ARMENIAN EMPHASIS MARK */
		public const uint XK_Armenian_question; /* U+055E ARMENIAN QUESTION MARK */
		public const uint XK_Armenian_paruyk; /* U+055E ARMENIAN QUESTION MARK */
		public const uint XK_Armenian_AYB; /* U+0531 ARMENIAN CAPITAL LETTER AYB */
		public const uint XK_Armenian_ayb; /* U+0561 ARMENIAN SMALL LETTER AYB */
		public const uint XK_Armenian_BEN; /* U+0532 ARMENIAN CAPITAL LETTER BEN */
		public const uint XK_Armenian_ben; /* U+0562 ARMENIAN SMALL LETTER BEN */
		public const uint XK_Armenian_GIM; /* U+0533 ARMENIAN CAPITAL LETTER GIM */
		public const uint XK_Armenian_gim; /* U+0563 ARMENIAN SMALL LETTER GIM */
		public const uint XK_Armenian_DA; /* U+0534 ARMENIAN CAPITAL LETTER DA */
		public const uint XK_Armenian_da; /* U+0564 ARMENIAN SMALL LETTER DA */
		public const uint XK_Armenian_YECH; /* U+0535 ARMENIAN CAPITAL LETTER ECH */
		public const uint XK_Armenian_yech; /* U+0565 ARMENIAN SMALL LETTER ECH */
		public const uint XK_Armenian_ZA; /* U+0536 ARMENIAN CAPITAL LETTER ZA */
		public const uint XK_Armenian_za; /* U+0566 ARMENIAN SMALL LETTER ZA */
		public const uint XK_Armenian_E; /* U+0537 ARMENIAN CAPITAL LETTER EH */
		public const uint XK_Armenian_e; /* U+0567 ARMENIAN SMALL LETTER EH */
		public const uint XK_Armenian_AT; /* U+0538 ARMENIAN CAPITAL LETTER ET */
		public const uint XK_Armenian_at; /* U+0568 ARMENIAN SMALL LETTER ET */
		public const uint XK_Armenian_TO; /* U+0539 ARMENIAN CAPITAL LETTER TO */
		public const uint XK_Armenian_to; /* U+0569 ARMENIAN SMALL LETTER TO */
		public const uint XK_Armenian_ZHE; /* U+053A ARMENIAN CAPITAL LETTER ZHE */
		public const uint XK_Armenian_zhe; /* U+056A ARMENIAN SMALL LETTER ZHE */
		public const uint XK_Armenian_INI; /* U+053B ARMENIAN CAPITAL LETTER INI */
		public const uint XK_Armenian_ini; /* U+056B ARMENIAN SMALL LETTER INI */
		public const uint XK_Armenian_LYUN; /* U+053C ARMENIAN CAPITAL LETTER LIWN */
		public const uint XK_Armenian_lyun; /* U+056C ARMENIAN SMALL LETTER LIWN */
		public const uint XK_Armenian_KHE; /* U+053D ARMENIAN CAPITAL LETTER XEH */
		public const uint XK_Armenian_khe; /* U+056D ARMENIAN SMALL LETTER XEH */
		public const uint XK_Armenian_TSA; /* U+053E ARMENIAN CAPITAL LETTER CA */
		public const uint XK_Armenian_tsa; /* U+056E ARMENIAN SMALL LETTER CA */
		public const uint XK_Armenian_KEN; /* U+053F ARMENIAN CAPITAL LETTER KEN */
		public const uint XK_Armenian_ken; /* U+056F ARMENIAN SMALL LETTER KEN */
		public const uint XK_Armenian_HO; /* U+0540 ARMENIAN CAPITAL LETTER HO */
		public const uint XK_Armenian_ho; /* U+0570 ARMENIAN SMALL LETTER HO */
		public const uint XK_Armenian_DZA; /* U+0541 ARMENIAN CAPITAL LETTER JA */
		public const uint XK_Armenian_dza; /* U+0571 ARMENIAN SMALL LETTER JA */
		public const uint XK_Armenian_GHAT; /* U+0542 ARMENIAN CAPITAL LETTER GHAD */
		public const uint XK_Armenian_ghat; /* U+0572 ARMENIAN SMALL LETTER GHAD */
		public const uint XK_Armenian_TCHE; /* U+0543 ARMENIAN CAPITAL LETTER CHEH */
		public const uint XK_Armenian_tche; /* U+0573 ARMENIAN SMALL LETTER CHEH */
		public const uint XK_Armenian_MEN; /* U+0544 ARMENIAN CAPITAL LETTER MEN */
		public const uint XK_Armenian_men; /* U+0574 ARMENIAN SMALL LETTER MEN */
		public const uint XK_Armenian_HI; /* U+0545 ARMENIAN CAPITAL LETTER YI */
		public const uint XK_Armenian_hi; /* U+0575 ARMENIAN SMALL LETTER YI */
		public const uint XK_Armenian_NU; /* U+0546 ARMENIAN CAPITAL LETTER NOW */
		public const uint XK_Armenian_nu; /* U+0576 ARMENIAN SMALL LETTER NOW */
		public const uint XK_Armenian_SHA; /* U+0547 ARMENIAN CAPITAL LETTER SHA */
		public const uint XK_Armenian_sha; /* U+0577 ARMENIAN SMALL LETTER SHA */
		public const uint XK_Armenian_VO; /* U+0548 ARMENIAN CAPITAL LETTER VO */
		public const uint XK_Armenian_vo; /* U+0578 ARMENIAN SMALL LETTER VO */
		public const uint XK_Armenian_CHA; /* U+0549 ARMENIAN CAPITAL LETTER CHA */
		public const uint XK_Armenian_cha; /* U+0579 ARMENIAN SMALL LETTER CHA */
		public const uint XK_Armenian_PE; /* U+054A ARMENIAN CAPITAL LETTER PEH */
		public const uint XK_Armenian_pe; /* U+057A ARMENIAN SMALL LETTER PEH */
		public const uint XK_Armenian_JE; /* U+054B ARMENIAN CAPITAL LETTER JHEH */
		public const uint XK_Armenian_je; /* U+057B ARMENIAN SMALL LETTER JHEH */
		public const uint XK_Armenian_RA; /* U+054C ARMENIAN CAPITAL LETTER RA */
		public const uint XK_Armenian_ra; /* U+057C ARMENIAN SMALL LETTER RA */
		public const uint XK_Armenian_SE; /* U+054D ARMENIAN CAPITAL LETTER SEH */
		public const uint XK_Armenian_se; /* U+057D ARMENIAN SMALL LETTER SEH */
		public const uint XK_Armenian_VEV; /* U+054E ARMENIAN CAPITAL LETTER VEW */
		public const uint XK_Armenian_vev; /* U+057E ARMENIAN SMALL LETTER VEW */
		public const uint XK_Armenian_TYUN; /* U+054F ARMENIAN CAPITAL LETTER TIWN */
		public const uint XK_Armenian_tyun; /* U+057F ARMENIAN SMALL LETTER TIWN */
		public const uint XK_Armenian_RE; /* U+0550 ARMENIAN CAPITAL LETTER REH */
		public const uint XK_Armenian_re; /* U+0580 ARMENIAN SMALL LETTER REH */
		public const uint XK_Armenian_TSO; /* U+0551 ARMENIAN CAPITAL LETTER CO */
		public const uint XK_Armenian_tso; /* U+0581 ARMENIAN SMALL LETTER CO */
		public const uint XK_Armenian_VYUN; /* U+0552 ARMENIAN CAPITAL LETTER YIWN */
		public const uint XK_Armenian_vyun; /* U+0582 ARMENIAN SMALL LETTER YIWN */
		public const uint XK_Armenian_PYUR; /* U+0553 ARMENIAN CAPITAL LETTER PIWR */
		public const uint XK_Armenian_pyur; /* U+0583 ARMENIAN SMALL LETTER PIWR */
		public const uint XK_Armenian_KE; /* U+0554 ARMENIAN CAPITAL LETTER KEH */
		public const uint XK_Armenian_ke; /* U+0584 ARMENIAN SMALL LETTER KEH */
		public const uint XK_Armenian_O; /* U+0555 ARMENIAN CAPITAL LETTER OH */
		public const uint XK_Armenian_o; /* U+0585 ARMENIAN SMALL LETTER OH */
		public const uint XK_Armenian_FE; /* U+0556 ARMENIAN CAPITAL LETTER FEH */
		public const uint XK_Armenian_fe; /* U+0586 ARMENIAN SMALL LETTER FEH */
		public const uint XK_Armenian_apostrophe; /* U+055A ARMENIAN APOSTROPHE */

/*
 * Georgian
 */

		public const uint XK_Georgian_an; /* U+10D0 GEORGIAN LETTER AN */
		public const uint XK_Georgian_ban; /* U+10D1 GEORGIAN LETTER BAN */
		public const uint XK_Georgian_gan; /* U+10D2 GEORGIAN LETTER GAN */
		public const uint XK_Georgian_don; /* U+10D3 GEORGIAN LETTER DON */
		public const uint XK_Georgian_en; /* U+10D4 GEORGIAN LETTER EN */
		public const uint XK_Georgian_vin; /* U+10D5 GEORGIAN LETTER VIN */
		public const uint XK_Georgian_zen; /* U+10D6 GEORGIAN LETTER ZEN */
		public const uint XK_Georgian_tan; /* U+10D7 GEORGIAN LETTER TAN */
		public const uint XK_Georgian_in; /* U+10D8 GEORGIAN LETTER IN */
		public const uint XK_Georgian_kan; /* U+10D9 GEORGIAN LETTER KAN */
		public const uint XK_Georgian_las; /* U+10DA GEORGIAN LETTER LAS */
		public const uint XK_Georgian_man; /* U+10DB GEORGIAN LETTER MAN */
		public const uint XK_Georgian_nar; /* U+10DC GEORGIAN LETTER NAR */
		public const uint XK_Georgian_on; /* U+10DD GEORGIAN LETTER ON */
		public const uint XK_Georgian_par; /* U+10DE GEORGIAN LETTER PAR */
		public const uint XK_Georgian_zhar; /* U+10DF GEORGIAN LETTER ZHAR */
		public const uint XK_Georgian_rae; /* U+10E0 GEORGIAN LETTER RAE */
		public const uint XK_Georgian_san; /* U+10E1 GEORGIAN LETTER SAN */
		public const uint XK_Georgian_tar; /* U+10E2 GEORGIAN LETTER TAR */
		public const uint XK_Georgian_un; /* U+10E3 GEORGIAN LETTER UN */
		public const uint XK_Georgian_phar; /* U+10E4 GEORGIAN LETTER PHAR */
		public const uint XK_Georgian_khar; /* U+10E5 GEORGIAN LETTER KHAR */
		public const uint XK_Georgian_ghan; /* U+10E6 GEORGIAN LETTER GHAN */
		public const uint XK_Georgian_qar; /* U+10E7 GEORGIAN LETTER QAR */
		public const uint XK_Georgian_shin; /* U+10E8 GEORGIAN LETTER SHIN */
		public const uint XK_Georgian_chin; /* U+10E9 GEORGIAN LETTER CHIN */
		public const uint XK_Georgian_can; /* U+10EA GEORGIAN LETTER CAN */
		public const uint XK_Georgian_jil; /* U+10EB GEORGIAN LETTER JIL */
		public const uint XK_Georgian_cil; /* U+10EC GEORGIAN LETTER CIL */
		public const uint XK_Georgian_char; /* U+10ED GEORGIAN LETTER CHAR */
		public const uint XK_Georgian_xan; /* U+10EE GEORGIAN LETTER XAN */
		public const uint XK_Georgian_jhan; /* U+10EF GEORGIAN LETTER JHAN */
		public const uint XK_Georgian_hae; /* U+10F0 GEORGIAN LETTER HAE */
		public const uint XK_Georgian_he; /* U+10F1 GEORGIAN LETTER HE */
		public const uint XK_Georgian_hie; /* U+10F2 GEORGIAN LETTER HIE */
		public const uint XK_Georgian_we; /* U+10F3 GEORGIAN LETTER WE */
		public const uint XK_Georgian_har; /* U+10F4 GEORGIAN LETTER HAR */
		public const uint XK_Georgian_hoe; /* U+10F5 GEORGIAN LETTER HOE */
		public const uint XK_Georgian_fi; /* U+10F6 GEORGIAN LETTER FI */

/*
 * Azeri (and other Turkic or Caucasian languages)
 */

/* latin */
		public const uint XK_Xabovedot; /* U+1E8A LATIN CAPITAL LETTER X WITH DOT ABOVE */
		public const uint XK_Ibreve; /* U+012C LATIN CAPITAL LETTER I WITH BREVE */
		public const uint XK_Zstroke; /* U+01B5 LATIN CAPITAL LETTER Z WITH STROKE */
		public const uint XK_Gcaron; /* U+01E6 LATIN CAPITAL LETTER G WITH CARON */
		public const uint XK_Ocaron; /* U+01D2 LATIN CAPITAL LETTER O WITH CARON */
		public const uint XK_Obarred; /* U+019F LATIN CAPITAL LETTER O WITH MIDDLE TILDE */
		public const uint XK_xabovedot; /* U+1E8B LATIN SMALL LETTER X WITH DOT ABOVE */
		public const uint XK_ibreve; /* U+012D LATIN SMALL LETTER I WITH BREVE */
		public const uint XK_zstroke; /* U+01B6 LATIN SMALL LETTER Z WITH STROKE */
		public const uint XK_gcaron; /* U+01E7 LATIN SMALL LETTER G WITH CARON */
		public const uint XK_ocaron; /* U+01D2 LATIN SMALL LETTER O WITH CARON */
		public const uint XK_obarred; /* U+0275 LATIN SMALL LETTER BARRED O */
		public const uint XK_SCHWA; /* U+018F LATIN CAPITAL LETTER SCHWA */
		public const uint XK_schwa; /* U+0259 LATIN SMALL LETTER SCHWA */
/* those are not really Caucasus */
/* For Inupiak */
		public const uint XK_Lbelowdot; /* U+1E36 LATIN CAPITAL LETTER L WITH DOT BELOW */
		public const uint XK_lbelowdot; /* U+1E37 LATIN SMALL LETTER L WITH DOT BELOW */

/*
 * Vietnamese
 */
 
		public const uint XK_Abelowdot; /* U+1EA0 LATIN CAPITAL LETTER A WITH DOT BELOW */
		public const uint XK_abelowdot; /* U+1EA1 LATIN SMALL LETTER A WITH DOT BELOW */
		public const uint XK_Ahook; /* U+1EA2 LATIN CAPITAL LETTER A WITH HOOK ABOVE */
		public const uint XK_ahook; /* U+1EA3 LATIN SMALL LETTER A WITH HOOK ABOVE */
		public const uint XK_Acircumflexacute; /* U+1EA4 LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND ACUTE */
		public const uint XK_acircumflexacute; /* U+1EA5 LATIN SMALL LETTER A WITH CIRCUMFLEX AND ACUTE */
		public const uint XK_Acircumflexgrave; /* U+1EA6 LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND GRAVE */
		public const uint XK_acircumflexgrave; /* U+1EA7 LATIN SMALL LETTER A WITH CIRCUMFLEX AND GRAVE */
		public const uint XK_Acircumflexhook; /* U+1EA8 LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND HOOK ABOVE */
		public const uint XK_acircumflexhook; /* U+1EA9 LATIN SMALL LETTER A WITH CIRCUMFLEX AND HOOK ABOVE */
		public const uint XK_Acircumflextilde; /* U+1EAA LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND TILDE */
		public const uint XK_acircumflextilde; /* U+1EAB LATIN SMALL LETTER A WITH CIRCUMFLEX AND TILDE */
		public const uint XK_Acircumflexbelowdot; /* U+1EAC LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND DOT BELOW */
		public const uint XK_acircumflexbelowdot; /* U+1EAD LATIN SMALL LETTER A WITH CIRCUMFLEX AND DOT BELOW */
		public const uint XK_Abreveacute; /* U+1EAE LATIN CAPITAL LETTER A WITH BREVE AND ACUTE */
		public const uint XK_abreveacute; /* U+1EAF LATIN SMALL LETTER A WITH BREVE AND ACUTE */
		public const uint XK_Abrevegrave; /* U+1EB0 LATIN CAPITAL LETTER A WITH BREVE AND GRAVE */
		public const uint XK_abrevegrave; /* U+1EB1 LATIN SMALL LETTER A WITH BREVE AND GRAVE */
		public const uint XK_Abrevehook; /* U+1EB2 LATIN CAPITAL LETTER A WITH BREVE AND HOOK ABOVE */
		public const uint XK_abrevehook; /* U+1EB3 LATIN SMALL LETTER A WITH BREVE AND HOOK ABOVE */
		public const uint XK_Abrevetilde; /* U+1EB4 LATIN CAPITAL LETTER A WITH BREVE AND TILDE */
		public const uint XK_abrevetilde; /* U+1EB5 LATIN SMALL LETTER A WITH BREVE AND TILDE */
		public const uint XK_Abrevebelowdot; /* U+1EB6 LATIN CAPITAL LETTER A WITH BREVE AND DOT BELOW */
		public const uint XK_abrevebelowdot; /* U+1EB7 LATIN SMALL LETTER A WITH BREVE AND DOT BELOW */
		public const uint XK_Ebelowdot; /* U+1EB8 LATIN CAPITAL LETTER E WITH DOT BELOW */
		public const uint XK_ebelowdot; /* U+1EB9 LATIN SMALL LETTER E WITH DOT BELOW */
		public const uint XK_Ehook; /* U+1EBA LATIN CAPITAL LETTER E WITH HOOK ABOVE */
		public const uint XK_ehook; /* U+1EBB LATIN SMALL LETTER E WITH HOOK ABOVE */
		public const uint XK_Etilde; /* U+1EBC LATIN CAPITAL LETTER E WITH TILDE */
		public const uint XK_etilde; /* U+1EBD LATIN SMALL LETTER E WITH TILDE */
		public const uint XK_Ecircumflexacute; /* U+1EBE LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND ACUTE */
		public const uint XK_ecircumflexacute; /* U+1EBF LATIN SMALL LETTER E WITH CIRCUMFLEX AND ACUTE */
		public const uint XK_Ecircumflexgrave; /* U+1EC0 LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND GRAVE */
		public const uint XK_ecircumflexgrave; /* U+1EC1 LATIN SMALL LETTER E WITH CIRCUMFLEX AND GRAVE */
		public const uint XK_Ecircumflexhook; /* U+1EC2 LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND HOOK ABOVE */
		public const uint XK_ecircumflexhook; /* U+1EC3 LATIN SMALL LETTER E WITH CIRCUMFLEX AND HOOK ABOVE */
		public const uint XK_Ecircumflextilde; /* U+1EC4 LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND TILDE */
		public const uint XK_ecircumflextilde; /* U+1EC5 LATIN SMALL LETTER E WITH CIRCUMFLEX AND TILDE */
		public const uint XK_Ecircumflexbelowdot; /* U+1EC6 LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND DOT BELOW */
		public const uint XK_ecircumflexbelowdot; /* U+1EC7 LATIN SMALL LETTER E WITH CIRCUMFLEX AND DOT BELOW */
		public const uint XK_Ihook; /* U+1EC8 LATIN CAPITAL LETTER I WITH HOOK ABOVE */
		public const uint XK_ihook; /* U+1EC9 LATIN SMALL LETTER I WITH HOOK ABOVE */
		public const uint XK_Ibelowdot; /* U+1ECA LATIN CAPITAL LETTER I WITH DOT BELOW */
		public const uint XK_ibelowdot; /* U+1ECB LATIN SMALL LETTER I WITH DOT BELOW */
		public const uint XK_Obelowdot; /* U+1ECC LATIN CAPITAL LETTER O WITH DOT BELOW */
		public const uint XK_obelowdot; /* U+1ECD LATIN SMALL LETTER O WITH DOT BELOW */
		public const uint XK_Ohook; /* U+1ECE LATIN CAPITAL LETTER O WITH HOOK ABOVE */
		public const uint XK_ohook; /* U+1ECF LATIN SMALL LETTER O WITH HOOK ABOVE */
		public const uint XK_Ocircumflexacute; /* U+1ED0 LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND ACUTE */
		public const uint XK_ocircumflexacute; /* U+1ED1 LATIN SMALL LETTER O WITH CIRCUMFLEX AND ACUTE */
		public const uint XK_Ocircumflexgrave; /* U+1ED2 LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND GRAVE */
		public const uint XK_ocircumflexgrave; /* U+1ED3 LATIN SMALL LETTER O WITH CIRCUMFLEX AND GRAVE */
		public const uint XK_Ocircumflexhook; /* U+1ED4 LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND HOOK ABOVE */
		public const uint XK_ocircumflexhook; /* U+1ED5 LATIN SMALL LETTER O WITH CIRCUMFLEX AND HOOK ABOVE */
		public const uint XK_Ocircumflextilde; /* U+1ED6 LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND TILDE */
		public const uint XK_ocircumflextilde; /* U+1ED7 LATIN SMALL LETTER O WITH CIRCUMFLEX AND TILDE */
		public const uint XK_Ocircumflexbelowdot; /* U+1ED8 LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND DOT BELOW */
		public const uint XK_ocircumflexbelowdot; /* U+1ED9 LATIN SMALL LETTER O WITH CIRCUMFLEX AND DOT BELOW */
		public const uint XK_Ohornacute; /* U+1EDA LATIN CAPITAL LETTER O WITH HORN AND ACUTE */
		public const uint XK_ohornacute; /* U+1EDB LATIN SMALL LETTER O WITH HORN AND ACUTE */
		public const uint XK_Ohorngrave; /* U+1EDC LATIN CAPITAL LETTER O WITH HORN AND GRAVE */
		public const uint XK_ohorngrave; /* U+1EDD LATIN SMALL LETTER O WITH HORN AND GRAVE */
		public const uint XK_Ohornhook; /* U+1EDE LATIN CAPITAL LETTER O WITH HORN AND HOOK ABOVE */
		public const uint XK_ohornhook; /* U+1EDF LATIN SMALL LETTER O WITH HORN AND HOOK ABOVE */
		public const uint XK_Ohorntilde; /* U+1EE0 LATIN CAPITAL LETTER O WITH HORN AND TILDE */
		public const uint XK_ohorntilde; /* U+1EE1 LATIN SMALL LETTER O WITH HORN AND TILDE */
		public const uint XK_Ohornbelowdot; /* U+1EE2 LATIN CAPITAL LETTER O WITH HORN AND DOT BELOW */
		public const uint XK_ohornbelowdot; /* U+1EE3 LATIN SMALL LETTER O WITH HORN AND DOT BELOW */
		public const uint XK_Ubelowdot; /* U+1EE4 LATIN CAPITAL LETTER U WITH DOT BELOW */
		public const uint XK_ubelowdot; /* U+1EE5 LATIN SMALL LETTER U WITH DOT BELOW */
		public const uint XK_Uhook; /* U+1EE6 LATIN CAPITAL LETTER U WITH HOOK ABOVE */
		public const uint XK_uhook; /* U+1EE7 LATIN SMALL LETTER U WITH HOOK ABOVE */
		public const uint XK_Uhornacute; /* U+1EE8 LATIN CAPITAL LETTER U WITH HORN AND ACUTE */
		public const uint XK_uhornacute; /* U+1EE9 LATIN SMALL LETTER U WITH HORN AND ACUTE */
		public const uint XK_Uhorngrave; /* U+1EEA LATIN CAPITAL LETTER U WITH HORN AND GRAVE */
		public const uint XK_uhorngrave; /* U+1EEB LATIN SMALL LETTER U WITH HORN AND GRAVE */
		public const uint XK_Uhornhook; /* U+1EEC LATIN CAPITAL LETTER U WITH HORN AND HOOK ABOVE */
		public const uint XK_uhornhook; /* U+1EED LATIN SMALL LETTER U WITH HORN AND HOOK ABOVE */
		public const uint XK_Uhorntilde; /* U+1EEE LATIN CAPITAL LETTER U WITH HORN AND TILDE */
		public const uint XK_uhorntilde; /* U+1EEF LATIN SMALL LETTER U WITH HORN AND TILDE */
		public const uint XK_Uhornbelowdot; /* U+1EF0 LATIN CAPITAL LETTER U WITH HORN AND DOT BELOW */
		public const uint XK_uhornbelowdot; /* U+1EF1 LATIN SMALL LETTER U WITH HORN AND DOT BELOW */
		public const uint XK_Ybelowdot; /* U+1EF4 LATIN CAPITAL LETTER Y WITH DOT BELOW */
		public const uint XK_ybelowdot; /* U+1EF5 LATIN SMALL LETTER Y WITH DOT BELOW */
		public const uint XK_Yhook; /* U+1EF6 LATIN CAPITAL LETTER Y WITH HOOK ABOVE */
		public const uint XK_yhook; /* U+1EF7 LATIN SMALL LETTER Y WITH HOOK ABOVE */
		public const uint XK_Ytilde; /* U+1EF8 LATIN CAPITAL LETTER Y WITH TILDE */
		public const uint XK_ytilde; /* U+1EF9 LATIN SMALL LETTER Y WITH TILDE */
		public const uint XK_Ohorn; /* U+01A0 LATIN CAPITAL LETTER O WITH HORN */
		public const uint XK_ohorn; /* U+01A1 LATIN SMALL LETTER O WITH HORN */
		public const uint XK_Uhorn; /* U+01AF LATIN CAPITAL LETTER U WITH HORN */
		public const uint XK_uhorn; /* U+01B0 LATIN SMALL LETTER U WITH HORN */


		public const uint XK_EcuSign; /* U+20A0 EURO-CURRENCY SIGN */
		public const uint XK_ColonSign; /* U+20A1 COLON SIGN */
		public const uint XK_CruzeiroSign; /* U+20A2 CRUZEIRO SIGN */
		public const uint XK_FFrancSign; /* U+20A3 FRENCH FRANC SIGN */
		public const uint XK_LiraSign; /* U+20A4 LIRA SIGN */
		public const uint XK_MillSign; /* U+20A5 MILL SIGN */
		public const uint XK_NairaSign; /* U+20A6 NAIRA SIGN */
		public const uint XK_PesetaSign; /* U+20A7 PESETA SIGN */
		public const uint XK_RupeeSign; /* U+20A8 RUPEE SIGN */
		public const uint XK_WonSign; /* U+20A9 WON SIGN */
		public const uint XK_NewSheqelSign; /* U+20AA NEW SHEQEL SIGN */
		public const uint XK_DongSign; /* U+20AB DONG SIGN */
		public const uint XK_EuroSign; /* U+20AC EURO SIGN */

/* one, two and three are defined above. */
		public const uint XK_zerosuperior; /* U+2070 SUPERSCRIPT ZERO */
		public const uint XK_foursuperior; /* U+2074 SUPERSCRIPT FOUR */
		public const uint XK_fivesuperior; /* U+2075 SUPERSCRIPT FIVE */
		public const uint XK_sixsuperior; /* U+2076 SUPERSCRIPT SIX */
		public const uint XK_sevensuperior; /* U+2077 SUPERSCRIPT SEVEN */
		public const uint XK_eightsuperior; /* U+2078 SUPERSCRIPT EIGHT */
		public const uint XK_ninesuperior; /* U+2079 SUPERSCRIPT NINE */
		public const uint XK_zerosubscript; /* U+2080 SUBSCRIPT ZERO */
		public const uint XK_onesubscript; /* U+2081 SUBSCRIPT ONE */
		public const uint XK_twosubscript; /* U+2082 SUBSCRIPT TWO */
		public const uint XK_threesubscript; /* U+2083 SUBSCRIPT THREE */
		public const uint XK_foursubscript; /* U+2084 SUBSCRIPT FOUR */
		public const uint XK_fivesubscript; /* U+2085 SUBSCRIPT FIVE */
		public const uint XK_sixsubscript; /* U+2086 SUBSCRIPT SIX */
		public const uint XK_sevensubscript; /* U+2087 SUBSCRIPT SEVEN */
		public const uint XK_eightsubscript; /* U+2088 SUBSCRIPT EIGHT */
		public const uint XK_ninesubscript; /* U+2089 SUBSCRIPT NINE */
		public const uint XK_partdifferential; /* U+2202 PARTIAL DIFFERENTIAL */
		public const uint XK_emptyset; /* U+2205 NULL SET */
		public const uint XK_elementof; /* U+2208 ELEMENT OF */
		public const uint XK_notelementof; /* U+2209 NOT AN ELEMENT OF */
		public const uint XK_containsas; /* U+220B CONTAINS AS MEMBER */
		public const uint XK_squareroot; /* U+221A SQUARE ROOT */
		public const uint XK_cuberoot; /* U+221B CUBE ROOT */
		public const uint XK_fourthroot; /* U+221C FOURTH ROOT */
		public const uint XK_dintegral; /* U+222C DOUBLE INTEGRAL */
		public const uint XK_tintegral; /* U+222D TRIPLE INTEGRAL */
		public const uint XK_because; /* U+2235 BECAUSE */
		public const uint XK_approxeq; /* U+2245 ALMOST EQUAL TO */
		public const uint XK_notapproxeq; /* U+2247 NOT ALMOST EQUAL TO */
		public const uint XK_notidentical; /* U+2262 NOT IDENTICAL TO */
		public const uint XK_stricteq; /* U+2263 STRICTLY EQUIVALENT TO */          

		public const uint XK_braille_dot_1;
		public const uint XK_braille_dot_2;
		public const uint XK_braille_dot_3;
		public const uint XK_braille_dot_4;
		public const uint XK_braille_dot_5;
		public const uint XK_braille_dot_6;
		public const uint XK_braille_dot_7;
		public const uint XK_braille_dot_8;
		public const uint XK_braille_dot_9;
		public const uint XK_braille_dot_10;
		public const uint XK_braille_blank; /* U+2800 BRAILLE PATTERN BLANK */
		public const uint XK_braille_dots_1; /* U+2801 BRAILLE PATTERN DOTS-1 */
		public const uint XK_braille_dots_2; /* U+2802 BRAILLE PATTERN DOTS-2 */
		public const uint XK_braille_dots_12; /* U+2803 BRAILLE PATTERN DOTS-12 */
		public const uint XK_braille_dots_3; /* U+2804 BRAILLE PATTERN DOTS-3 */
		public const uint XK_braille_dots_13; /* U+2805 BRAILLE PATTERN DOTS-13 */
		public const uint XK_braille_dots_23; /* U+2806 BRAILLE PATTERN DOTS-23 */
		public const uint XK_braille_dots_123; /* U+2807 BRAILLE PATTERN DOTS-123 */
		public const uint XK_braille_dots_4; /* U+2808 BRAILLE PATTERN DOTS-4 */
		public const uint XK_braille_dots_14; /* U+2809 BRAILLE PATTERN DOTS-14 */
		public const uint XK_braille_dots_24; /* U+280a BRAILLE PATTERN DOTS-24 */
		public const uint XK_braille_dots_124; /* U+280b BRAILLE PATTERN DOTS-124 */
		public const uint XK_braille_dots_34; /* U+280c BRAILLE PATTERN DOTS-34 */
		public const uint XK_braille_dots_134; /* U+280d BRAILLE PATTERN DOTS-134 */
		public const uint XK_braille_dots_234; /* U+280e BRAILLE PATTERN DOTS-234 */
		public const uint XK_braille_dots_1234; /* U+280f BRAILLE PATTERN DOTS-1234 */
		public const uint XK_braille_dots_5; /* U+2810 BRAILLE PATTERN DOTS-5 */
		public const uint XK_braille_dots_15; /* U+2811 BRAILLE PATTERN DOTS-15 */
		public const uint XK_braille_dots_25; /* U+2812 BRAILLE PATTERN DOTS-25 */
		public const uint XK_braille_dots_125; /* U+2813 BRAILLE PATTERN DOTS-125 */
		public const uint XK_braille_dots_35; /* U+2814 BRAILLE PATTERN DOTS-35 */
		public const uint XK_braille_dots_135; /* U+2815 BRAILLE PATTERN DOTS-135 */
		public const uint XK_braille_dots_235; /* U+2816 BRAILLE PATTERN DOTS-235 */
		public const uint XK_braille_dots_1235; /* U+2817 BRAILLE PATTERN DOTS-1235 */
		public const uint XK_braille_dots_45; /* U+2818 BRAILLE PATTERN DOTS-45 */
		public const uint XK_braille_dots_145; /* U+2819 BRAILLE PATTERN DOTS-145 */
		public const uint XK_braille_dots_245; /* U+281a BRAILLE PATTERN DOTS-245 */
		public const uint XK_braille_dots_1245; /* U+281b BRAILLE PATTERN DOTS-1245 */
		public const uint XK_braille_dots_345; /* U+281c BRAILLE PATTERN DOTS-345 */
		public const uint XK_braille_dots_1345; /* U+281d BRAILLE PATTERN DOTS-1345 */
		public const uint XK_braille_dots_2345; /* U+281e BRAILLE PATTERN DOTS-2345 */
		public const uint XK_braille_dots_12345; /* U+281f BRAILLE PATTERN DOTS-12345 */
		public const uint XK_braille_dots_6; /* U+2820 BRAILLE PATTERN DOTS-6 */
		public const uint XK_braille_dots_16; /* U+2821 BRAILLE PATTERN DOTS-16 */
		public const uint XK_braille_dots_26; /* U+2822 BRAILLE PATTERN DOTS-26 */
		public const uint XK_braille_dots_126; /* U+2823 BRAILLE PATTERN DOTS-126 */
		public const uint XK_braille_dots_36; /* U+2824 BRAILLE PATTERN DOTS-36 */
		public const uint XK_braille_dots_136; /* U+2825 BRAILLE PATTERN DOTS-136 */
		public const uint XK_braille_dots_236; /* U+2826 BRAILLE PATTERN DOTS-236 */
		public const uint XK_braille_dots_1236; /* U+2827 BRAILLE PATTERN DOTS-1236 */
		public const uint XK_braille_dots_46; /* U+2828 BRAILLE PATTERN DOTS-46 */
		public const uint XK_braille_dots_146; /* U+2829 BRAILLE PATTERN DOTS-146 */
		public const uint XK_braille_dots_246; /* U+282a BRAILLE PATTERN DOTS-246 */
		public const uint XK_braille_dots_1246; /* U+282b BRAILLE PATTERN DOTS-1246 */
		public const uint XK_braille_dots_346; /* U+282c BRAILLE PATTERN DOTS-346 */
		public const uint XK_braille_dots_1346; /* U+282d BRAILLE PATTERN DOTS-1346 */
		public const uint XK_braille_dots_2346; /* U+282e BRAILLE PATTERN DOTS-2346 */
		public const uint XK_braille_dots_12346; /* U+282f BRAILLE PATTERN DOTS-12346 */
		public const uint XK_braille_dots_56; /* U+2830 BRAILLE PATTERN DOTS-56 */
		public const uint XK_braille_dots_156; /* U+2831 BRAILLE PATTERN DOTS-156 */
		public const uint XK_braille_dots_256; /* U+2832 BRAILLE PATTERN DOTS-256 */
		public const uint XK_braille_dots_1256; /* U+2833 BRAILLE PATTERN DOTS-1256 */
		public const uint XK_braille_dots_356; /* U+2834 BRAILLE PATTERN DOTS-356 */
		public const uint XK_braille_dots_1356; /* U+2835 BRAILLE PATTERN DOTS-1356 */
		public const uint XK_braille_dots_2356; /* U+2836 BRAILLE PATTERN DOTS-2356 */
		public const uint XK_braille_dots_12356; /* U+2837 BRAILLE PATTERN DOTS-12356 */
		public const uint XK_braille_dots_456; /* U+2838 BRAILLE PATTERN DOTS-456 */
		public const uint XK_braille_dots_1456; /* U+2839 BRAILLE PATTERN DOTS-1456 */
		public const uint XK_braille_dots_2456; /* U+283a BRAILLE PATTERN DOTS-2456 */
		public const uint XK_braille_dots_12456; /* U+283b BRAILLE PATTERN DOTS-12456 */
		public const uint XK_braille_dots_3456; /* U+283c BRAILLE PATTERN DOTS-3456 */
		public const uint XK_braille_dots_13456; /* U+283d BRAILLE PATTERN DOTS-13456 */
		public const uint XK_braille_dots_23456; /* U+283e BRAILLE PATTERN DOTS-23456 */
		public const uint XK_braille_dots_123456; /* U+283f BRAILLE PATTERN DOTS-123456 */
		public const uint XK_braille_dots_7; /* U+2840 BRAILLE PATTERN DOTS-7 */
		public const uint XK_braille_dots_17; /* U+2841 BRAILLE PATTERN DOTS-17 */
		public const uint XK_braille_dots_27; /* U+2842 BRAILLE PATTERN DOTS-27 */
		public const uint XK_braille_dots_127; /* U+2843 BRAILLE PATTERN DOTS-127 */
		public const uint XK_braille_dots_37; /* U+2844 BRAILLE PATTERN DOTS-37 */
		public const uint XK_braille_dots_137; /* U+2845 BRAILLE PATTERN DOTS-137 */
		public const uint XK_braille_dots_237; /* U+2846 BRAILLE PATTERN DOTS-237 */
		public const uint XK_braille_dots_1237; /* U+2847 BRAILLE PATTERN DOTS-1237 */
		public const uint XK_braille_dots_47; /* U+2848 BRAILLE PATTERN DOTS-47 */
		public const uint XK_braille_dots_147; /* U+2849 BRAILLE PATTERN DOTS-147 */
		public const uint XK_braille_dots_247; /* U+284a BRAILLE PATTERN DOTS-247 */
		public const uint XK_braille_dots_1247; /* U+284b BRAILLE PATTERN DOTS-1247 */
		public const uint XK_braille_dots_347; /* U+284c BRAILLE PATTERN DOTS-347 */
		public const uint XK_braille_dots_1347; /* U+284d BRAILLE PATTERN DOTS-1347 */
		public const uint XK_braille_dots_2347; /* U+284e BRAILLE PATTERN DOTS-2347 */
		public const uint XK_braille_dots_12347; /* U+284f BRAILLE PATTERN DOTS-12347 */
		public const uint XK_braille_dots_57; /* U+2850 BRAILLE PATTERN DOTS-57 */
		public const uint XK_braille_dots_157; /* U+2851 BRAILLE PATTERN DOTS-157 */
		public const uint XK_braille_dots_257; /* U+2852 BRAILLE PATTERN DOTS-257 */
		public const uint XK_braille_dots_1257; /* U+2853 BRAILLE PATTERN DOTS-1257 */
		public const uint XK_braille_dots_357; /* U+2854 BRAILLE PATTERN DOTS-357 */
		public const uint XK_braille_dots_1357; /* U+2855 BRAILLE PATTERN DOTS-1357 */
		public const uint XK_braille_dots_2357; /* U+2856 BRAILLE PATTERN DOTS-2357 */
		public const uint XK_braille_dots_12357; /* U+2857 BRAILLE PATTERN DOTS-12357 */
		public const uint XK_braille_dots_457; /* U+2858 BRAILLE PATTERN DOTS-457 */
		public const uint XK_braille_dots_1457; /* U+2859 BRAILLE PATTERN DOTS-1457 */
		public const uint XK_braille_dots_2457; /* U+285a BRAILLE PATTERN DOTS-2457 */
		public const uint XK_braille_dots_12457; /* U+285b BRAILLE PATTERN DOTS-12457 */
		public const uint XK_braille_dots_3457; /* U+285c BRAILLE PATTERN DOTS-3457 */
		public const uint XK_braille_dots_13457; /* U+285d BRAILLE PATTERN DOTS-13457 */
		public const uint XK_braille_dots_23457; /* U+285e BRAILLE PATTERN DOTS-23457 */
		public const uint XK_braille_dots_123457; /* U+285f BRAILLE PATTERN DOTS-123457 */
		public const uint XK_braille_dots_67; /* U+2860 BRAILLE PATTERN DOTS-67 */
		public const uint XK_braille_dots_167; /* U+2861 BRAILLE PATTERN DOTS-167 */
		public const uint XK_braille_dots_267; /* U+2862 BRAILLE PATTERN DOTS-267 */
		public const uint XK_braille_dots_1267; /* U+2863 BRAILLE PATTERN DOTS-1267 */
		public const uint XK_braille_dots_367; /* U+2864 BRAILLE PATTERN DOTS-367 */
		public const uint XK_braille_dots_1367; /* U+2865 BRAILLE PATTERN DOTS-1367 */
		public const uint XK_braille_dots_2367; /* U+2866 BRAILLE PATTERN DOTS-2367 */
		public const uint XK_braille_dots_12367; /* U+2867 BRAILLE PATTERN DOTS-12367 */
		public const uint XK_braille_dots_467; /* U+2868 BRAILLE PATTERN DOTS-467 */
		public const uint XK_braille_dots_1467; /* U+2869 BRAILLE PATTERN DOTS-1467 */
		public const uint XK_braille_dots_2467; /* U+286a BRAILLE PATTERN DOTS-2467 */
		public const uint XK_braille_dots_12467; /* U+286b BRAILLE PATTERN DOTS-12467 */
		public const uint XK_braille_dots_3467; /* U+286c BRAILLE PATTERN DOTS-3467 */
		public const uint XK_braille_dots_13467; /* U+286d BRAILLE PATTERN DOTS-13467 */
		public const uint XK_braille_dots_23467; /* U+286e BRAILLE PATTERN DOTS-23467 */
		public const uint XK_braille_dots_123467; /* U+286f BRAILLE PATTERN DOTS-123467 */
		public const uint XK_braille_dots_567; /* U+2870 BRAILLE PATTERN DOTS-567 */
		public const uint XK_braille_dots_1567; /* U+2871 BRAILLE PATTERN DOTS-1567 */
		public const uint XK_braille_dots_2567; /* U+2872 BRAILLE PATTERN DOTS-2567 */
		public const uint XK_braille_dots_12567; /* U+2873 BRAILLE PATTERN DOTS-12567 */
		public const uint XK_braille_dots_3567; /* U+2874 BRAILLE PATTERN DOTS-3567 */
		public const uint XK_braille_dots_13567; /* U+2875 BRAILLE PATTERN DOTS-13567 */
		public const uint XK_braille_dots_23567; /* U+2876 BRAILLE PATTERN DOTS-23567 */
		public const uint XK_braille_dots_123567; /* U+2877 BRAILLE PATTERN DOTS-123567 */
		public const uint XK_braille_dots_4567; /* U+2878 BRAILLE PATTERN DOTS-4567 */
		public const uint XK_braille_dots_14567; /* U+2879 BRAILLE PATTERN DOTS-14567 */
		public const uint XK_braille_dots_24567; /* U+287a BRAILLE PATTERN DOTS-24567 */
		public const uint XK_braille_dots_124567; /* U+287b BRAILLE PATTERN DOTS-124567 */
		public const uint XK_braille_dots_34567; /* U+287c BRAILLE PATTERN DOTS-34567 */
		public const uint XK_braille_dots_134567; /* U+287d BRAILLE PATTERN DOTS-134567 */
		public const uint XK_braille_dots_234567; /* U+287e BRAILLE PATTERN DOTS-234567 */
		public const uint XK_braille_dots_1234567; /* U+287f BRAILLE PATTERN DOTS-1234567 */
		public const uint XK_braille_dots_8; /* U+2880 BRAILLE PATTERN DOTS-8 */
		public const uint XK_braille_dots_18; /* U+2881 BRAILLE PATTERN DOTS-18 */
		public const uint XK_braille_dots_28; /* U+2882 BRAILLE PATTERN DOTS-28 */
		public const uint XK_braille_dots_128; /* U+2883 BRAILLE PATTERN DOTS-128 */
		public const uint XK_braille_dots_38; /* U+2884 BRAILLE PATTERN DOTS-38 */
		public const uint XK_braille_dots_138; /* U+2885 BRAILLE PATTERN DOTS-138 */
		public const uint XK_braille_dots_238; /* U+2886 BRAILLE PATTERN DOTS-238 */
		public const uint XK_braille_dots_1238; /* U+2887 BRAILLE PATTERN DOTS-1238 */
		public const uint XK_braille_dots_48; /* U+2888 BRAILLE PATTERN DOTS-48 */
		public const uint XK_braille_dots_148; /* U+2889 BRAILLE PATTERN DOTS-148 */
		public const uint XK_braille_dots_248; /* U+288a BRAILLE PATTERN DOTS-248 */
		public const uint XK_braille_dots_1248; /* U+288b BRAILLE PATTERN DOTS-1248 */
		public const uint XK_braille_dots_348; /* U+288c BRAILLE PATTERN DOTS-348 */
		public const uint XK_braille_dots_1348; /* U+288d BRAILLE PATTERN DOTS-1348 */
		public const uint XK_braille_dots_2348; /* U+288e BRAILLE PATTERN DOTS-2348 */
		public const uint XK_braille_dots_12348; /* U+288f BRAILLE PATTERN DOTS-12348 */
		public const uint XK_braille_dots_58; /* U+2890 BRAILLE PATTERN DOTS-58 */
		public const uint XK_braille_dots_158; /* U+2891 BRAILLE PATTERN DOTS-158 */
		public const uint XK_braille_dots_258; /* U+2892 BRAILLE PATTERN DOTS-258 */
		public const uint XK_braille_dots_1258; /* U+2893 BRAILLE PATTERN DOTS-1258 */
		public const uint XK_braille_dots_358; /* U+2894 BRAILLE PATTERN DOTS-358 */
		public const uint XK_braille_dots_1358; /* U+2895 BRAILLE PATTERN DOTS-1358 */
		public const uint XK_braille_dots_2358; /* U+2896 BRAILLE PATTERN DOTS-2358 */
		public const uint XK_braille_dots_12358; /* U+2897 BRAILLE PATTERN DOTS-12358 */
		public const uint XK_braille_dots_458; /* U+2898 BRAILLE PATTERN DOTS-458 */
		public const uint XK_braille_dots_1458; /* U+2899 BRAILLE PATTERN DOTS-1458 */
		public const uint XK_braille_dots_2458; /* U+289a BRAILLE PATTERN DOTS-2458 */
		public const uint XK_braille_dots_12458; /* U+289b BRAILLE PATTERN DOTS-12458 */
		public const uint XK_braille_dots_3458; /* U+289c BRAILLE PATTERN DOTS-3458 */
		public const uint XK_braille_dots_13458; /* U+289d BRAILLE PATTERN DOTS-13458 */
		public const uint XK_braille_dots_23458; /* U+289e BRAILLE PATTERN DOTS-23458 */
		public const uint XK_braille_dots_123458; /* U+289f BRAILLE PATTERN DOTS-123458 */
		public const uint XK_braille_dots_68; /* U+28a0 BRAILLE PATTERN DOTS-68 */
		public const uint XK_braille_dots_168; /* U+28a1 BRAILLE PATTERN DOTS-168 */
		public const uint XK_braille_dots_268; /* U+28a2 BRAILLE PATTERN DOTS-268 */
		public const uint XK_braille_dots_1268; /* U+28a3 BRAILLE PATTERN DOTS-1268 */
		public const uint XK_braille_dots_368; /* U+28a4 BRAILLE PATTERN DOTS-368 */
		public const uint XK_braille_dots_1368; /* U+28a5 BRAILLE PATTERN DOTS-1368 */
		public const uint XK_braille_dots_2368; /* U+28a6 BRAILLE PATTERN DOTS-2368 */
		public const uint XK_braille_dots_12368; /* U+28a7 BRAILLE PATTERN DOTS-12368 */
		public const uint XK_braille_dots_468; /* U+28a8 BRAILLE PATTERN DOTS-468 */
		public const uint XK_braille_dots_1468; /* U+28a9 BRAILLE PATTERN DOTS-1468 */
		public const uint XK_braille_dots_2468; /* U+28aa BRAILLE PATTERN DOTS-2468 */
		public const uint XK_braille_dots_12468; /* U+28ab BRAILLE PATTERN DOTS-12468 */
		public const uint XK_braille_dots_3468; /* U+28ac BRAILLE PATTERN DOTS-3468 */
		public const uint XK_braille_dots_13468; /* U+28ad BRAILLE PATTERN DOTS-13468 */
		public const uint XK_braille_dots_23468; /* U+28ae BRAILLE PATTERN DOTS-23468 */
		public const uint XK_braille_dots_123468; /* U+28af BRAILLE PATTERN DOTS-123468 */
		public const uint XK_braille_dots_568; /* U+28b0 BRAILLE PATTERN DOTS-568 */
		public const uint XK_braille_dots_1568; /* U+28b1 BRAILLE PATTERN DOTS-1568 */
		public const uint XK_braille_dots_2568; /* U+28b2 BRAILLE PATTERN DOTS-2568 */
		public const uint XK_braille_dots_12568; /* U+28b3 BRAILLE PATTERN DOTS-12568 */
		public const uint XK_braille_dots_3568; /* U+28b4 BRAILLE PATTERN DOTS-3568 */
		public const uint XK_braille_dots_13568; /* U+28b5 BRAILLE PATTERN DOTS-13568 */
		public const uint XK_braille_dots_23568; /* U+28b6 BRAILLE PATTERN DOTS-23568 */
		public const uint XK_braille_dots_123568; /* U+28b7 BRAILLE PATTERN DOTS-123568 */
		public const uint XK_braille_dots_4568; /* U+28b8 BRAILLE PATTERN DOTS-4568 */
		public const uint XK_braille_dots_14568; /* U+28b9 BRAILLE PATTERN DOTS-14568 */
		public const uint XK_braille_dots_24568; /* U+28ba BRAILLE PATTERN DOTS-24568 */
		public const uint XK_braille_dots_124568; /* U+28bb BRAILLE PATTERN DOTS-124568 */
		public const uint XK_braille_dots_34568; /* U+28bc BRAILLE PATTERN DOTS-34568 */
		public const uint XK_braille_dots_134568; /* U+28bd BRAILLE PATTERN DOTS-134568 */
		public const uint XK_braille_dots_234568; /* U+28be BRAILLE PATTERN DOTS-234568 */
		public const uint XK_braille_dots_1234568; /* U+28bf BRAILLE PATTERN DOTS-1234568 */
		public const uint XK_braille_dots_78; /* U+28c0 BRAILLE PATTERN DOTS-78 */
		public const uint XK_braille_dots_178; /* U+28c1 BRAILLE PATTERN DOTS-178 */
		public const uint XK_braille_dots_278; /* U+28c2 BRAILLE PATTERN DOTS-278 */
		public const uint XK_braille_dots_1278; /* U+28c3 BRAILLE PATTERN DOTS-1278 */
		public const uint XK_braille_dots_378; /* U+28c4 BRAILLE PATTERN DOTS-378 */
		public const uint XK_braille_dots_1378; /* U+28c5 BRAILLE PATTERN DOTS-1378 */
		public const uint XK_braille_dots_2378; /* U+28c6 BRAILLE PATTERN DOTS-2378 */
		public const uint XK_braille_dots_12378; /* U+28c7 BRAILLE PATTERN DOTS-12378 */
		public const uint XK_braille_dots_478; /* U+28c8 BRAILLE PATTERN DOTS-478 */
		public const uint XK_braille_dots_1478; /* U+28c9 BRAILLE PATTERN DOTS-1478 */
		public const uint XK_braille_dots_2478; /* U+28ca BRAILLE PATTERN DOTS-2478 */
		public const uint XK_braille_dots_12478; /* U+28cb BRAILLE PATTERN DOTS-12478 */
		public const uint XK_braille_dots_3478; /* U+28cc BRAILLE PATTERN DOTS-3478 */
		public const uint XK_braille_dots_13478; /* U+28cd BRAILLE PATTERN DOTS-13478 */
		public const uint XK_braille_dots_23478; /* U+28ce BRAILLE PATTERN DOTS-23478 */
		public const uint XK_braille_dots_123478; /* U+28cf BRAILLE PATTERN DOTS-123478 */
		public const uint XK_braille_dots_578; /* U+28d0 BRAILLE PATTERN DOTS-578 */
		public const uint XK_braille_dots_1578; /* U+28d1 BRAILLE PATTERN DOTS-1578 */
		public const uint XK_braille_dots_2578; /* U+28d2 BRAILLE PATTERN DOTS-2578 */
		public const uint XK_braille_dots_12578; /* U+28d3 BRAILLE PATTERN DOTS-12578 */
		public const uint XK_braille_dots_3578; /* U+28d4 BRAILLE PATTERN DOTS-3578 */
		public const uint XK_braille_dots_13578; /* U+28d5 BRAILLE PATTERN DOTS-13578 */
		public const uint XK_braille_dots_23578; /* U+28d6 BRAILLE PATTERN DOTS-23578 */
		public const uint XK_braille_dots_123578; /* U+28d7 BRAILLE PATTERN DOTS-123578 */
		public const uint XK_braille_dots_4578; /* U+28d8 BRAILLE PATTERN DOTS-4578 */
		public const uint XK_braille_dots_14578; /* U+28d9 BRAILLE PATTERN DOTS-14578 */
		public const uint XK_braille_dots_24578; /* U+28da BRAILLE PATTERN DOTS-24578 */
		public const uint XK_braille_dots_124578; /* U+28db BRAILLE PATTERN DOTS-124578 */
		public const uint XK_braille_dots_34578; /* U+28dc BRAILLE PATTERN DOTS-34578 */
		public const uint XK_braille_dots_134578; /* U+28dd BRAILLE PATTERN DOTS-134578 */
		public const uint XK_braille_dots_234578; /* U+28de BRAILLE PATTERN DOTS-234578 */
		public const uint XK_braille_dots_1234578; /* U+28df BRAILLE PATTERN DOTS-1234578 */
		public const uint XK_braille_dots_678; /* U+28e0 BRAILLE PATTERN DOTS-678 */
		public const uint XK_braille_dots_1678; /* U+28e1 BRAILLE PATTERN DOTS-1678 */
		public const uint XK_braille_dots_2678; /* U+28e2 BRAILLE PATTERN DOTS-2678 */
		public const uint XK_braille_dots_12678; /* U+28e3 BRAILLE PATTERN DOTS-12678 */
		public const uint XK_braille_dots_3678; /* U+28e4 BRAILLE PATTERN DOTS-3678 */
		public const uint XK_braille_dots_13678; /* U+28e5 BRAILLE PATTERN DOTS-13678 */
		public const uint XK_braille_dots_23678; /* U+28e6 BRAILLE PATTERN DOTS-23678 */
		public const uint XK_braille_dots_123678; /* U+28e7 BRAILLE PATTERN DOTS-123678 */
		public const uint XK_braille_dots_4678; /* U+28e8 BRAILLE PATTERN DOTS-4678 */
		public const uint XK_braille_dots_14678; /* U+28e9 BRAILLE PATTERN DOTS-14678 */
		public const uint XK_braille_dots_24678; /* U+28ea BRAILLE PATTERN DOTS-24678 */
		public const uint XK_braille_dots_124678; /* U+28eb BRAILLE PATTERN DOTS-124678 */
		public const uint XK_braille_dots_34678; /* U+28ec BRAILLE PATTERN DOTS-34678 */
		public const uint XK_braille_dots_134678; /* U+28ed BRAILLE PATTERN DOTS-134678 */
		public const uint XK_braille_dots_234678; /* U+28ee BRAILLE PATTERN DOTS-234678 */
		public const uint XK_braille_dots_1234678; /* U+28ef BRAILLE PATTERN DOTS-1234678 */
		public const uint XK_braille_dots_5678; /* U+28f0 BRAILLE PATTERN DOTS-5678 */
		public const uint XK_braille_dots_15678; /* U+28f1 BRAILLE PATTERN DOTS-15678 */
		public const uint XK_braille_dots_25678; /* U+28f2 BRAILLE PATTERN DOTS-25678 */
		public const uint XK_braille_dots_125678; /* U+28f3 BRAILLE PATTERN DOTS-125678 */
		public const uint XK_braille_dots_35678; /* U+28f4 BRAILLE PATTERN DOTS-35678 */
		public const uint XK_braille_dots_135678; /* U+28f5 BRAILLE PATTERN DOTS-135678 */
		public const uint XK_braille_dots_235678; /* U+28f6 BRAILLE PATTERN DOTS-235678 */
		public const uint XK_braille_dots_1235678; /* U+28f7 BRAILLE PATTERN DOTS-1235678 */
		public const uint XK_braille_dots_45678; /* U+28f8 BRAILLE PATTERN DOTS-45678 */
		public const uint XK_braille_dots_145678; /* U+28f9 BRAILLE PATTERN DOTS-145678 */
		public const uint XK_braille_dots_245678; /* U+28fa BRAILLE PATTERN DOTS-245678 */
		public const uint XK_braille_dots_1245678; /* U+28fb BRAILLE PATTERN DOTS-1245678 */
		public const uint XK_braille_dots_345678; /* U+28fc BRAILLE PATTERN DOTS-345678 */
		public const uint XK_braille_dots_1345678; /* U+28fd BRAILLE PATTERN DOTS-1345678 */
		public const uint XK_braille_dots_2345678; /* U+28fe BRAILLE PATTERN DOTS-2345678 */
		public const uint XK_braille_dots_12345678; /* U+28ff BRAILLE PATTERN DOTS-12345678 */

	}
