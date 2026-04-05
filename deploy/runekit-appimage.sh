#!/bin/bash

self="$(readlink -f -- "$0")"
here="${self%/*}"
APPDIR="${APPDIR:-${here}}"

# If you later bundle a certs.pem, you can export:
# export SSL_CERT_FILE="${APPDIR}/usr/share/runekit/certs.pem"

# Your Python lives here:
export PYTHONHOME="${APPDIR}"

# Your entry point is python3 main.py, not a compiled 'runekit' binary:
export PYTHONPATH="${APPDIR}/usr/lib/python3.9/site-packages"

exec "${APPDIR}/usr/bin/python3" "${APPDIR}/../main.py" "$@"
