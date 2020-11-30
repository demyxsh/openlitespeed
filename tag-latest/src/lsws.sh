#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Set the default command to start
DEMYX_LSWS_COMMAND="${1:-start}"

/usr/bin/sudo /usr/local/lsws/bin/lswsctrl "$DEMYX_LSWS_COMMAND"
