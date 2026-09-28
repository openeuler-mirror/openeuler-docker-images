#!/bin/bash
set -euo pipefail

# Functional tests for the openeuler/harbor image (Harbor core 2.15.2).
#
# Harbor core is a single component of a multi-container Harbor deployment.
# Besides this container a working Harbor installation also needs PostgreSQL,
# Redis, the registry, the jobservice and the portal (upstream Harbor install
# guide).  The image ships one Go binary, /harbor/harbor_core, plus the
# entrypoint/certificate bootstrap scripts and the runtime assets.
#
# src/core/main.go parses flags first, then initializes the cache and only
# afterwards reads the database configuration and migrates the schema before
# starting the HTTP server.  With no _REDIS_URL_* configured the real startup
# path deterministically aborts during cache initialization with
# "failed to initialize cache", long before it could listen on :8080.  These
# tests verify the shipped component's real, runnable contract: the exact
# embedded release version, the documented run-mode CLI interface, a bounded
# execution of the real startup path, the shipped entrypoint/certificate
# bootstrap scripts, the runtime assets and the non-root harbor identity.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

BIN_DIR="/harbor"
BINARY="${BIN_DIR}/harbor_core"
ENTRYPOINT="${BIN_DIR}/entrypoint.sh"
INSTALL_CERT="${BIN_DIR}/install_cert.sh"

# Upper bound for the bounded startup execution.  harbor_core must terminate
# on its own well within this window.
STARTUP_TIMEOUT_SECONDS=30

test_runtime_identity() {
    local passwd_entry harbor_uid

    # Dockerfile: useradd -r -g harbor -m harbor
    if ! passwd_entry="$(grep -E '^harbor:[^:]*:[1-9][0-9]*:' /etc/passwd)"; then
        printf 'FAIL: non-root runtime user "harbor" not present in /etc/passwd\n' >&2
        return 1
    fi

    # Extract the UID from the passwd entry with bash only; the runtime image
    # does not ship findutils, so ownership must not be probed with find(1).
    IFS=: read -r _ _ harbor_uid _ <<< "${passwd_entry}"

    # Dockerfile: USER harbor, so the test process must be the harbor account
    # and the binary must be owned by that same effective user (chown -R
    # harbor:harbor /harbor).  Bash's -O test needs no external tool.
    if [[ "${EUID}" -ne "${harbor_uid}" ]]; then
        printf 'FAIL: runtime user is not harbor (euid=%s, harbor uid=%s)\n' \
            "${EUID}" "${harbor_uid}" >&2
        return 1
    fi
    if [[ ! -O "${BINARY}" ]]; then
        printf 'FAIL: %s is not owned by the harbor user\n' "${BINARY}" >&2
        return 1
    fi

    printf 'PASS: non-root runtime user harbor (uid=%s) owns %s\n' \
        "${harbor_uid}" "${BINARY}"
}

test_binary_and_assets() {
    local magic="" asset

    if [[ ! -f "${BINARY}" ]]; then
        printf 'FAIL: harbor core binary missing: %s\n' "${BINARY}" >&2
        return 1
    fi
    if [[ ! -x "${BINARY}" ]]; then
        printf 'FAIL: harbor core binary not executable: %s\n' "${BINARY}" >&2
        return 1
    fi

    # Read the 4-byte ELF magic with the bash builtin so no extra host tool is
    # assumed.  A real compiled harbor_core starts with 0x7f 'E' 'L' 'F'.
    if ! exec 3< "${BINARY}"; then
        printf 'FAIL: cannot open %s for reading\n' "${BINARY}" >&2
        return 1
    fi
    if ! IFS= read -r -N 4 -u 3 magic; then
        exec 3<&-
        printf 'FAIL: cannot read ELF header from %s\n' "${BINARY}" >&2
        return 1
    fi
    exec 3<&-
    if [[ "${magic}" != $'\x7fELF' ]]; then
        printf 'FAIL: %s is not an ELF executable\n' "${BINARY}" >&2
        return 1
    fi

    if [[ ! -f "${ENTRYPOINT}" || ! -x "${ENTRYPOINT}" ]]; then
        printf 'FAIL: entrypoint absent or not executable: %s\n' "${ENTRYPOINT}" >&2
        return 1
    fi
    if ! grep -q '/harbor/harbor_core' "${ENTRYPOINT}"; then
        printf 'FAIL: entrypoint does not exec %s\n' "${BINARY}" >&2
        return 1
    fi

    if [[ ! -f "${INSTALL_CERT}" || ! -x "${INSTALL_CERT}" ]]; then
        printf 'FAIL: install_cert.sh absent or not executable: %s\n' "${INSTALL_CERT}" >&2
        return 1
    fi

    for asset in views migrations icons; do
        if [[ ! -d "${BIN_DIR}/${asset}" ]]; then
            printf 'FAIL: runtime asset directory missing: %s\n' "${BIN_DIR}/${asset}" >&2
            return 1
        fi
    done

    printf 'PASS: ELF harbor_core, entrypoint/install_cert scripts and runtime assets present\n'
}

test_version() {
    local ver escaped pattern

    if [[ ! -r "${BINARY}" ]]; then
        printf 'FAIL: binary not readable for version inspection: %s\n' "${BINARY}" >&2
        return 1
    fi

    # The Dockerfile builds with
    #   -X github.com/goharbor/harbor/src/pkg/version.ReleaseVersion=v2.15.2
    # so the exact release string is embedded verbatim in the binary.  The
    # boundary groups reject a longer version such as v2.15.20, keeping the
    # comparison an exact match rather than a fuzzy substring.
    ver="${EXPECTED_VERSION#v}"
    escaped="${ver//./\\.}"
    pattern="(^|[^0-9.])v${escaped}([^0-9.]|$)"

    if ! grep -a -q -E "${pattern}" "${BINARY}"; then
        printf 'FAIL: exact release version v%s is not embedded in %s\n' \
            "${ver}" "${BINARY}" >&2
        return 1
    fi

    printf 'PASS: exact embedded release version: v%s\n' "${ver}"
}

test_cli_run_mode() {
    local output rc

    # -h is handled by flag.Parse() in src/core/main.go before cache/database
    # initialization, so this exercises the real binary without a database.
    if output="$("${BINARY}" -h 2>&1)"; then
        rc=0
    else
        rc=$?
    fi

    if [[ -z "${output}" ]]; then
        printf 'FAIL: "%s -h" produced no output (rc=%s)\n' "${BINARY}" "${rc}" >&2
        return 1
    fi

    if [[ "${output}" != *"-mode"* ]]; then
        printf 'FAIL: harbor_core usage does not advertise the -mode flag:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    # Assert the full 2.15.2 flag description from src/core/main.go, not just
    # the flag name, so a placeholder usage string cannot satisfy this check.
    if [[ "${output}" != *"it could be normal, migrate or skip-migrate, default is normal"* ]]; then
        printf 'FAIL: harbor_core usage does not document the 2.15.2 run modes:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    printf 'PASS: harbor_core exposes the documented -mode run-mode flag (rc=%s)\n' \
        "${rc}"
}

test_startup_path() {
    local outfile output rc pid watchdog

    # Exercise the real startup path of main(): with the cache URLs cleared,
    # main() reaches cache.Initialize("", "") which fails because no cache
    # factory is registered for the empty type, and it logs the fatal
    # "failed to initialize cache" before any database work.  This proves the
    # shipped binary actually runs its startup logic rather than only flag
    # parsing.  Bounded so that a hang is detected instead of stalling.
    outfile="/tmp/harbor-core-startup-$$.log"
    _REDIS_URL_CORE= _REDIS_URL_HARBOR= "${BINARY}" >"${outfile}" 2>&1 &
    pid=$!
    ( sleep "${STARTUP_TIMEOUT_SECONDS}"; kill -KILL "${pid}" 2>/dev/null ) &
    watchdog=$!
    if wait "${pid}"; then
        rc=0
    else
        rc=$?
    fi
    kill "${watchdog}" 2>/dev/null || true
    wait "${watchdog}" 2>/dev/null || true
    output="$(< "${outfile}")"
    rm -f "${outfile}"

    if [[ "${rc}" -eq 137 || "${rc}" -eq 143 ]]; then
        printf 'FAIL: harbor_core startup did not terminate within %s s (rc=%s):\n%s\n' \
            "${STARTUP_TIMEOUT_SECONDS}" "${rc}" "${output}" >&2
        return 1
    fi
    if [[ "${rc}" -eq 0 ]]; then
        printf 'FAIL: harbor_core startup unexpectedly exited 0 without cache/database:\n%s\n' \
            "${output}" >&2
        return 1
    fi
    if [[ "${output}" != *"failed to initialize cache"* ]]; then
        printf 'FAIL: harbor_core startup did not report the expected cache failure (rc=%s):\n%s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    printf 'PASS: harbor_core runs its real startup path and fails fast on missing cache (rc=%s)\n' \
        "${rc}"
}

test_install_cert_script() {
    local output rc

    if output="$("${INSTALL_CERT}" 2>&1)"; then
        rc=0
    else
        rc=$?
    fi

    if [[ "${rc}" -ne 0 ]]; then
        printf 'FAIL: install_cert.sh exited %s: %s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != *"skip appending ca bundle"* ]]; then
        printf 'FAIL: install_cert.sh did not take the non-Photon no-op path:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    printf 'PASS: install_cert.sh certificate bootstrap no-op path on openEuler\n'
}

main() {
    local failures=0

    if ! test_runtime_identity; then
        failures=$((failures + 1))
    fi
    if ! test_binary_and_assets; then
        failures=$((failures + 1))
    fi
    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_cli_run_mode; then
        failures=$((failures + 1))
    fi
    if ! test_startup_path; then
        failures=$((failures + 1))
    fi
    if ! test_install_cert_script; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
