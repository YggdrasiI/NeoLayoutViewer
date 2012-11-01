# Makefile
# vala project
#
 
PROGRAM = neo_layout_viewer
BINDIR = bin
 
# source files 
SRC = src/main.vala src/unique.vala src/neo-window.vala src/key-overlay.vala src/tray.vala src/config-manager.vala src/keybinding-manager.vala csrc/keysend.c csrc/checkModifier.c

# packges 
PKGS = --pkg x11 --pkg keysym --pkg gtk+-3.0 --pkg gee-1.0 --pkg gdk-x11-3.0 --pkg posix  --pkg unique-3.0 

#CC_INCLUDES = 
# vala compiler
VALAC = valac --thread --Xcc="-lm"
VAPIDIR = --vapidir=vapi/ 
 
# compiler options for a debug build
#VALAC_DEBUG_OPTS = -g --save-temps
VALAC_DEBUG_OPTS =  -g 
# compiler options for a debug build
VALAC_RELEASE_OPTS = -X -O2 --disable-assert 
 
# the 'all' target build a debug build
all: $(BINDIR) info bulid_debug

info:
	@echo ""
	@echo "Compile debug version. Use 'make release' for release build"
	@echo ""

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
	@$(VALAC) $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) -o $(BINDIR)/$(PROGRAM) $(PKGS) $(CC_INCLUDES)
 
# clean all built files
clean:
	@rm -v -fr *~ *.c src/*.c src/*~ $(PROGRAM)
