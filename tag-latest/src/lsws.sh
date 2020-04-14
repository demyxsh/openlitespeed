#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Set the default command to start
OPENLITESPEED_LSWS_COMMAND="${1:-start}"

sudo /usr/local/lsws/bin/lswsctrl "$OPENLITESPEED_LSWS_COMMAND"
