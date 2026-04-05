# My notes

## Make / Install

```bash
poetry lock
poetry install
poetry run make dev
```

## Run

```bash
poetry run python main.py
```

But because I have discrete Nvidia GPU, QT will grab it and display transparent windows.

To force using AMD GPU

```bash
env 'QTWEBENGINE_CHROMIUM_FLAGS=--disable-gpu --disable-gpu-sandbox --no-sandbox' 'QT_QPA_PLATFORM=xcb' poetry run python main.py
```

## build AppImage

```bash
APPDIR="runekit.AppDir"
mkdir -p ${APPDIR}/usr/bin
cp -r /usr/bin/python3.9 ${APPDIR}/usr/bin/python
ln -s ${APPDIR}/usr/bin/python ${APPDIR}/usr/bin/python3
ln -s ${APPDIR}/usr/bin/python ${APPDIR}/usr/bin/python3.9

mkdir -p ${APPDIR}/usr/lib/python3.9
cp -r /usr/lib/python3.9/* ${APPDIR}/usr/lib/python3.9/

mkdir -p ${APPDIR}/usr/lib/python3.9/site-packages
cp -r venv/lib/python3.9/site-packages/* ${APPDIR}/usr/lib/python3.9/site-packages/

mkdir -p ${APPDIR}/usr/share/applications/
cp deploy/RuneKit.desktop ${APPDIR}/usr/share/applications
ln -s ${APPDIR}/usr/share/applications/RuneKit.desktop ${APPDIR}/RuneKit.desktop
cp deploy/runekit-appimage.sh ${APPDIR}/AppRun

make dist/runekit.tar.gz
make build/python3.9.7.AppImage
make build/appdir
wget -c https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
./appimagetool-x86_64.AppImage runekit.AppDir

```
