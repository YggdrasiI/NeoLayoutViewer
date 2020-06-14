/* vim: set tabstop=2:softtabstop=2:shiftwidth=2:noexpandtab */
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>

/*
Code ideas from
 http://stackoverflow.com/questions/2968336/qt-password-field
*/
#ifdef Q_OS_WIN32
#include <windows.h>
#else
#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <gdk/gdkx.h>
#include <X11/Xlib.h>
#include <X11/XKBlib.h>
#include <X11/keysym.h>
#endif

char keymap[32];
bool keyPressed(int keycode, char* keymap){
	return ( keymap[keycode/8] & (1 << keycode%8) ) > 0;
}

/* 
Input: Display, Array of keycodes, length of both arrays
Output: Array of ints. (no bools because sizeof(bool,vala) != sizeof(bool, stdbool.h)
*/
void checkModifier(Display* display, int* keycodes, int nkeycodes, int* pressed){
	XQueryKeymap(display, keymap);
	int i;
	for (i=0; i<nkeycodes; i++) {
		pressed[i] = keyPressed(keycodes[i], keymap)?1:0;
		//printf("%i Pressed? %i\n", keycodes[i], (pressed[i]) );
	}

}


bool checkCapsLock(Display* d) {
	// platform dependent method of determining if CAPS LOCK is on
	/*#ifdef Q_OS_WIN32 // MS Windows version
		return GetKeyState(VK_CAPITAL) == 1;
#else // X11 version (Linux/Unix/Mac OS X/etc...)*/
	//Display* d = XOpenDisplay((char*)0);
	bool caps_state = false;
	if (d) {
		unsigned n;
		XkbGetIndicatorState(d, XkbUseCoreKbd, &n);
		caps_state = (n & 0x01) == 1;
	}
	return caps_state;
	//#endif
}


unsigned int checkIndicatorStates(Display* d) {
	unsigned n = 0;
	if (d) {
		XkbGetIndicatorState(d, XkbUseCoreKbd, &n);
	}
	return n;
}


