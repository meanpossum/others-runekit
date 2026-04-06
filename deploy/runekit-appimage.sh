#!/bin/bash

self="$(readlink -f -- "$0")"
here="$(dirname "$self")"
APPDIR="${APPDIR:-$here}"

export QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu --disable-gpu-sandbox --no-sandbox"
export QT_QPA_PLATFORM=xcb
export QT_LOGGING_RULES="runekit*=true"

export PYTHONHOME="$APPDIR"
export PYTHONPATH="$APPDIR/usr/lib/python3.9/site-packages"

exec "$APPDIR/usr/bin/python3" -m runekit.main "$@"
