# CHANGELOG
Entries before tag-* affects all code-server tags.

## 2021-07-14
- Update default versions [1df48e2](https://github.com/demyxco/demyx/commit/1df48e214ac7f45b2e0215434b4baf8bbfc92607)

## 2021-03-07
### tag-bedrock
- Added
    - `bin/demyx-install`
- Changed
    - Renamed src to bin.
    - Renamed install.sh to demyx-install.
    - `bin/demyx-install`
        - Remove full paths to binaries.
    - `Dockerfile`
        - Remove full paths to binaries.
- Removed
### tag-latest
- Added
    - `bin/demyx-admin`
    - `bin/demyx-config`
    - `bin/demyx-encrypt`
    - `bin/demyx-entrypoint`
    - `bin/demyx-htpasswd`
    - `bin/demyx-install`
    - `bin/demyx-lsws`
- Changed
    - Renamed src to bin.
    - Renamed admin.sh to demyx-admin.
    - Renamed config.sh to demyx-config.
    - Renamed encrypt.sh to demyx-encrypt.
    - Renamed entrypoint.sh to demyx-entrypoint.
    - Renamed htpasswd.sh to demyx-htpasswd.
    - Renamed install.sh to demyx-install.
    - Renamed lsws.sh to demyx-lsws.
    - `bin/demyx-admin`
        - Remove full paths to binaries.
    - `bin/demyx-config`
        - Remove full paths to binaries.
        - Move WordPress rewrite rules to the bottom so the security rules works again.
    - `bin/demyx-encrypt`
        - Remove full paths to binaries.
    - `bin/demyx-entrypoint`
        - Remove full paths to binaries.
        - Prefix commands with sudo.
    - `bin/demyx-htpasswd`
        - Remove full paths to binaries.
    - `bin/demyx-install`
        - Remove full paths to binaries.
    - `bin/demyx-lsws`
        - Remove full paths to binaries.
    - `Dockerfile`
        - Update $PATH.
        - Remove full paths to binaries.
        - Add default version for OLS if wget fails. 
        - Update commands for sudo configuration.
        - Update commands for final RUN.
- Removed

## 2020-12-06
### Changed
- Missing user for su command
- Misc updates to docker-compose.yml
- tag-bedrock
    - Get composer as demyx user
    - Update Bedrock RUN commands
    - Clear /tmp
- tag-latest
    - Move RUN commands
    - Update RUN commands for configuring demyx
    - Update RUN commands for WordPress
    - Clear /tmp

## 2020-11-29
### Changed
- Alphabetized
- Misc updates
- Rename variables and support old ones
- ShellCheck approved
- Update Dockerfile RUN commands
- Use -E flag for sudo to keep environment variables
- Use full paths to binaries/scripts

## 2020-07-05
### Changed
- Update logic when installing WordPress
- Various misc updates

## 2020-07-02
### Changed
- Update OLS to 1.7.2
- Populate /demyx directory with WordPress/Bedrock files

## 2020-04-19
### Changed
- Update version to 1.7.1
- Bump OPENLITESPEED_TUNING_MAX_CONNECTIONS to 20000

## 2020-04-14
### Added
- Created src directory for main files
### Changed
- Set dumb-init as the shebang in the entrypoint
- Format LABEL and ENV entries
- Update finalize RUN commands
- Update ENTRYPOINT
- tag-latest
    - Update OpenLiteSpeed to 1.6.12
    - Update lsphp to 7.4
    - Update default OLS variables
- tag-bedrock
    - Use third party source to update php to 7.4
### Removed
