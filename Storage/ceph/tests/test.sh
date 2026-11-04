#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# The image installs the Ceph tree under /opt/ceph (the build directory keeps
# the daemon binaries used by entrypoint.sh) and also installs the binaries
# into the prefix (default /usr/local).
BUILD_BIN="/opt/ceph/build/bin"
WORKDIR=""
MON_PID=""

cleanup() {
    if [[ -n "${MON_PID}" ]] && kill -0 "${MON_PID}" 2>/dev/null; then
        kill "${MON_PID}" 2>/dev/null || true
        wait "${MON_PID}" 2>/dev/null || true
    fi
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

resolve_bin() {
    local tool="$1"
    if [[ -x "${BUILD_BIN}/${tool}" ]]; then
        printf '%s' "${BUILD_BIN}/${tool}"
        return 0
    fi
    if command -v "${tool}" >/dev/null 2>&1; then
        command -v "${tool}"
        return 0
    fi
    return 1
}

test_binary_and_version() {
    local binary output rc reported

    if ! binary="$(resolve_bin ceph)"; then
        printf 'FAIL: ceph binary not found in %s or PATH\n' "${BUILD_BIN}" >&2
        return 1
    fi

    if output="$("${binary}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: "%s --version" exited %s: %s\n' \
            "${binary}" "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" =~ ceph\ version\ ([0-9]+\.[0-9]+\.[0-9]+) ]]; then
        reported="${BASH_REMATCH[1]}"
    else
        printf 'FAIL: cannot parse version from ceph --version output: <%s>\n' \
            "${output}" >&2
        return 1
    fi

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    printf 'PASS: exact version: %s\n' "${reported}"
}

test_tools_present() {
    local tool

    for tool in ceph ceph-mon ceph-authtool monmaptool rados; do
        if ! resolve_bin "${tool}" >/dev/null; then
            printf 'FAIL: required ceph tool not found: %s\n' "${tool}" >&2
            return 1
        fi
    done

    printf 'PASS: ceph CLI, monitor, keyring and rados tools are available\n'
}

test_single_node_cluster() {
    local ceph_bin mon_bin authtool_bin monmap_bin
    local etc lib run log conf monmap keyring admin_keyring
    local fsid output rc i ready=0

    if ! ceph_bin="$(resolve_bin ceph)" ||
       ! mon_bin="$(resolve_bin ceph-mon)" ||
       ! authtool_bin="$(resolve_bin ceph-authtool)" ||
       ! monmap_bin="$(resolve_bin monmaptool)"; then
        printf 'FAIL: missing ceph binaries required to bootstrap a monitor\n' >&2
        return 1
    fi

    etc="${WORKDIR}/etc"
    lib="${WORKDIR}/lib"
    run="${WORKDIR}/run"
    log="${WORKDIR}/log"
    mkdir -p "${etc}" "${lib}/mon/mon1" "${run}" "${log}"

    fsid="$(cat /proc/sys/kernel/random/uuid)"
    conf="${etc}/ceph.conf"
    monmap="${etc}/monmap"
    keyring="${etc}/ceph.mon.keyring"
    admin_keyring="${etc}/ceph.client.admin.keyring"

    # Same bootstrap sequence as the image entrypoint, but rooted in a
    # throw-away directory so the test leaves no state behind.
    cat > "${conf}" <<EOF
[global]
fsid = ${fsid}
mon_initial_members = mon1
mon_host = 127.0.0.1
auth_cluster_required = cephx
auth_service_required = cephx
auth_client_required = cephx
log_to_file = true
log_file = ${log}/ceph.log
log_to_stderr = false
run_dir = ${run}
mon_data = ${lib}/mon/\$id
keyring = ${admin_keyring}
mon_keyring = ${keyring}
EOF

    "${authtool_bin}" --create-keyring "${keyring}" --gen-key -n mon. \
        --cap mon 'allow *' >/dev/null
    "${authtool_bin}" --create-keyring "${admin_keyring}" --gen-key \
        -n client.admin --cap mon 'allow *' --cap osd 'allow *' \
        --cap mgr 'allow *' >/dev/null
    "${authtool_bin}" "${keyring}" --import-keyring "${admin_keyring}" >/dev/null

    "${monmap_bin}" --clobber --create --add mon1 127.0.0.1 \
        --fsid "${fsid}" "${monmap}" >/dev/null

    if ! output="$("${mon_bin}" --mkfs -i mon1 --monmap "${monmap}" \
            --keyring "${keyring}" --conf "${conf}" 2>&1)"; then
        rc=$?
        printf 'FAIL: ceph-mon --mkfs exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    "${mon_bin}" -i mon1 --conf "${conf}" --keyring "${keyring}" \
        >"${log}/mon.out" 2>&1 &
    MON_PID=$!

    for ((i = 1; i <= 60; i++)); do
        if output="$("${ceph_bin}" -s --conf "${conf}" \
                --keyring "${admin_keyring}" 2>&1)" &&
           [[ "${output}" == *"quorum mon1"* ]]; then
            ready=1
            break
        fi
        if ! kill -0 "${MON_PID}" 2>/dev/null; then
            printf 'FAIL: ceph-mon exited during startup:\n%s\n' \
                "$(cat "${log}/mon.out" 2>/dev/null || true)" >&2
            return 1
        fi
        sleep 1
    done

    if (( ready == 0 )); then
        printf 'FAIL: monitor did not reach quorum within 60s:\n%s\n' \
            "$(cat "${log}/ceph.log" 2>/dev/null || true)" >&2
        return 1
    fi

    if ! output="$("${ceph_bin}" osd pool create oe-test-pool 8 8 \
            --conf "${conf}" --keyring "${admin_keyring}" 2>&1)"; then
        rc=$?
        printf 'FAIL: osd pool create exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if ! output="$("${ceph_bin}" osd pool ls --conf "${conf}" \
            --keyring "${admin_keyring}" 2>&1)"; then
        rc=$?
        printf 'FAIL: osd pool ls exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != *"oe-test-pool"* ]]; then
        printf 'FAIL: the created pool is not listed by the cluster:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    printf 'PASS: single-node monitor reached quorum and persisted a pool\n'
}

main() {
    local failures=0

    WORKDIR="$(mktemp -d)"
    if [[ ! -d "${WORKDIR}" ]]; then
        printf 'FAIL: cannot create temporary working directory\n' >&2
        return 1
    fi

    if ! test_binary_and_version; then
        failures=$((failures + 1))
    fi
    if ! test_tools_present; then
        failures=$((failures + 1))
    fi
    if ! test_single_node_cluster; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
