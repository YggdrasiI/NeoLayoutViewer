# Makefile
# vala project
#
 
# name of your project/program
PROGRAM = neo_layout_viewer
BINDIR = bin
 
# for most cases the following two are the only you'll need to change
# add your source files here
SRC = src/main.vala src/neo-window.vala src/key-overlay.vala src/tray.vala src/config-manager.vala src/keybinding-manager.vala csrc/keysend.c csrc/checkModifier.c

# add your used packges here
PKGS = --pkg x11 --pkg keysym --pkg gtk+-2.0 --pkg gee-1.0 --pkg gdk-x11-2.0 --pkg posix 
#PKGS = --pkg keysym --pkg x11 --pkg gtk+-2.0 --pkg gee-1.0 --pkg gdk-x11-2.0 --pkg posix 

CC_INCLUDES = 
# vala compiler
VALAC = valac --thread 
VAPIDIR = --vapidir=vapi/ --vapi=vapi/keysym.vapi
 
# compiler options for a debug build
#VALACOPTS = -g --save-temps
VALAC_DEBUG_OPTS = 
# compiler options for a debug build
VALAC_RELEASE_OPTS = -X -O2 --disable-assert 
 
# set this as root makefile for Valencia
BUILD_ROOT = 1


# the 'all' target build a debug build
all: $(BINDIR) bulid_debug

# the 'release' target builds a release build
# you might want to disabled asserts also
release: $(BINDIR) clean bulid_release

$(BINDIR):
	mkdir -p $(BINDIR)
	ln -s ../assets bin/assets

bulid_debug:
	@echo $(VALAC) $(VAPIDIR) $(VALAC_DEBUG_OPTS) $(SRC) -o $(BINDIR)/$(PROGRAM) $(PKGS) $(CC_INCLUDES)
	@$(VALAC) $(VAPIDIR) $(VALAC_DEBUG_OPTS) $(SRC) -o $(BINDIR)/$(PROGRAM) $(PKGS) $(CC_INCLUDES)

bulid_release:
	@$(VALAC) $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) -o $(BINDIR)/$(PROGRAM)_release $(PKGS) $(CC_INCLUDES)
 
# clean all built files
clean:
	@rm -v -fr *~ *.c $(PROGRAM)
