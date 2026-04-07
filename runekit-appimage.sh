#!/bin/bash

export QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu --disable-gpu-sandbox --no-sandbox"
export QT_QPA_PLATFORM=xcb
export QT_LOGGING_RULES="runekit*=true"

exec "venv/bin/python3" main.py "$@"
