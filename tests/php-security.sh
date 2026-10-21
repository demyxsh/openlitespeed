#!/usr/bin/env bash
set -euo pipefail

if (($# == 0)); then
    printf 'Usage: %s IMAGE [IMAGE ...]\n' "${0##*/}" >&2
    exit 2
fi

container_test=$(cat <<'EOF'
assert_extensions() {
    binary="$1"
    required="$2"
    if ! missing=$(PHP_TEST_REQUIRED_EXTENSIONS="$required" "$binary" -r '
$required = explode(",", getenv("PHP_TEST_REQUIRED_EXTENSIONS"));
$missing = array_filter($required, static fn($extension) => !extension_loaded($extension));
echo implode(",", $missing);
'); then
        printf "Failed to inspect extensions with %s\n" "$binary" >&2
        exit 1
    fi
    if [ -n "$missing" ]; then
        printf "Missing extensions in %s: %s\n" "$binary" "$missing" >&2
        exit 1
    fi
    printf "Extensions present in %s: %s\n" "$binary" "$required"
}

if [ "$(id -u)" -ne 1000 ]; then
    printf "Expected UID 1000, got %s\n" "$(id -u)" >&2
    exit 1
fi

assert_extensions /usr/local/bin/php mysqli,pdo_mysql,zip
assert_extensions /usr/local/lsws/lsphp83/bin/php curl,imagick,intl,mysqli,redis
assert_extensions /usr/local/lsws/lsphp84/bin/php curl,imagick,intl,mysqli,redis
EOF
)

for image in "$@"; do
    printf 'Checking PHP security in %s\n' "$image"
    docker run --rm --network none --read-only --entrypoint /usr/local/bin/demyx-php-security "$image"
    docker run --rm --network none --read-only --entrypoint /bin/sh "$image" -ec "$container_test"
done
