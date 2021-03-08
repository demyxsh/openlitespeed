#!/bin/bash
# Demyx
# https://demyx.sh

# Get versions
DEMYX_OPENLITESPEED_DEBIAN_VERSION="$(docker exec -t demyx_wp cat /etc/debian_version | sed  's/\r//g')"
DEMYX_OPENLITESPEED_VERSION="$(docker exec -t demyx_wp cat /usr/local/lsws/VERSION | sed  's/\r//g')"
DEMYX_OPENLITESPEED_LSPHP_VERSION="$(docker exec -t demyx_wp sh -c '/usr/local/lsws/"$DEMYX_LSPHP_VERSION"/bin/lsphp -v' | head -1 | awk '{print $2}' | sed 's/\r//g')"

# Replace versions
sed -i "s|debian-.*.-informational|debian-${DEMYX_OPENLITESPEED_DEBIAN_VERSION}-informational|g" README.md
sed -i "s|${DEMYX_REPOSITORY}-.*.-informational|${DEMYX_REPOSITORY}-${DEMYX_OPENLITESPEED_VERSION}-informational|g" README.md
sed -i "s|lsphp-.*.-informational|lsphp-${DEMYX_OPENLITESPEED_LSPHP_VERSION//-/--}-informational|g" README.md

# Echo versions to file
echo "DEMYX_OPENLITESPEED_DEBIAN_VERSION=$DEMYX_OPENLITESPEED_DEBIAN_VERSION
DEMYX_OPENLITESPEED_VERSION=$DEMYX_OPENLITESPEED_VERSION
DEMYX_OPENLITESPEED_LSPHP_VERSION=$DEMYX_OPENLITESPEED_LSPHP_VERSION" > VERSION

# Push back to GitHub
git config --global user.email "travis@travis-ci.com"
git config --global user.name "Travis CI"
git remote set-url origin https://"$DEMYX_GITHUB_TOKEN"@github.com/demyxco/"$DEMYX_REPOSITORY".git
# Commit VERSION first
git add VERSION
git commit -m "DEBIAN $DEMYX_OPENLITESPEED_DEBIAN_VERSION, OPENLITESPEED $DEMYX_OPENLITESPEED_VERSION, LSPHP $DEMYX_OPENLITESPEED_LSPHP_VERSION"
git push origin HEAD:master
# Commit the rest
git add .
git commit -m "Travis Build $TRAVIS_BUILD_NUMBER"
git push origin HEAD:master

# Send a PATCH request to update the description of the repository
echo "Sending PATCH request"
DEMYX_DOCKER_TOKEN="$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'"$DEMYX_USERNAME"'", "password": "'"$DEMYX_PASSWORD"'"}' "https://hub.docker.com/v2/users/login/" | jq -r .token)"
DEMYX_RESPONSE_CODE="$(curl -s --write-out "%{response_code}" --output /dev/null -H "Authorization: JWT ${DEMYX_DOCKER_TOKEN}" -X PATCH --data-urlencode full_description@"README.md" "https://hub.docker.com/v2/repositories/${DEMYX_USERNAME}/${DEMYX_REPOSITORY}/")"
echo "Received response code: $DEMYX_RESPONSE_CODE"

# Return an exit 1 code if response isn't 200
[[ "$DEMYX_RESPONSE_CODE" != 200 ]] && exit 1
