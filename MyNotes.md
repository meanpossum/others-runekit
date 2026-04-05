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

