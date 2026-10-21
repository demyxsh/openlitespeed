#!/usr/bin/env bash
set -euo pipefail

root_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT
fixture_root="$tmp_dir/fixture"
helper="$tmp_dir/demyx-php-security"
sed "s|/usr/local|$fixture_root/usr/local|g" "$root_dir/tag-latest/bin/demyx-php-security" > "$helper"
chmod +x "$helper"

required_specs=(
    '/usr/local/bin/php|4|cli|8.4.27|8.4.26|8.4.28'
    '/usr/local/lsws/lsphp83/bin/php|3|cli|8.3.36|8.3.35|8.3.37'
    '/usr/local/lsws/lsphp83/bin/lsphp|3|litespeed|8.3.36|8.3.35|8.3.37'
    '/usr/local/lsws/lsphp84/bin/php|4|cli|8.4.27|8.4.26|8.4.28'
    '/usr/local/lsws/lsphp84/bin/lsphp|4|litespeed|8.4.27|8.4.26|8.4.28'
    '/usr/local/lsws/admin/fcgi-bin/admin_php|4|litespeed|8.4.27|8.4.26|8.4.28'
    '/usr/local/lsws/fcgi-bin/lsphp|4|litespeed|8.4.27|8.4.26|8.4.28'
    '/usr/local/lsws/fcgi-bin/lsphp5|4|litespeed|8.4.27|8.4.26|8.4.28'
)
optional_specs=(
    '/usr/local/lsws/fcgi-bin/lsphp7|8.4.27|8.4.26|8.4.28'
    '/usr/local/lsws/admin/fcgi-bin/admin_php5|8.4.27|8.4.26|8.4.28'
    '/usr/local/lsws/admin/fcgi-bin/admin_php.bak|8.4.27|8.4.26|8.4.28'
)

write_fixture() {
    local path="$1"
    local version="$2"
    local sapi="$3"
    local binary="$fixture_root$path"

    mkdir -p "$(dirname "$binary")"
    cat > "$binary" <<EOF
#!/usr/bin/env bash
printf '%s\\n' 'PHP $version ($sapi)'
EOF
    chmod +x "$binary"
}

write_standard_fixtures() {
    local spec path minor sapi minimum below newer
    for spec in "${required_specs[@]}"; do
        IFS='|' read -r path minor sapi minimum below newer <<< "$spec"
        write_fixture "$path" "$minimum" "$sapi"
    done
    for spec in "${optional_specs[@]}"; do
        IFS='|' read -r path minimum below newer <<< "$spec"
        write_fixture "$path" "$minimum" litespeed
    done
}

expect_success() {
    local label="$1"
    local output
    if output=$("$helper" 2>&1); then
        printf 'PASS %s\n' "$label"
    else
        printf 'FAIL %s: %s\n' "$label" "$output" >&2
        exit 1
    fi
}

expect_failure() {
    local label="$1"
    local expected="$2"
    local output
    if output=$("$helper" 2>&1); then
        printf 'FAIL %s: helper unexpectedly passed\n' "$label" >&2
        exit 1
    fi
    if [[ "$output" != *"$expected"* ]]; then
        printf 'FAIL %s: expected %s, got %s\n' "$label" "$expected" "$output" >&2
        exit 1
    fi
    printf 'PASS %s\n' "$label"
}

write_standard_fixtures
expect_success 'fixed minimum versions'

for spec in "${required_specs[@]}"; do
    IFS='|' read -r path minor sapi minimum below newer <<< "$spec"
    write_fixture "$path" "$newer" "$sapi"
done
for spec in "${optional_specs[@]}"; do
    IFS='|' read -r path minimum below newer <<< "$spec"
    write_fixture "$path" "$newer" litespeed
done
expect_success 'newer fixed branches'

write_standard_fixtures
for spec in "${required_specs[@]}"; do
    IFS='|' read -r path minor sapi minimum below newer <<< "$spec"
    write_fixture "$path" "$below" "$sapi"
    expect_failure "$path below minimum" "$path"
    write_fixture "$path" "$minimum" "$sapi"
done
for spec in "${optional_specs[@]}"; do
    IFS='|' read -r path minimum below newer <<< "$spec"
    write_fixture "$path" "$below" litespeed
    expect_failure "$path below minimum" "$path"
    write_fixture "$path" "$minimum" litespeed
done

for spec in "${required_specs[@]}"; do
    IFS='|' read -r path minor sapi minimum below newer <<< "$spec"
    binary="$fixture_root$path"
    mv "$binary" "$binary.missing"
    expect_failure "$path missing" "$binary"
    mv "$binary.missing" "$binary"
done

for spec in "${required_specs[@]}"; do
    IFS='|' read -r path minor sapi minimum below newer <<< "$spec"
    if [ "$minor" = 4 ]; then
        wrong_branch=8.3.99
    else
        wrong_branch=8.4.99
    fi
    write_fixture "$path" "$wrong_branch" "$sapi"
    expect_failure "$path wrong branch" 'Wrong PHP branch'
    write_fixture "$path" "$minimum" "$sapi"

    if [ "$sapi" = litespeed ]; then
        wrong_sapi=cli
    else
        wrong_sapi=litespeed
    fi
    write_fixture "$path" "$minimum" "$wrong_sapi"
    expect_failure "$path wrong SAPI" 'Wrong PHP SAPI'
    write_fixture "$path" "$minimum" "$sapi"
done

write_fixture /usr/local/bin/php 8.4.27RC1 cli
expect_failure 'prerelease version' 'Malformed or unsupported PHP version'
write_fixture /usr/local/bin/php 8.4.27 cli
printf '#!/usr/bin/env bash\nprintf "not a PHP version\\\\n"\n' > "$fixture_root/usr/local/bin/php"
chmod +x "$fixture_root/usr/local/bin/php"
expect_failure 'malformed version output' 'Malformed or unsupported PHP version'
printf '#!/usr/bin/env bash\nexit 23\n' > "$fixture_root/usr/local/bin/php"
chmod +x "$fixture_root/usr/local/bin/php"
expect_failure 'version command failure' 'Failed to run PHP version check'

printf 'PHP security helper unit checks passed\n'
