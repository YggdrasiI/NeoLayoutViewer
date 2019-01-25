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

# Prefix for package name generation
PACKAGE_NAME=neo-layout-viewer

GIT_COMMIT_VERSION=$(shell git log --oneline --max-count=1 | head --bytes=7)
ENV_FILE=.build_env

# compiler options for a debug build
#VALAC_DEBUG_OPTS = -g --save-temps
VALAC_DEBUG_OPTS = -g
# compiler options for a release build
VALAC_RELEASE_OPTS = -X -O2 --disable-assert

# Debian Packaging version number
# Pattern: [epoch:]upstream_version[-debian_revision].
# The absence of a debian_revision is equivalent to a debian_revision of 0.
RELEASE_VERSION=$(shell sed -n "/^$(PACKAGE_NAME)\s*(\([^()]*\)[)].*/{ s//\1/p; q0 }; q1" debian/changelog || echo -n "undefined" )
#Token for .orig.tar.gz-files: dpkg-source request upstream tarball without revision substring
SRC_VERSION=$(shell echo -n "$(RELEASE_VERSION)" | cut -d\- -f 1)
DISTDIR = dist
TMPDIR = tmp
DIST = stretch
ARCHS = amd64 i386
MIRROR = http://ftp.de.debian.org/debian
BASETGZ_DIR = /var/cache/pbuilder

#########################################################

# Test build under MingW for Windows
WIN ?=

ifeq ($(WIN),)
NL = \n
BINEXT = 
else
BUILD_TYPE = win
BINEXT = .exe
ICON = tray
GTK_PREBUILD_ZIP=http://win32builder.gnome.org/gtk+-bundle_3.10.4-20131202_win64.zip
GEE_XZ=https://ftp.gnome.org/pub/gnome/sources/libgee/0.8/libgee-0.8.8.tar.xz
PKG_CONFIG_PATH=$(shell pwd)/win/lib/pkgconfig
#PKG_CONFIG_PATH=${HOME}/software/gtk/gtk+-3.10_win64/lib/pkgconfig
GCC_WIN = x86_64-w64-mingw32-gcc
GCC_WIN_FLAGS = -mwindows $(shell PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" pkg-config --cflags --libs gtk+-3.0 gee-$(GEEVERSION))
VALAC_RELEASE_OPTS += -D _OLD_GTK_STOCK  # Old gtk-versions (<3.16) do not define `gtk_label_set_xalign`
VALAC_DEBUG_OPTS += -D _OLD_GTK_STOCK
endif


#########################################################

EXEC_PREFIX = $(PREFIX)
DATADIR = $(PREFIX)/share

VALAC = valac -D $(ICON) \
				--Xcc="-lm" --Xcc="-DXK_TECHNICAL" --Xcc="-DXK_PUBLISHING" --Xcc="-DXK_APL"
VAPIDIR = --vapidir=vapi/

# Source files
SRC = src/version.vala \
			src/main.vala \
			src/app.vala \
			src/neo-window.vala \
			src/config-manager.vala

ifeq ($(WIN),)
VALAC_DEBUG_OPTS += -D _NO_WIN
VALAC_RELEASE_OPTS += -D _NO_WIN
SRC += src/key-overlay.vala \
			 src/keybinding-manager.vala \
			 csrc/keysend.c \
			 csrc/checkModifier.c
endif

# Asset files
ASSET_FILES=$(wildcard assets/**/*.png)

# Test for valac version, workaround for Arch Linux bug
ifeq ($(wildcard /usr/include/gee-0.8),)
# Similar, but for Windows/MingW
ifeq ($(wildcard /mingw64/include/gee-0.8),)
	GEEVERSION=1.0
else
	GEEVERSION=0.8
endif
else
	GEEVERSION=0.8
endif

# Packages
PKGS = --pkg x11 --pkg keysym --pkg gtk+-3.0 --pkg gee-$(GEEVERSION) --pkg gdk-x11-3.0 --pkg posix  --pkg gdk-3.0

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


# The target respects BUILD_TYPE and cleaning if it changes
all: info last_build_env "$(BINDIR)/$(BINNAME)$(BINEXT)"
	@echo "Done"

"$(BINDIR)/$(BINNAME)$(BINEXT)": $(SRC) Makefile "$(BINDIR)"
	make build_$(BUILD_TYPE)

# Remove binary if current env differs from last build env
# This toggles a rebuild.
last_build_env:
	@(test "$$(env|sort)" = "$$(test -f $(ENV_FILE) && cat $(ENV_FILE) )" \
		&& echo "Same environment as last build.") \
		|| (echo "Env has changed. Force build" \
		&& make clean \
		&& env | sort > "$(ENV_FILE)" \
		)

# Clean release build, similar to 'BUILD_TYPE=release make all'
release: clean build_release

info:
	@/bin/echo -e " $(NL)"\
		"Buildtype: $(BUILD_TYPE)$(NL)" \
		"Trayicon: $(ICON)$(NL)" \
		"$(NL)" \
		"Notes:$(NL)" \
		"  Use 'ICON=... make' to switch type of panel menu.$(NL)" \
		"    indicator: For gnome 3.x (default)$(NL)" \
		"    tray: For gnome 2.x (default)$(NL)" \
		"    none: Disables icon$(NL)$(NL)" \
		"  Use 'BUILD_TYPE=[release|debug] make' to switch build type$(NL)$(NL)" \

src/version.vala: Makefile gen_version

gen_version:
	@/bin/echo -e "namespace NeoLayoutViewer{$(NL)" \
		"public const string RELEASE_VERSION = \"$(RELEASE_VERSION)\";$(NL)" \
		"public const string GIT_COMMIT_VERSION = \"$(GIT_COMMIT_VERSION)\";$(NL)" \
		"public const string SHARED_ASSETS_PATH = \"$(DATADIR)/$(APPNAME)/assets\";$(NL)" \
		"}" \
		> src/version.vala

"$(BINDIR)":
	@test -d "$(BINDIR)" || \
		(mkdir -p "$(BINDIR)" && ln -s ../assets "$(BINDIR)/assets")

"$(DISTDIR)":
	@test -d "$(DISTDIR)" || \
		(mkdir -p "$(DISTDIR)")

"$(TMPDIR)":
	@test -d "$(TMPDIR)" || \
		(mkdir -p "$(TMPDIR)")

build_debug: $(SRC) "$(BINDIR)"
	$(VALAC) $(VAPIDIR) $(VALAC_DEBUG_OPTS) $(SRC) -o "$(BINDIR)/$(BINNAME)$(BINEXT)" $(PKGS) $(CC_INCLUDES)

build_release: $(SRC) "$(BINDIR)"
	$(VALAC) $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) -o "$(BINDIR)/$(BINNAME)$(BINEXT)" $(PKGS) $(CC_INCLUDES)

# Two staged compiling
build_release2: $(SRC) "$(BINDIR)"
	$(VALAC) --ccode $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) $(PKGS) $(CC_INCLUDES)
	gcc $(SRC:.vala=.c) $(CC_INCLUDES) -o "$(BINDIR)/$(BINNAME)$(BINEXT)" \
		`pkg-config --cflags --libs gtk+-3.0 gee-$(GEEVERSION)`

man: man/neo_layout_viewer.1.gz

man/%.gz: man/%
	gzip -c "$<" > "$@"

install: man
	test -f "$(BINDIR)/$(BINNAME)$(BINEXT)" || make all
	install -d $(EXEC_PREFIX)/bin
	install -D -m 0755 "$(BINDIR)/$(BINNAME)$(BINEXT)" "$(EXEC_PREFIX)/bin"
	$(foreach ASSET_FILE,$(ASSET_FILES), \
		install -D -m 0644 $(ASSET_FILE) "$(DATADIR)/$(APPNAME)/$(ASSET_FILE)" ; )
	install -d $(PREFIX)/share/man/man1/
	install -t $(PREFIX)/share/man/man1/ man/neo_layout_viewer.1.gz

uninstall:
	@rm -fv "$(EXEC_PREFIX)/bin/$(BINNAME)$(BINEXT)"
	@test -d "$(DATADIR)/$(APPNAME)/assets" && rm -v -r "$(DATADIR)/$(APPNAME)"
# Prefixed with test because of dangerous -r-flag...
	@rm -fv $(PREFIX)/share/man/man1/neo_layout_viewer.1.gz

# clean all build files, but not dist results.
clean:
	@rm -v -d -f *~ *.c src/*.c src/*~ "$(BINDIR)"/* "$(BINDIR)" "$(ENV_FILE)"
	@rm -v -d -f -r "$(TMPDIR)"/*
	@rm -v -d -f "$(TMPDIR)"
	@rm -v -f man/*.gz

run:
	"$(BINDIR)/$(BINNAME)$(BINEXT)"

######################################################
## Targets for .*deb build

src-package: "$(DISTDIR)"
	tar czf "$(DISTDIR)"/neo-layout-viewer_$(RELEASE_VERSION)-src.tar.gz \
		--exclude=.git --exclude=.gitignore --exclude=win \
		--exclude=bin --exclude=man/*.gz --exclude=.pc\
		--exclude=dist --exclude=tmp \
		--transform 's,^\./,neo-layout-viewer-$(RELEASE_VERSION)/,' \
		.

dist-package: "$(DISTDIR)" release man
	tar czf "$(DISTDIR)"/neo-layout-viewer_$(RELEASE_VERSION).tgz \
		--transform 's,^$(BINDIR)/,,' \
		--transform 's,^,neo-layout-viewer-$(RELEASE_VERSION)/,' \
		"$(BINDIR)/$(BINNAME)" assets AUTHORS COPYING README.md \
		man/*.gz

deb-packages: "$(TMPDIR)" "$(DISTDIR)" src-package
	cp "$(DISTDIR)"/neo-layout-viewer_$(RELEASE_VERSION)-src.tar.gz "$(TMPDIR)"/neo-layout-viewer_$(SRC_VERSION).orig.tar.gz && \
		cd "$(TMPDIR)" && \
		tar xzf neo-layout-viewer_$(SRC_VERSION).orig.tar.gz && \
		cd neo-layout-viewer-$(RELEASE_VERSION) && \
		for arch in $(ARCHS); do \
		  sudo mkdir -p $(BASETGZ_DIR)/$(DIST)-aptcache/ && \
			sudo pbuilder update --override-config --distribution "$(DIST)" --mirror "$(MIRROR)" --architecture $$arch --basetgz $(BASETGZ_DIR)/$(DIST)-$$arch-base.tgz --aptcache $(BASETGZ_DIR)/$(DIST)-aptcache/ || \
			sudo pbuilder create --override-config --distribution $(DIST) --mirror $(MIRROR) --architecture $$arch --basetgz $(BASETGZ_DIR)/$(DIST)-$$arch-base.tgz --aptcache $(BASETGZ_DIR)/$(DIST)-aptcache/ && \
			DEB_BUILD_OPTIONS="noautodbgsym" pdebuild --buildresult .. --debbuildopts "-i -us -uc -b" -- --override-config --distribution $(DIST) --mirror $(MIRROR) --architecture $$arch --basetgz $(BASETGZ_DIR)/$(DIST)-$$arch-base.tgz --aptcache $(BASETGZ_DIR)/$(DIST)-aptcache/ && \
			mv ../neo-layout-viewer*deb ../../dist/ ; \
		done

deb-package: "$(TMPDIR)" "$(DISTDIR)" src-package
	cp "$(DISTDIR)"/neo-layout-viewer_$(RELEASE_VERSION)-src.tar.gz "$(TMPDIR)"/neo-layout-viewer_$(SRC_VERSION).orig.tar.gz && \
		cd "$(TMPDIR)" && \
		tar xzf neo-layout-viewer_$(SRC_VERSION).orig.tar.gz && \
		cd neo-layout-viewer-$(RELEASE_VERSION) && \
		DEB_BUILD_OPTIONS="noautodbgsym" pdebuild --buildresult .. --debbuildopts "-i -us -uc -b" && \
		mv ../neo-layout-viewer*deb ../../dist/

dist: src-package dist-package deb-packages

######################################################
## Windows stuff

# Building under MingW
build_win: $(SRC)
	$(VALAC) $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) -o "$(BINDIR)/$(BINNAME)$(BINEXT)" $(PKGS) $(CC_INCLUDES)

# Cross compiling under Debian/Ubuntu
build_cross_win: bin/libgtk-3-0.dll
	test "$(WIN)" = "1" || (echo "Call this target with WIN=1" && exit 1)
	echo "Flags: $(GCC_WIN_FLAGS)"
	PKG_CONFIG_PATH="$(PKG_CONFIG_PATH)" \
									$(VALAC) --ccode $(VAPIDIR) $(VALAC_RELEASE_OPTS) $(SRC) $(PKGS) $(CC_INCLUDES)
	PKG_CONFIG_PATH="$(PKG_CONFIG_PATH), \
									$(GCC_WIN) $(SRC:.vala=.c) -o "$(BINDIR)/$(BINNAME)$(BINEXT)" $(GCC_WIN_FLAGS)

bin/libgtk-3-0.dll:
	WIN=1 make win_gtk

win_download_gtk:
	test "$(WIN)" = "1" || (echo "Call this target with WIN=1" && exit 1)
	test -d win || mkdir win
	test -f win/$$(basename "$(GTK_PREBUILD_ZIP)") || \
		( cd win && wget -c "$(GTK_PREBUILD_ZIP), && \
		unzip $$(basename "$(GTK_PREBUILD_ZIP)") )
	cd win && find -name '*.pc' | while read pc; do sed -e "s@^prefix=.*@prefix=$$PWD@" -i "$$pc"; done

win_build_gee:
	test "$(WIN)" = "1" || (echo "Call this target with WIN=1" && exit 1)
	cd win && wget -c "$(GEE_XZ)" && \
		tar xJvf ./libgee-0.8.8.tar.xz > /dev/null
	cd win/libgee-0.8.8 && \
		sed -i -e 's/if test ".cross_compiling" != yes; then/if test 0 != 0; then/' ./configure
	cd win/libgee-0.8.8 && \
		PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) CC=$(GCC_WIN) \
		CC_FLAGS="$(GCC_WIN_FLAGS)" \
		./configure --build=x86_64 --prefix=$(PKG_CONFIG_PATH)/../.. && \
		make && make install

win_gtk: win_download_gtk win_build_gee
	test "$(WIN)" = "1" || (echo "Call this target with WIN=1" && exit 1)
	cp win/bin/*.dll bin/.

print_version:
	@echo "Source archive: $(PACKAGE_NAME)_$(SRC_VERSION).orig.tar.gz"
	@echo "Deb file: $(PACKAGE_NAME)_$(RELEASE_VERSION)_$(dpkg --print-architecture).deb"
