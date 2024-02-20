# CHANGELOG
Entries before tag-* affects all code-server tags.

## 2024-02-20
- Allow users to add custom cron [6dc1c1b](https://github.com/demyxsh/openlitespeed/commit/6dc1c1b1ec2b9ea9bbe892c4d7ac8f927d576a34)
- Include missing create rule [b20ad02](https://github.com/demyxsh/openlitespeed/commit/b20ad02f065e3051fd69ce71305a8bd380371743)
- 2024-02-08 [20ce045](https://github.com/demyxsh/openlitespeed/commit/20ce0458bf86d5bb22921f21a580f0d72ffae79e)
- Update shameless plug [dc4d291](https://github.com/demyxsh/openlitespeed/commit/dc4d2919c1b344ed963d560e6c4ac75b7f1870f3)
- Double upload limit [4aa1aed](https://github.com/demyxsh/openlitespeed/commit/4aa1aed69e6c803eac5390f6fffdb76ad1fc3fd5)
- Fix wrong link [ac4dbe2](https://github.com/demyxsh/openlitespeed/commit/ac4dbe21acfe9b603649cb4b3a0b8abee7b36b86)
- 2024-02-07 [4858c1d](https://github.com/demyxsh/openlitespeed/commit/4858c1d50ac25b072b4c1823d6b6daa261c2af74)
- Update description with shameless plug and support link [3a244ae](https://github.com/demyxsh/openlitespeed/commit/3a244ae647b065e73f5bdceb394c80cb9ecb53c0)
- Merge branch 'master' of github.com:demyxsh/openlitespeed [760df80](https://github.com/demyxsh/openlitespeed/commit/760df80aff4e5aba37c0cee4eeadd41f155f0706)
- Misc updates [a778363](https://github.com/demyxsh/openlitespeed/commit/a7783636ef0b5c39134d8108560b50643a5c593b)
- Update lsphp versions and set default to 8.1 [d89aa48](https://github.com/demyxsh/openlitespeed/commit/d89aa4885a284c4dc6077549341d6732ffb51554)
- Use tidy package to scrape the latest stable version in openlitespeed's downloads page [6144e43](https://github.com/demyxsh/openlitespeed/commit/6144e43075bafcf74b58b0d5a3b4d16b95a186a9)
- Add new core packages [089c0ef](https://github.com/demyxsh/openlitespeed/commit/089c0efe81cf11190cd08048f2133f205097f145)
- Update base image to bullseye and set php to 8.1 [00f1238](https://github.com/demyxsh/openlitespeed/commit/00f1238c413ad20d4b4cca994f789fa7bfa8c7d6)
- Include custom volume [7540bdc](https://github.com/demyxsh/openlitespeed/commit/7540bdc284a7d653c3dbb13c6d7436b1ebfc5ea0)
- Add/update/remove environment variables [e1b9d9d](https://github.com/demyxsh/openlitespeed/commit/e1b9d9d9e54dbe4e377e53d3cd8c04c6573ec518)
- New function to reset permissions at container start and hourly cron [2218a7b](https://github.com/demyxsh/openlitespeed/commit/2218a7b65937e040f9149f006c4cca770ae9184d)
- Put back wp-cli as the main wp cron with a delay [c97e8d4](https://github.com/demyxsh/openlitespeed/commit/c97e8d474ff1865276f455f304a1710cb76cc660)
- Fix rewrite rule for specific strings [b05d197](https://github.com/demyxsh/openlitespeed/commit/b05d1979d2b11e50365c978f36a00a3831a37815)
- Use new function to include all demyx environment variables  for lsphp [842678d](https://github.com/demyxsh/openlitespeed/commit/842678dabcce6f74848fc0d2a9c16a5be5b06091)
- New function to auto calculate values for `LSAPI_EXTRA_CHILDREN` and `LSAPI_MAX_IDLE_CHILDREN` [ad96bad](https://github.com/demyxsh/openlitespeed/commit/ad96bada1859109f6d435a17c7316d3c648bf1b9)
- Update sed for WP_HOME [7e5c232](https://github.com/demyxsh/openlitespeed/commit/7e5c23290d837347f103ab39567299ef6c6326ea)

## 2023-11-14
- Disable installation of default themes/plugins when upgrading [f44ad25](https://github.com/demyxsh/openlitespeed/commit/f44ad25fc1cb81408142918f1cb8c30591eb10fb)

## 2023-09-20
- Prep for redis [576feff](https://github.com/demyxsh/openlitespeed/commit/576feff2fa0f74c0936d2edb0d79a0f01d0df85e)

## 2023-09-03
- New variable DEMYX_CRON_TYPE [f79a33e](https://github.com/demyxsh/openlitespeed/commit/f79a33e62d8f94cd325b879713ba7943888cba60)

## 2023-08-28
- Add lsphp 8.1 [4b366c4](https://github.com/demyxsh/openlitespeed/commit/4b366c4d59e2337df31ce6098c40d941f61755d8)
- Update logrotate conf [8f9e858](https://github.com/demyxsh/openlitespeed/commit/8f9e858cec052a37ac6671cdb78a0cd13945eba0)

## 2023-08-23
- Update test commands [54cbb3d](https://github.com/demyxsh/openlitespeed/commit/54cbb3dacfdb3d9d69ae8daca2d6f268ec7f0ff9)
- Update variable [65deb2b](https://github.com/demyxsh/openlitespeed/commit/65deb2b35f81b7d66a9a96b7fc30aa6d38bb7f12)
- Not sure why this was using echo but fixed [fa1b0df](https://github.com/demyxsh/openlitespeed/commit/fa1b0df019f23ec60f5430ce3684348f51a1b09c)
- Misc updates [50df8a8](https://github.com/demyxsh/openlitespeed/commit/50df8a800e441985ec085b729806fedd8af6fd49)
- Add --log flag for logrotate [968705b](https://github.com/demyxsh/openlitespeed/commit/968705be085238f87d28fe389fc253ef423bd007)
- Misc update [960a81d](https://github.com/demyxsh/openlitespeed/commit/960a81d9cd3f02ae394daa5cc447ce7cf9be8a66)
- Change value to 7 [08ed891](https://github.com/demyxsh/openlitespeed/commit/08ed891e3eb959c37c24d24bb1471181a87c6372)
- Misc updates [b5ab2f5](https://github.com/demyxsh/openlitespeed/commit/b5ab2f5c4b19399b1e994577822c28ffa49b00e7)
- Add new scripts [2404874](https://github.com/demyxsh/openlitespeed/commit/2404874fb7a16dc953905e3a201fda732b1e10b0)
- Add aaemnnosttv/wp-cli-login-command package [32cb3ec](https://github.com/demyxsh/openlitespeed/commit/32cb3ece06d3de41dca2263e4ae386b4c170d244)
- Add missing lsphp package [4d038d0](https://github.com/demyxsh/openlitespeed/commit/4d038d08745b5d42dba3b2ad187c222633e3e5bf)
- Set fallback for OLS version [0822539](https://github.com/demyxsh/openlitespeed/commit/0822539e61e5167332a262fee5d31be4738f7a37)
- Purge unused package [3dbc651](https://github.com/demyxsh/openlitespeed/commit/3dbc651da9f596ff8171034bd2d7649955c0bac4)
- Add new packages [63d6bf6](https://github.com/demyxsh/openlitespeed/commit/63d6bf66a2da962fbaab500d580ce181fcef5276)
- Add new variables [d8412dd](https://github.com/demyxsh/openlitespeed/commit/d8412ddabc4005cc5191688caed5a194b7f488b8)
- Switch to php's bullseye image [f100cb2](https://github.com/demyxsh/openlitespeed/commit/f100cb20caa4ba738da578993e3eea53ea0752a6)
- Use new formatting and misc updates [805401d](https://github.com/demyxsh/openlitespeed/commit/805401dc955612974c21de8c94c2a029e46b8f92)
- Install wp-cli-login-command package [20861df](https://github.com/demyxsh/openlitespeed/commit/20861df259feb741937fdd2e6b1dcf26c192863b)
- Add missing variable [2c2cb9b](https://github.com/demyxsh/openlitespeed/commit/2c2cb9b59268d54e7f348f3291d275ce642804dd)
- Add https labels [c25c676](https://github.com/demyxsh/openlitespeed/commit/c25c676dbbe7645b3fb22deee900e8aad829f75e)
- Merge branch 'master' of github.com:demyxsh/openlitespeed [5e0d281](https://github.com/demyxsh/openlitespeed/commit/5e0d2816aa6ec57c7c39d811a33db123e94a91ca)
- Add support for login package in wp-cli [a3412ab](https://github.com/demyxsh/openlitespeed/commit/a3412ab5267808a5742e1fd6f0c0e1688f6ab18d)
- Update YML [51d490e](https://github.com/demyxsh/openlitespeed/commit/51d490eae19e8f5d8a8f37c6327e5f7eedb59046)

## 2022-08-05
- Misc updates [fc6b804](https://github.com/demyxsh/openlitespeed/commit/fc6b804c1f4bb6808a8f2cfba9149a3d3150d6e7)
- Add fallback for lsphp versions [2f58a1f](https://github.com/demyxsh/openlitespeed/commit/2f58a1f7fbd8842ab7214d2e461348abd8853662)
- wp-cli is now included [e0ac6c3](https://github.com/demyxsh/openlitespeed/commit/e0ac6c381636f2a5dde7a0bbcd20b82d40bc767f)
- lsphp81 is now included in the image [2f08957](https://github.com/demyxsh/openlitespeed/commit/2f089575127158ceae76e5c37469ad0e5b5f00da)
- Add default-mysql-client as one of the core packages [229e8ac](https://github.com/demyxsh/openlitespeed/commit/229e8ac6dbc207f6606d077f7608c0f1d3faa0ca)
- Rename environment variable and set lsphp80 as the default version [308bf15](https://github.com/demyxsh/openlitespeed/commit/308bf15d68ae9d5eadc4d3668f8da21bdd1e2e59)
- Update to Debian Bullseye [652636c](https://github.com/demyxsh/openlitespeed/commit/652636c16e62539dcfd172478d538f49504d89f7)

## 2022-01-22
- Use curl to get tarball [fd8f890](https://github.com/demyxco/openlitespeed/commit/fd8f8902a821e18b866908ca92e163369d816f30)
- Remove default version [dbc4ecd](https://github.com/demyxco/openlitespeed/commit/dbc4ecd2092126ee12dcf0a00a2cd12a486f7554)

## 2021-07-14
- Update default versions [1df48e2](https://github.com/demyxco/openlitespeed/commit/1df48e214ac7f45b2e0215434b4baf8bbfc92607)

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
