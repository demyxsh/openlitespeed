# CHANGELOG
Entries before tag-* affects all code-server tags.

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
