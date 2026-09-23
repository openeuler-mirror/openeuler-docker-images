#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BINARY="php"
BINARY_PATH="/usr/local/bin/php"
WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

test_binary_and_version() {
    local resolved output rc

    if ! command -v "${BINARY}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${BINARY}" >&2
        return 1
    fi

    resolved="$(command -v "${BINARY}")"
    if [[ "${resolved}" != "${BINARY_PATH}" ]]; then
        printf 'FAIL: %s resolved to unexpected path: expected=<%s> actual=<%s>\n' \
            "${BINARY}" "${BINARY_PATH}" "${resolved}" >&2
        return 1
    fi

    if output="$("${BINARY}" -r 'echo phpversion();' 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: php -r "echo phpversion();" exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact php version: %s\n' "${output}"
}

test_core_script_execution() {
    local script="${WORKDIR}/core.php"
    local outfile="${WORKDIR}/squares.txt"
    local output rc
    local expected='sum=5050 count=100 first=1 last=10000'

    cat > "${script}" <<'PHP'
<?php
$outfile = $argv[1];
$data = range(1, 100);
$sum = array_sum($data);
$squares = array_map(static fn (int $n): int => $n * $n, $data);
file_put_contents($outfile, implode(',', $squares));
$read = array_map('intval', explode(',', (string) file_get_contents($outfile)));
if ($read !== $squares) {
    fwrite(STDERR, "roundtrip mismatch\n");
    exit(1);
}
printf("sum=%d count=%d first=%d last=%d\n", $sum, count($squares), $squares[0], $squares[99]);
PHP

    if output="$("${BINARY}" "${script}" "${outfile}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: core script exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: core script result mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    if [[ ! -s "${outfile}" ]]; then
        printf 'FAIL: core script output file missing or empty: %s\n' "${outfile}" >&2
        return 1
    fi

    printf 'PASS: script execution with argv and file read/write roundtrip: %s\n' "${output}"
}

test_sqlite_persistence() {
    local writer="${WORKDIR}/sqlite_write.php"
    local reader="${WORKDIR}/sqlite_read.php"
    local dbfile="${WORKDIR}/items.sqlite"
    local output rc
    local expected='sqlite_ok rows=3 names=alpha,beta,gamma'

    cat > "${writer}" <<'PHP'
<?php
$db = new SQLite3($argv[1]);
$db->exec('CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT NOT NULL)');
$stmt = $db->prepare('INSERT INTO items(id, name) VALUES (:id, :name)');
foreach ([[1, 'alpha'], [2, 'beta'], [3, 'gamma']] as $row) {
    $stmt->bindValue(':id', $row[0], SQLITE3_INTEGER);
    $stmt->bindValue(':name', $row[1], SQLITE3_TEXT);
    $stmt->execute();
    $stmt->reset();
}
$stmt->close();
$db->close();
echo "written\n";
PHP

    cat > "${reader}" <<'PHP'
<?php
$db = new SQLite3($argv[1]);
$result = $db->query('SELECT id, name FROM items ORDER BY id');
$rows = [];
while ($row = $result->fetchArray(SQLITE3_NUM)) {
    $rows[] = $row[0] . ':' . $row[1];
}
$result->finalize();
$db->close();
$expected = ['1:alpha', '2:beta', '3:gamma'];
if ($rows !== $expected) {
    fwrite(STDERR, 'sqlite mismatch: ' . implode(',', $rows) . "\n");
    exit(1);
}
$names = array_map(static fn (string $r): string => explode(':', $r)[1], $rows);
echo 'sqlite_ok rows=' . count($rows) . ' names=' . implode(',', $names) . "\n";
PHP

    if output="$("${BINARY}" "${writer}" "${dbfile}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: sqlite writer exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi
    if [[ "${output}" != 'written' ]]; then
        printf 'FAIL: sqlite writer unexpected output: <%s>\n' "${output}" >&2
        return 1
    fi

    if [[ ! -s "${dbfile}" ]]; then
        printf 'FAIL: sqlite database file missing or empty: %s\n' "${dbfile}" >&2
        return 1
    fi

    if output="$("${BINARY}" "${reader}" "${dbfile}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: sqlite reader exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi
    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: sqlite read-back mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: sqlite write-then-read persistence across php processes: %s\n' "${output}"
}

test_sodium_roundtrip() {
    local script="${WORKDIR}/sodium.php"
    local output rc
    local expected='sodium_ok len=30'

    cat > "${script}" <<'PHP'
<?php
$key = sodium_crypto_secretbox_keygen();
$nonce = random_bytes(SODIUM_CRYPTO_SECRETBOX_NONCEBYTES);
$message = 'openeuler-php-sodium-roundtrip';
$cipher = sodium_crypto_secretbox($message, $nonce, $key);
$plain = sodium_crypto_secretbox_open($cipher, $nonce, $key);
if ($plain !== $message) {
    fwrite(STDERR, "sodium roundtrip mismatch\n");
    exit(1);
}
$tampered = $cipher;
$tampered[0] = $tampered[0] ^ "\x01";
if (sodium_crypto_secretbox_open($tampered, $nonce, $key) !== false) {
    fwrite(STDERR, "sodium authentication check failed\n");
    exit(1);
}
echo 'sodium_ok len=' . strlen($plain) . "\n";
PHP

    if output="$("${BINARY}" "${script}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: sodium script exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: sodium roundtrip mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: libsodium authenticated encryption roundtrip: %s\n' "${output}"
}

test_argon2_password_hashing() {
    local script="${WORKDIR}/argon2.php"
    local output rc
    local expected='argon2_ok prefix=$argon2id$ verified=1 rejected=1'

    cat > "${script}" <<'PHP'
<?php
if (!defined('PASSWORD_ARGON2ID')) {
    fwrite(STDERR, "PASSWORD_ARGON2ID is not available\n");
    exit(1);
}
$password = 'correct horse battery staple';
$hash = password_hash($password, PASSWORD_ARGON2ID);
if (!is_string($hash) || !str_starts_with($hash, '$argon2id$')) {
    fwrite(STDERR, 'unexpected argon2id hash: ' . var_export($hash, true) . "\n");
    exit(1);
}
$verified = password_verify($password, $hash) === true;
$rejected = password_verify('wrong password', $hash) === false;
if (!$verified || !$rejected) {
    fwrite(STDERR, "argon2id verification failed\n");
    exit(1);
}
echo 'argon2_ok prefix=$argon2id$ verified=' . (int) $verified . ' rejected=' . (int) $rejected . "\n";
PHP

    if output="$("${BINARY}" "${script}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: argon2 script exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: argon2id result mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: libargon2 password hashing and verification: %s\n' "${output}"
}

test_zlib_roundtrip() {
    local script="${WORKDIR}/zlib.php"
    local output rc
    local expected='zlib_ok raw=900 back=900'

    cat > "${script}" <<'PHP'
<?php
$payload = str_repeat('php-zlib-', 100);
$compressed = gzcompress($payload, 6);
$inflated = gzuncompress($compressed);
if ($inflated !== $payload) {
    fwrite(STDERR, "zlib roundtrip mismatch\n");
    exit(1);
}
if (strlen($compressed) >= strlen($payload)) {
    fwrite(STDERR, "zlib did not reduce size\n");
    exit(1);
}
echo 'zlib_ok raw=' . strlen($payload) . ' back=' . strlen($inflated) . "\n";
PHP

    if output="$("${BINARY}" "${script}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: zlib script exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: zlib roundtrip mismatch: expected=<%s> actual=<%s>\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: zlib compress/decompress roundtrip: %s\n' "${output}"
}

main() {
    local failures=0

    if ! WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/php-test.XXXXXX")"; then
        printf 'FAIL: cannot create temporary working directory\n' >&2
        return 1
    fi

    if ! test_binary_and_version; then
        failures=$((failures + 1))
    fi
    if ! test_core_script_execution; then
        failures=$((failures + 1))
    fi
    if ! test_sqlite_persistence; then
        failures=$((failures + 1))
    fi
    if ! test_sodium_roundtrip; then
        failures=$((failures + 1))
    fi
    if ! test_argon2_password_hashing; then
        failures=$((failures + 1))
    fi
    if ! test_zlib_roundtrip; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
