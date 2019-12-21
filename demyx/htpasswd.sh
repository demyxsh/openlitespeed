#!/bin/bash
# Demyx
# https://demyx.sh
set -euo pipefail

# Encrypt basic auth password
# Default username: demyx
# Default password: demyx
OPENLITESPEED_BASIC_AUTH_PASSWORD_ENCRYPTED="$(demyx-encrypt "$OPENLITESPEED_BASIC_AUTH_PASSWORD")"
echo "${OPENLITESPEED_BASIC_AUTH_USERNAME}:${OPENLITESPEED_BASIC_AUTH_PASSWORD_ENCRYPTED}" > "$OPENLITESPEED_CONFIG"/ols/htpasswd
chown nobody:nogroup "$OPENLITESPEED_CONFIG"/ols/htpasswd
chmod 600 "$OPENLITESPEED_CONFIG"/ols/htpasswd
