#
# Makefile
#

# Tray icon flag. Possible values:
# none, tray (for gnome 2.x) , indicator (for gnome 3.x)
ICON ?= indicator

# Build type. Possible values:
# debug, release
BUILD_TYPE ?= release

BINNAME = neo_layout_viewer
BINDIR = bin

# Path prefix for 'make install'
PREFIX = /usr/local
APPNAME = NeoLayoutViewer

GIT_COMMIT_VERSION=$(shell git log --oneline --max-count=1 | head --bytes=7)
ENV_FILE=.build_env

#STATIC=-static

#########################################################

EXEC_PREFIX = $(PREFIX)
DATADIR = $(PREFIX)/share

VALAC = valac --thread  -D $(ICON) \
				--Xcc="-lm" --Xcc="-DXK_TECHNICAL" --Xcc="-DXK_PUBLISHING" --Xcc="-DXK_APL"
VAPIDIR = --vapidir=vapi/ 

# Source files 
SRC = src/version.vala \
      src/main.vala \
      src/unique.vala \
      src/neo-window.vala \
      src/key-overlay.vala \
      src/config-manager.vala \
      src/keybinding-manager.vala \
      csrc/keysend.c \
      csrc/checkModifier.c

# Asset files
ASSET_FILES=$(wildcard assets/**/*.png)

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
VALAC_DEBUG_OPTS = -g --save-temps
#VALAC_DEBUG_OPTS =  -g 
# compiler options for a release build
VALAC_RELEASE_OPTS = -X -O2 --disable-assert 

 
.PHONY: debug release install clean last_build_env
# .FORCE: last_build_env


# the 'all' target build a debug build
all: $(BINDIR) info last_build_env $(BINDIR)/$(BINNAME)
	@echo "Done"

$(BINDIR)/$(BINNAME): $(SRC) Makefile
	make bulid_$(BUILD_TYPE)

# Remove binary if current env differs from last build env
# This toggles a rebuild.
last_build_env:
	@(test "$$(env|sort)" = "$$(test -f $(ENV_FILE) && cat $(ENV_FILE) )" \
		&& echo "Same environment as last build.") \
		|| (echo "Env has changed. Force build" \
		&& env | sort > "$(ENV_FILE)" \
		&& rm -f $(BINDIR)/$(BINNAME)\
		)

# the 'release' target builds a release build
# you might want disable asserts also
release: $(BINDIR) clean bulid_release

info:
	@echo " \n"\
		"Buildtype: $(BUILD_TYPE)\n" \
		"Trayicon: $(ICON)\n" \
		"\n" \
		"Notes:\n" \
		"  Use 'ICON=... make' to switch type of panel menu.\n" \
		"    indicator: For gnome 3.x (default)\n" \
		"    tray: For gnome 2.x (default)\n" \
		"    none: Disables icon\n\n" \
		"  Use 'BUILD_TYPE=[release|debug] make' to switch build type\n\n" \

gen_version:
	@echo "namespace NeoLayoutViewer{\n" \
		"public const string GIT_COMMIT_VERSION = \"$(GIT_COMMIT_VERSION)\";\n" \
		"public const string SHARED_ASSETS_PATH = \"$(DATADIR)/$(APPNAME)/assets\";\n" \
		"}" \
		> src/version.vala

$(BINDIR):
	@mkdir -p $(BINDIR)
	@ln -s ../assets bin/assets

bulid_debug: gen_version 
	#	@echo $(VALAC) $(VAPIDIR) $(VALAC_DEBUG_OPTS) $(SRC) -o $(BINDIR)/$(BINNAME) $(PKGS) $(CC_INCLUDES)
	$(VALAC) $(VAPIDIR) $(VALAC_DEBUG_OPTS) $(SRC) -o $(BINDIR)/$(BINNAME) $(PKGS) $(CC_INCLUDES)

bulid_release: gen_version 
	$(VALAC) $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) -o $(BINDIR)/$(BINNAME) $(PKGS) $(CC_INCLUDES)

install:
	test -f $(BINDIR)/$(BINNAME) || make all
	install -d $(EXEC_PREFIX)/bin
	install -D -m 0755 $(BINDIR)/$(BINNAME) $(EXEC_PREFIX)/bin
	$(foreach ASSET_FILE,$(ASSET_FILES), install -D -m 0644 $(ASSET_FILE) $(DATADIR)/$(APPNAME)/$(ASSET_FILE) ; )

uninstall:
	@rm -v $(EXEC_PREFIX)/bin/$(BINNAME)
	@rm -v -r $(DATADIR)/$(APPNAME)

# clean all build files
clean:
	@rm -v -fr *~ *.c src/*.c src/*~ 

