#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Generate config
/usr/local/bin/demyx-config

# Install WordPress
/usr/local/bin/demyx-install

# OpenLiteSpeed admin
/usr/local/bin/demyx-admin

# OpenLiteSpeed htpasswd
/usr/local/bin/demyx-htpasswd

# Start OLS
/usr/local/bin/demyx-lsws

# Keeps container alive
tail -f "$DEMYX_LOG"/ols.access.log "$DEMYX_LOG"/ols.error.log
