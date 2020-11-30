#!/bin/bash
# Demyx
# https://demyx.sh

# Get versions
DEMYX_OPENLITESPEED_DEBIAN_VERSION="$(/usr/bin/docker exec -t demyx_wp /bin/cat /etc/debian_version | /bin/sed  's/\r//g')"
DEMYX_OPENLITESPEED_VERSION="$(/usr/bin/docker exec -t demyx_wp /bin/cat /usr/local/lsws/VERSION | /bin/sed  's/\r//g')"
DEMYX_OPENLITESPEED_LSPHP_VERSION="$(/usr/bin/docker exec -t demyx_wp /bin/sh -c '/usr/local/lsws/"$OPENLITESPEED_LSPHP_VERSION"/bin/lsphp -v' | /usr/bin/head -1 | /usr/bin/awk '{print $2}' | /bin/sed 's/\r//g')"

# Replace versions
/bin/sed -i "s|debian-.*.-informational|debian-${DEMYX_OPENLITESPEED_DEBIAN_VERSION}-informational|g" README.md
/bin/sed -i "s|${DEMYX_REPOSITORY}-.*.-informational|${DEMYX_REPOSITORY}-${DEMYX_OPENLITESPEED_VERSION}-informational|g" README.md
/bin/sed -i "s|lsphp-.*.-informational|lsphp-${DEMYX_OPENLITESPEED_LSPHP_VERSION//-/--}-informational|g" README.md

# Echo versions to file
/bin/echo "DEMYX_OPENLITESPEED_DEBIAN_VERSION=$DEMYX_OPENLITESPEED_DEBIAN_VERSION
DEMYX_OPENLITESPEED_VERSION=$DEMYX_OPENLITESPEED_VERSION
DEMYX_OPENLITESPEED_LSPHP_VERSION=$DEMYX_OPENLITESPEED_LSPHP_VERSION" > VERSION

# Push back to GitHub
/usr/bin/git config --global user.email "travis@travis-ci.com"
/usr/bin/git config --global user.name "Travis CI"
/usr/bin/git remote set-url origin https://"$DEMYX_GITHUB_TOKEN"@github.com/demyxco/"$DEMYX_REPOSITORY".git
# Commit VERSION first
/usr/bin/git add VERSION
/usr/bin/git commit -m "DEBIAN $DEMYX_OPENLITESPEED_DEBIAN_VERSION, OPENLITESPEED $DEMYX_OPENLITESPEED_VERSION, LSPHP $DEMYX_OPENLITESPEED_LSPHP_VERSION"
/usr/bin/git push origin HEAD:master
# Commit the rest
/usr/bin/git add .
/usr/bin/git commit -m "Travis Build $TRAVIS_BUILD_NUMBER"
/usr/bin/git push origin HEAD:master

# Send a PATCH request to update the description of the repository
/bin/echo "Sending PATCH request"
DEMYX_DOCKER_TOKEN="$(/usr/bin/curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'"$DEMYX_USERNAME"'", "password": "'"$DEMYX_PASSWORD"'"}' "https://hub.docker.com/v2/users/login/" | /usr/local/bin/jq -r .token)"
DEMYX_RESPONSE_CODE="$(/usr/bin/curl -s --write-out "%{response_code}" --output /dev/null -H "Authorization: JWT ${DEMYX_DOCKER_TOKEN}" -X PATCH --data-urlencode full_description@"README.md" "https://hub.docker.com/v2/repositories/${DEMYX_USERNAME}/${DEMYX_REPOSITORY}/")"
/bin/echo "Received response code: $DEMYX_RESPONSE_CODE"

# Return an exit 1 code if response isn't 200
[[ "$DEMYX_RESPONSE_CODE" != 200 ]] && exit 1
