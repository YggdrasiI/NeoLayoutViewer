#
# Makefile
#

# Tray icon flag. Possible values:
# none, tray (for gnome 2.x) , indicator (for gnome 3.x)
ICON = indicator

# Build type. Possible values:
# debug, release
BUILDTYPE = debug

PROGRAM = neo_layout_viewer
BINDIR = bin

#########################################################

VALAC = valac --thread --Xcc="-lm" --Xcc="-DXK_TECHNICAL" --Xcc="-DXK_PUBLISHING" --Xcc="-DXK_APL" -D $(ICON) 
VAPIDIR = --vapidir=vapi/ 

# source files 
SRC = src/main.vala src/unique.vala src/neo-window.vala src/key-overlay.vala src/config-manager.vala src/keybinding-manager.vala csrc/keysend.c csrc/checkModifier.c

#test for valac version, workaround for Arch Linux bug
ifeq ($(wildcard /usr/include/gee-0.8),)
	GEEVERSION=1.0
else
	GEEVERSION=0.8
endif

# packges 
PKGS = --pkg x11 --pkg keysym --pkg gtk+-3.0 --pkg gee-$(GEEVERSION) --pkg gdk-x11-3.0 --pkg posix  --pkg unique-3.0 

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
	@echo "Notes:"
	@echo "Edit the variable ICON in the head of Makefile"
	@echo "if you want enable a tray icon."
	@echo ""
	@echo "Edit the variabe BUILDTYPE in the head of Makefile"
	@echo "to switch build type to 'release'."
	@echo ""
	@echo ""

# the 'release' target builds a release build
# you might want disable asserts also
release: $(BINDIR) clean bulid_$(BUILDTYPE)

$(BINDIR):
	mkdir -p $(BINDIR)
	ln -s ../assets bin/assets

bulid_debug:
#	@echo $(VALAC) $(VAPIDIR) $(VALAC_DEBUG_OPTS) $(SRC) -o $(BINDIR)/$(PROGRAM) $(PKGS) $(CC_INCLUDES)
	@$(VALAC) $(VAPIDIR) $(VALAC_DEBUG_OPTS) $(SRC) -o $(BINDIR)/$(PROGRAM) $(PKGS) $(CC_INCLUDES)

bulid_release:
	@$(VALAC) $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) -o $(BINDIR)/$(PROGRAM) $(PKGS) $(CC_INCLUDES)
 
# clean all build files
clean:
	@rm -v -fr *~ *.c src/*.c src/*~ 
