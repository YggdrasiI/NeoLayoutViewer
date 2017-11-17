#
# Makefile
#

# Tray icon flag. Possible values:
# none, tray (for gnome 2.x) , indicator (for gnome 3.x)
ICON ?= indicator

# Build type. Possible values:
# debug, release, win
BUILD_TYPE ?= release

BINNAME = neo_layout_viewer
BINDIR = bin

# Path prefix for 'make install'
PREFIX = /usr/local
APPNAME = NeoLayoutViewer

GIT_COMMIT_VERSION=$(shell git log --oneline --max-count=1 | head --bytes=7)
ENV_FILE=.build_env

#WIN = 1
ifeq ($(WIN),)
NL = \n
BINEXT = 
else
BUILD_TYPE = win
BINEXT = .exe
ICON = tray
PKG_CONFIG_PATH=${HOME}/software/gtk/gtk+-3.10_win64/lib/pkgconfig
GCC_WIN = x86_64-w64-mingw32-gcc -mwindows
GCC_WIN_FLAGS =$(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) pkg-config --cflags --libs gtk+-3.0 gee-$(GEEVERSION))
endif

# compiler options for a debug build
VALAC_DEBUG_OPTS = -g --save-temps
#VALAC_DEBUG_OPTS =  -g 
# compiler options for a release build
VALAC_RELEASE_OPTS = -X -O2 --disable-assert 

 
#########################################################

EXEC_PREFIX = $(PREFIX)
DATADIR = $(PREFIX)/share

VALAC = valac --thread  -D $(ICON) \
				--Xcc="-lm" --Xcc="-DXK_TECHNICAL" --Xcc="-DXK_PUBLISHING" --Xcc="-DXK_APL"
VAPIDIR = --vapidir=vapi/ 

# Source files 
SRC = src/version.vala \
      src/main.vala \
      src/neo-window.vala \
      src/config-manager.vala

ifeq ($(WIN),)
VALAC_DEBUG_OPTS += -D _NO_WIN 
VALAC_RELEASE_OPTS += -D _NO_WIN
SRC += src/key-overlay.vala \
      src/unique.vala \
      src/keybinding-manager.vala \
      csrc/keysend.c \
      csrc/checkModifier.c
else
endif

# Asset files
ASSET_FILES=$(wildcard assets/**/*.png)

#test for valac version, workaround for Arch Linux bug
ifeq ($(wildcard /usr/include/gee-0.8),)
ifeq ($(wildcard /mingw64/include/gee-0.8),)
	GEEVERSION=1.0
else
	GEEVERSION=0.8
endif
else
	GEEVERSION=0.8
endif

# packges 
PKGS = --pkg x11 --pkg keysym --pkg gtk+-3.0 --pkg gee-$(GEEVERSION) --pkg gdk-x11-3.0 --pkg posix  --pkg unique-3.0 --pkg gdk-3.0

# Add some args if tray icon is demanded.
ifeq ($(ICON),tray)
SRC += src/tray.vala
endif
ifeq ($(ICON),indicator)
SRC += src/indicator.vala
PKGS += --pkg appindicator3-0.1
endif
 
.PHONY: debug release install clean last_build_env
# .FORCE: last_build_env


# the 'all' target build a debug build
all: $(BINDIR) info last_build_env $(BINDIR)/$(BINNAME)$(BINEXT)
	@echo "Done"

$(BINDIR)/$(BINNAME)$(BINEXT): $(SRC) Makefile
	make build_$(BUILD_TYPE)

# Remove binary if current env differs from last build env
# This toggles a rebuild.
last_build_env:
	@(test "$$(env|sort)" = "$$(test -f $(ENV_FILE) && cat $(ENV_FILE) )" \
		&& echo "Same environment as last build.") \
		|| (echo "Env has changed. Force build" \
		&& env | sort > "$(ENV_FILE)" \
		&& rm -f $(BINDIR)/$(BINNAME)$(BINEXT)\
		)

# the 'release' target builds a release build
# you might want disable asserts also
release: $(BINDIR) clean build_release

info:
	@echo " $(NL)"\
		"Buildtype: $(BUILD_TYPE)$(NL)" \
		"Trayicon: $(ICON)$(NL)" \
		"$(NL)" \
		"Notes:$(NL)" \
		"  Use 'ICON=... make' to switch type of panel menu.$(NL)" \
		"    indicator: For gnome 3.x (default)$(NL)" \
		"    tray: For gnome 2.x (default)$(NL)" \
		"    none: Disables icon$(NL)$(NL)" \
		"  Use 'BUILD_TYPE=[release|debug] make' to switch build type$(NL)$(NL)" \

gen_version:
	@echo "namespace NeoLayoutViewer{$(NL)" \
		"public const string GIT_COMMIT_VERSION = \"$(GIT_COMMIT_VERSION)\";$(NL)" \
		"public const string SHARED_ASSETS_PATH = \"$(DATADIR)/$(APPNAME)/assets\";$(NL)" \
		"}" \
		> src/version.vala

$(BINDIR):
	@mkdir -p $(BINDIR)
	@ln -s ../assets bin/assets

build_debug: gen_version 
	#	@echo $(VALAC) $(VAPIDIR) $(VALAC_DEBUG_OPTS) $(SRC) -o $(BINDIR)/$(BINNAME)$(BINEXT) $(PKGS) $(CC_INCLUDES)
	$(VALAC) $(VAPIDIR) $(VALAC_DEBUG_OPTS) $(SRC) -o $(BINDIR)/$(BINNAME)$(BINEXT) $(PKGS) $(CC_INCLUDES)

build_release: gen_version 
	$(VALAC) $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) -o $(BINDIR)/$(BINNAME)$(BINEXT) $(PKGS) $(CC_INCLUDES)

# Two staged compiling
build_release2: gen_version 
	$(VALAC) --ccode $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) $(PKGS) $(CC_INCLUDES)
	gcc $(SRC:.vala=.c) $(CC_INCLUDES) -o $(BINDIR)/$(BINNAME)$(BINEXT) \
		`pkg-config --cflags --libs gtk+-3.0 gee-$(GEEVERSION) unique-3.0`

build_win: gen_version 
	$(VALAC) $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) -o $(BINDIR)/$(BINNAME)$(BINEXT) $(PKGS) $(CC_INCLUDES)

build_cross_win: build_ccode
	echo "Flags: $(GCC_WIN_FLAGS)"
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
									$(VALAC) --ccode $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) $(PKGS) $(CC_INCLUDES)
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
									$(GCC_WIN) $(SRC:.vala=.c) -o $(BINDIR)/$(BINNAME)$(BINEXT) $(GCC_WIN_FLAGS)

install:
	test -f $(BINDIR)/$(BINNAME)$(BINEXT) || make all
	install -d $(EXEC_PREFIX)/bin
	install -D -m 0755 $(BINDIR)/$(BINNAME)$(BINEXT) $(EXEC_PREFIX)/bin
	$(foreach ASSET_FILE,$(ASSET_FILES), install -D -m 0644 $(ASSET_FILE) $(DATADIR)/$(APPNAME)/$(ASSET_FILE) ; )

uninstall:
	@rm -v $(EXEC_PREFIX)/bin/$(BINNAME)$(BINEXT)
	@rm -v -r $(DATADIR)/$(APPNAME)

# clean all build files
clean:
	@rm -v -fr *~ *.c src/*.c src/*~ 

run:
	bin/neo_layout_viewer
