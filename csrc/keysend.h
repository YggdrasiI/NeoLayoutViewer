/* Use all keysym groups for NEO */
#define XK_TECHNICAL
#define XK_PUBLISHING
#define XK_APL

#ifndef __KEY_SEND_H__
#define __KEY_SEND_H__

#include <string.h>
#include <stdio.h>
//#include <cstdlib>
#include <unistd.h>
#include <string.h>

#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <gdk/gdkx.h>
#include <X11/Xlib.h>
#include <X11/XKBlib.h>
#include <X11/keysym.h>


G_BEGIN_DECLS

typedef struct {
	guint                 keyval;
	GdkModifierType       modifiers;
} KeyMod;

static KeyMod 
getKeyModCodes (GdkWindow *rootwin,
             uint       keyval,
             int       modifiers);

/*static XKeyEvent createKeyEvent(Display *display, Window win,
                           Window winRoot, int press,
                           int keycode, int modifiers);
													 */

int keysend(uint keysym, int modifiers);
int keysend2(uint keysym, uint modsym1, uint modsym2);

G_END_DECLS

#endif /* __KEY_SEND_H__ */
