#
# Makefile
#

# Tray icon flag. Possible values:
# none, tray (for gnome 2.x) , indicator (for gnome 3.x)
ICON = indicator
XK_SYMBOLS = XK_TECHNICAL XK_PUBLISHING XK_APL

# Build type. Possible values:
# debug, release
BUILDTYPE = debug

PROGRAM = neo_layout_viewer
BINDIR = bin

VALAC = valac --thread --Xcc="-lm" -D $(ICON) $(XK_SYMBOLS)
VAPIDIR = --vapidir=vapi/ 

# source files 
SRC = src/main.vala src/unique.vala src/neo-window.vala src/key-overlay.vala src/config-manager.vala src/keybinding-manager.vala csrc/keysend.c csrc/checkModifier.c

# packges 
PKGS = --pkg x11 --pkg keysym --pkg gtk+-3.0 --pkg gee-1.0 --pkg gdk-x11-3.0 --pkg posix  --pkg unique-3.0 

# Add some args if tray icon is demanded.
ifeq ($(ICON),tray)
SRC += src/tray.vala
endif
ifeq ($(ICON),indicator)
SRC += src/indicator.vala
PKGS += --pkg appindicator3-0.1
endif
 
# compiler options for a debug build
#VALAC_DEBUG_OPTS = -g --save-temps
VALAC_DEBUG_OPTS =  -g 
# compiler options for a debug build
VALAC_RELEASE_OPTS = -X -O2 --disable-assert 

 
# the 'all' target build a debug build
all: $(BINDIR) info bulid_debug

info:
	@echo ""
	@echo "Buildtype: $(BUILDTYPE)"
	@echo "Trayicon: $(ICON)"
	@echo ""
	@echo "Edit the variable ICON in this Makefile"
	@echo "if you want enable a tray icon."
	@echo ""
	@echo "Edit the variabe BUILDTYPE in this Makefile"
	@echo "to switch build type to 'release'."
	@echo ""
	@echo ""

# the 'release' target builds a release build
# you might want to disabled asserts also
release: $(BINDIR) clean bulid_$(BUILDTYPE)

$(BINDIR):
	mkdir -p $(BINDIR)
	ln -s ../assets bin/assets

bulid_debug:
#	@echo $(VALAC) $(VAPIDIR) $(VALAC_DEBUG_OPTS) $(SRC) -o $(BINDIR)/$(PROGRAM) $(PKGS) $(CC_INCLUDES)
	@$(VALAC) $(VAPIDIR) $(VALAC_DEBUG_OPTS) $(SRC) -o $(BINDIR)/$(PROGRAM) $(PKGS) $(CC_INCLUDES)

bulid_release:
	@$(VALAC) $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) -o $(BINDIR)/$(PROGRAM) $(PKGS) $(CC_INCLUDES)
 
# clean all built files
clean:
	@rm -v -fr *~ *.c src/*.c src/*~ 
