ARCH := $(shell uname -m)
LINUXDEPLOY ?= tools/linuxdeploy-$(ARCH).AppImage

$(LINUXDEPLOY):
	@echo "linuxdeploy not found; download it from https://github.com/linuxdeploy/linuxdeploy/releases"
	@echo "and put it as:"; \
	echo "  $@"; \
	exit 1

dev: runekit/_resources.py

runekit/_resources.py: resources.qrc $(wildcard runekit/**/*.js) $(wildcard runekit/**/*.png)
	pyside2-rcc $< -o $@

# Sdist

dist/runekit.tar.gz: main.py poetry.lock runekit/_resources.py $(wildcard runekit/**/*)
	poetry build -f sdist
	cd dist; cp runekit-*.tar.gz runekit.tar.gz

# Mac

dist/RuneKit.app: RuneKit.spec main.py poetry.lock runekit/_resources.py $(wildcard runekit/**/*)
	pyinstaller -w -n RuneKitApp --noconfirm \
		--exclude-module tkinter \
		-s -d noarchive \
		--osx-bundle-identifier de.cupco.runekit \
		$<

dist/RuneKit.app.zip: dist/RuneKit.app
	cd dist; zip -r -9 RuneKit.app.zip RuneKit.app

# AppImage

build/python3.9.1.AppImage:
	mkdir build || true
	wget https://github.com/niess/python-appimage/releases/download/python3.9/python3.9.25-cp39-cp39-manylinux2014_x86_64.AppImage -O "$@"
	chmod +x "$@"

build/appdir: build/python3.9.1.AppImage
	$< --appimage-extract
	mv squashfs-root build/appdir

	# Copy real Python into usr/bin
	cp build/appdir/opt/python3.9/bin/python3.9 build/appdir/usr/bin/python3.9
	cp build/appdir/opt/python3.9/bin/python3   build/appdir/usr/bin/python3

dist/RuneKit.AppImage: dist/runekit.tar.gz build/appdir deploy/runekit-appimage.sh
	build/appdir/usr/bin/python3 -m pip install dist/runekit.tar.gz
	rm $(wildcard build/appdir/*.desktop) $(wildcard build/appdir/usr/share/applications/*.desktop) $(wildcard build/appdir/usr/share/metainfo/*)
	cp deploy/RuneKit.desktop build/appdir/
	cp deploy/RuneKit.desktop build/appdir/usr/share/applications/
	cp deploy/RuneKit.appdata.xml build/appdir/usr/share/metainfo/
	cp deploy/runekit-appimage.sh build/appdir/AppRun
	$(LINUXDEPLOY) --appdir build/appdir --output appimage
	cp RuneKit-*.AppImage "$@"

.PHONY: dev
