# openlitespeed
[![demyxsh/openlitespeed](https://github.com/demyxsh/openlitespeed/actions/workflows/main.yml/badge.svg)](https://github.com/demyxsh/openlitespeed/actions/workflows/main.yml)
[![Code Size](https://img.shields.io/github/languages/code-size/demyxsh/openlitespeed?style=flat&color=blue)](https://github.com/demyxsh/openlitespeed)
[![Repository Size](https://img.shields.io/github/repo-size/demyxsh/openlitespeed?style=flat&color=blue)](https://github.com/demyxsh/openlitespeed)
[![Watches](https://img.shields.io/github/watchers/demyxsh/openlitespeed?style=flat&color=blue)](https://github.com/demyxsh/openlitespeed)
[![Stars](https://img.shields.io/github/stars/demyxsh/openlitespeed?style=flat&color=blue)](https://github.com/demyxsh/openlitespeed)
[![Forks](https://img.shields.io/github/forks/demyxsh/openlitespeed?style=flat&color=blue)](https://github.com/demyxsh/openlitespeed)
[![Docker Pulls](https://img.shields.io/docker/pulls/demyx/openlitespeed?style=flat&color=blue)](https://hub.docker.com/r/demyx/openlitespeed)
[![Architecture](https://img.shields.io/badge/linux-amd64-important?style=flat&color=blue)](https://hub.docker.com/r/demyx/openlitespeed)
[![Debian](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/openlitespeed/raw/master/version.json&label=debian&query=$.debian&color=blue)](https://hub.docker.com/r/demyx/openlitespeed)
[![OpenLiteSpeed](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/openlitespeed/raw/master/version.json&label=openlitespeed&query=$.openlitespeed&color=blue)](https://hub.docker.com/r/demyx/openlitespeed)
[![lsphp](https://img.shields.io/badge/dynamic/json?url=https://github.com/demyxsh/openlitespeed/raw/master/version.json&label=lsphp&query=$.lsphp&color=blue)](https://hub.docker.com/r/demyx/openlitespeed)
[![Buy Me A Coffee](https://img.shields.io/badge/buy_me_coffee-$5-informational?style=flat&color=blue)](https://www.buymeacoffee.com/VXqkQK5tb)
[![Become a Patron!](https://img.shields.io/badge/become%20a%20patron-$5-informational?style=flat&color=blue)](https://www.patreon.com/bePatron?u=23406156)

Non-root Docker image running Debian and OpenLiteSpeed.

To properly utilize this image, please use [Demyx](https://demyx.sh/readme).
- Repository - [demyxsh/demyx](https://github.com/demyxsh/demyx)
- Homepage - [demyx.sh](https://demyx.sh)

[![Demyx Discord](https://discordapp.com/api/guilds/1152828583446859818/widget.png?style=banner2)](https://demyx.sh/discord)

Join us on Discord for latest news, faster support, or just chill.

<a href="https://demyx.sh/sponsor-buymeacoffee" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

Support this project by buying coffee (please).

## PHP Security

This update addresses [CVE-2026-109618](https://github.com/php/php-src/security/advisories/GHSA-w8hw-w9fx-j79w) and [CVE-2026-109619](https://github.com/php/php-src/security/advisories/GHSA-6wmf-4rv5-p3rp) ([PHP advisory](https://www.php.net/archive/2026.php#2026-10-21-5)). The image uses the fixed `php:8.4.27-cli-bookworm` base while retaining LiteSpeed PHP 8.3 and 8.4 for web requests. PHP 8.3.36 and PHP 8.4.27 are the respective minimums. CLI, LSAPI, admin, and fallback launchers are checked during the build, which fails if a binary has an older or unexpected runtime.

This repository change does not patch existing images or running workers. Rebuild with the image references used by your Compose configuration, then recreate containers. With current Demyx, set `DEMYX_APP_OLS_LSPHP=8.4` because new-site configuration defaults to PHP 8.5, which this image does not provide.

```sh
OLS_VERSION=1.11.0 # Set to the version referenced by your Compose configuration.
docker build --pull --no-cache \
  -t demyx/openlitespeed:latest \
  -t "demyx/openlitespeed:${OLS_VERSION}" \
  -t demyx/openlitespeed:v1 \
  tag-latest
docker build --no-cache \
  -t demyx/openlitespeed:bedrock \
  -t "demyx/openlitespeed:${OLS_VERSION}-bedrock" \
  -t demyx/openlitespeed:v1-bedrock \
  tag-bedrock
docker compose up -d --force-recreate
```

Build `tag-latest` first; Bedrock must use that freshly built local base, so do not pull the Bedrock base before the patched parent is published. Versioned deployments need matching image tags and will not use a latest-only build.

The runtime contract remains unchanged: PHP selection still supports branches 8.3 and 8.4; environment variables, image variants, entrypoint and command interfaces, ports 80/8080, compose paths, the non-root `demyx` UID 1000, and `/demyx`, `/etc/demyx/custom`, and `/var/log/demyx` mounts are preserved. The base OS moves to Debian 12 Bookworm. Official PHP CLI and LiteSpeed LSAPI remain separate runtimes; the PHP CLI base does not replace the site-request interpreter.
