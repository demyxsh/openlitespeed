# Changelog

## 2026-05-14
### Added
- None.
### Changed
- Removed hardcoded LSPHP version paths and consolidated version tracking to a single LSPHP variant.
- Scheduled build run.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2026-05-11
### Added
- Added improved debug output for container tests.
### Changed
- Simplified GitHub Actions tests.
- Normalized LSPHP version handling.
- Pinned Acorn dependency.
- Updated GitHub Actions workflow with newer action versions.
- Increased test sleep timers.
- Scheduled build run.
### Fixed
- Improved container health checks with better logging and more flexible test conditions.
### Removed
- None.
### Security
- None.

## 2026-05-09
### Added
- Added fallback logic for `wp package install aaemnnosttv/wp-cli-login-command` to handle GitHub auth/rate-limit failures during build.
### Changed
- Updated `tag-latest` base image from PHP 8.3 to PHP 8.4 and set default `DEMYX_LSPHP` to `lsphp84`.
- Updated `tag-latest/bin/demyx-config` to default to `lsphp84` and support `8.4` input.
- Updated `compose.yml` and `tag-bedrock/compose.yml` default `DEMYX_LSPHP` from `lsphp82` to `lsphp84`.
- Scheduled build run.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2026-02-13
### Added
- None.
### Changed
- Updated logic to fetch latest OpenLiteSpeed version from the downloads page.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2025-08-19
### Added
- None.
### Changed
- Updated GitHub Actions workflow to use PHP 8.2 and 8.3 for OpenLiteSpeed version detection.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2025-07-28
### Added
- None.
### Changed
- Renamed compose files.
- Moved internal files and logic around.
- Allowed user overrides for configs.
- Updated case statement behavior.
- Ran `chown` in background.
- Restarted OLS after log rotation and when entrypoint is re-executed.
- Used PHP binary to trigger `wp-cron.php`.
- Switched to full paths and removed shorthand usage.
- Updated sudoers configuration.
- Updated project/support messaging.
- Bumped versions.
- Updated GitHub Actions scheduled build commit message format to include run ID.
- Updated Dockerfile for PHP 8.3/lsphp83 and installation/version detection flow.
### Fixed
- Added subshell error checking.
- Fixed WordPress URL reachability during build.
### Removed
- Removed old variables.
- Removed deprecated install checks and obsolete lines.
### Security
- None.

## 2024-11-05
### Added
- Added symlink to switch LSPHP version.
### Changed
- Updated `pgrep` string logic.
- Bumped version metadata.
### Fixed
- Removed problematic line breaks and echo string usage.
### Removed
- Removed old variables.
### Security
- None.

## 2024-03-05
### Added
- None.
### Changed
- Removed shorthand usage causing container crashes.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2024-02-28
### Added
- Allowed users to add custom cron.
- Included missing create rule.
- Added new core packages.
- Added and updated environment variables.
- Added function to reset permissions at startup and hourly cron.
- Added function to auto-calculate `LSAPI_EXTRA_CHILDREN` and `LSAPI_MAX_IDLE_CHILDREN`.
### Changed
- Updated base image to Bullseye and set PHP to 8.1.
- Updated LSPHP versions and defaulted to 8.1.
- Used `tidy` to scrape latest stable OLS version.
- Included custom volume support.
- Restored wp-cli as main wp-cron with delay.
- Updated sed handling for `WP_HOME`.
- Updated description/support messaging.
- Misc updates.
### Fixed
- Fixed reboot container crash.
- Fixed wrong link.
- Doubled upload limit.
- Fixed rewrite rule for specific strings.
### Removed
- None.
### Security
- None.

## 2023-11-14
### Added
- None.
### Changed
- Disabled installation of default themes/plugins when upgrading.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2023-09-20
### Added
- None.
### Changed
- Prepared configuration for Redis.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2023-09-03
### Added
- Added `DEMYX_CRON_TYPE` variable.
### Changed
- None.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2023-08-28
### Added
- Added `lsphp81`.
### Changed
- Updated logrotate configuration.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2023-08-23
### Added
- Added new scripts.
- Added `aaemnnosttv/wp-cli-login-command` package support.
- Added missing LSPHP package.
- Added new packages.
- Added new variables.
- Added HTTPS labels.
### Changed
- Updated test commands.
- Updated variable values and formatting.
- Switched to PHP Bullseye image.
- Set fallback for OLS version.
- Updated YML.
- Misc updates.
### Fixed
- Fixed echo usage issue.
### Removed
- Purged unused package.
### Security
- None.

## 2022-08-05
### Added
- Added fallback for LSPHP versions.
- Added wp-cli in the image.
- Added `lsphp81` in the image.
- Added `default-mysql-client` as core package.
### Changed
- Renamed environment variable and set `lsphp80` as default.
- Updated to Debian Bullseye.
- Misc updates.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2022-01-22
### Added
- None.
### Changed
- Used `curl` to fetch tarball.
### Fixed
- None.
### Removed
- Removed default version.
### Security
- None.

## 2021-07-14
### Added
- None.
### Changed
- Updated default versions.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2021-03-07
### Added
- Added `bin/demyx-install` in `tag-bedrock`.
- Added `bin/demyx-admin`, `bin/demyx-config`, `bin/demyx-encrypt`, `bin/demyx-entrypoint`, `bin/demyx-htpasswd`, `bin/demyx-install`, and `bin/demyx-lsws` in `tag-latest`.
### Changed
- Renamed `src` to `bin` and renamed scripts to `demyx-*` variants.
- Removed full binary paths across scripts.
- Updated Dockerfile path handling and sudo/final RUN commands.
- Moved WordPress rewrite rules order in `demyx-config` to restore security behavior.
- Added default OLS version fallback when `wget` fails.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-12-06
### Added
- None.
### Changed
- Updated user handling for `su` command.
- Updated compose behavior and RUN command flow in both tags.
- Cleared `/tmp` in both tag build flows.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-11-29
### Added
- None.
### Changed
- Alphabetized configuration and variables.
- Renamed variables and supported old names.
- Updated Dockerfile RUN commands.
- Used full paths to binaries/scripts.
- Used `sudo -E` for environment variable preservation.
- Misc updates.
### Fixed
- ShellCheck compliance improvements.
### Removed
- None.
### Security
- None.

## 2020-07-05
### Added
- None.
### Changed
- Updated WordPress install logic.
- Various misc updates.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-07-02
### Added
- None.
### Changed
- Updated OpenLiteSpeed to `1.7.2`.
- Populated `/demyx` with WordPress/Bedrock files.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-04-19
### Added
- None.
### Changed
- Updated version to `1.7.1`.
- Increased `OPENLITESPEED_TUNING_MAX_CONNECTIONS` to `20000`.
### Fixed
- None.
### Removed
- None.
### Security
- None.

## 2020-04-14
### Added
- Created `src` directory for main files.
### Changed
- Set `dumb-init` as entrypoint shebang.
- Formatted `LABEL` and `ENV` entries.
- Updated final `RUN` commands.
- Updated `ENTRYPOINT`.
- Updated `tag-latest` to OpenLiteSpeed `1.6.12` and `lsphp7.4` defaults.
- Updated `tag-bedrock` PHP source for 7.4.
### Fixed
- None.
### Removed
- None.
### Security
- None.
