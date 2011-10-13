# Makefile
# vala project
#
 
# name of your project/program
PROGRAM = neo_layout_viewer
BINDIR = bin
 
# for most cases the following two are the only you'll need to change
# add your source files here
SRC = main.vala neo-window.vala key-overlay.vala tray.vala config-manager.vala keybinding-manager.vala keysend.c

# add your used packges here
PKGS = --pkg x11 --pkg keysym --pkg gtk+-2.0 --pkg gee-1.0 --pkg gdk-x11-2.0 --pkg posix 
#PKGS = --pkg keysym --pkg x11 --pkg gtk+-2.0 --pkg gee-1.0 --pkg gdk-x11-2.0 --pkg posix 

CC_INCLUDES = 
# vala compiler
VALAC = valac
#VAPIDIR = --vapidir=vapi/
VAPIDIR = --vapi=vapi/keysym.vapi
 
# compiler options for a debug build
#VALACOPTS = -g --save-temps
VALACOPTS = 
 
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
	@$(VALAC) $(VAPIDIR) $(VALACOPTS) $(SRC) -o $(BINDIR)/$(PROGRAM) $(PKGS) $(CC_INCLUDES)

bulid_release:
	@$(VALAC) -X -O2 $(VAPIDIR) $(SRC) -o $(BINDIR)/$(PROGRAM)_release $(PKGS) $(CC_INCLUDES)
 
# clean all built files
clean:
	@rm -v -fr *~ *.c $(PROGRAM)
