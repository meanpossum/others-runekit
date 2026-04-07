BUILDDIR := ./build/appdir
DEPLOYDIR := ./deploy

PIP := ./venv/bin/python3 -m pip

ARCH := $(shell uname -m)
LINUXDEPLOY ?= tools/linuxdeploy-$(ARCH).AppImage

$(LINUXDEPLOY):
	@echo "linuxdeploy not found; download it from https://github.com/linux$(DEPLOYDIR)/linux$(DEPLOYDIR)/releases"
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
$(BUILDDIR): dist/runekit.tar.gz
	# Create the AppDir structure
# 	rm -rf $(BUILDDIR)

	mkdir -p $(BUILDDIR)/usr/bin
	cp /usr/bin/python3 $(BUILDDIR)/usr/bin/

	mkdir -p $(BUILDDIR)/usr/lib
	cp -r /usr/lib/python3.9 $(BUILDDIR)/usr/lib/

	mkdir -p $(BUILDDIR)/usr/share/icons/hicolor/256x256/apps
	cp $(DEPLOYDIR)/python.png $(BUILDDIR)/usr/share/icons/hicolor/256x256/apps/
	cp $(DEPLOYDIR)/python.png $(BUILDDIR)/

	mkdir -p $(BUILDDIR)/usr/share/applications
	cp $(DEPLOYDIR)/RuneKit.desktop $(BUILDDIR)/usr/share/applications/

	mkdir -p $(BUILDDIR)/usr/share/metainfo
	cp $(DEPLOYDIR)/com.example.RuneKit.appdata.xml $(BUILDDIR)/usr/share/metainfo/
	
	cp $(DEPLOYDIR)/RuneKit.desktop $(BUILDDIR)/
	cp $(DEPLOYDIR)/runekit-appimage.sh $(BUILDDIR)/AppRun

dist/RuneKit.AppImage: dist/runekit.tar.gz $(BUILDDIR) $(DEPLOYDIR)/runekit-appimage.sh
	$(PIP) install dist/runekit.tar.gz
	$(LINUXDEPLOY) --appdir $(BUILDDIR) --output appimage
	cp RuneKit-*.AppImage "$@"

.PHONY: dev
