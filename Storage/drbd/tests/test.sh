#!/bin/bash

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR=""

cleanup() {
    if [ -n "${WORKDIR}" ] && [ -d "${WORKDIR}" ]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

resolve_bin() {
    local tool="$1"
    local dir
    if command -v "${tool}" >/dev/null 2>&1; then
        command -v "${tool}"
        return 0
    fi
    for dir in /usr/sbin /sbin /usr/bin /bin /usr/local/sbin /usr/local/bin; do
        if [ -x "${dir}/${tool}" ]; then
            printf '%s\n' "${dir}/${tool}"
            return 0
        fi
    done
    return 1
}

test_version() {
    local binary out version_line reported
    if ! binary="$(resolve_bin drbdadm)"; then
        echo "FAIL: drbdadm binary not found in PATH or /usr/sbin"
        return 1
    fi

    out="$("${binary}" --version 2>&1 || true)"

    version_line="$(printf '%s\n' "${out}" | grep '^DRBDADM_VERSION=' | head -n 1)"
    if [ -z "${version_line}" ]; then
        echo "FAIL: cannot find DRBDADM_VERSION in drbdadm --version output: ${out}"
        return 1
    fi

    reported="${version_line#DRBDADM_VERSION=}"
    if [ "${reported}" != "${EXPECTED_VERSION}" ]; then
        echo "FAIL: version mismatch: expected=${EXPECTED_VERSION} actual=${reported}"
        return 1
    fi

    echo "PASS: drbdadm reports exact version ${reported}"
    return 0
}

test_tools_present() {
    local tool
    for tool in drbdadm drbdsetup drbdmeta; do
        if ! resolve_bin "${tool}" >/dev/null 2>&1; then
            echo "FAIL: required drbd-utils tool not found: ${tool}"
            return 1
        fi
    done
    echo "PASS: drbdadm, drbdsetup and drbdmeta tools are available"
    return 0
}

test_config_dump() {
    local binary conf out
    if ! binary="$(resolve_bin drbdadm)"; then
        echo "FAIL: drbdadm binary not found"
        return 1
    fi

    WORKDIR="$(mktemp -d)"
    if [ ! -d "${WORKDIR}" ]; then
        echo "FAIL: cannot create temporary working directory"
        return 1
    fi
    conf="${WORKDIR}/drbd.conf"

    cat > "${conf}" <<'EOF'
global { disable-ip-verification; }
resource r0 {
    net {
        cram-hmac-alg sha1;
        shared-secret "FooFunFactory";
    }
    volume 0 {
        device    /dev/drbd1;
        disk      /dev/loop0;
        meta-disk internal;
    }
    on node0 {
        node-id   0;
        address   10.1.1.31:7000;
    }
    on node1 {
        node-id   1;
        address   10.1.1.32:7000;
    }
    connection {
        host      node0  port 7000;
        host      node1  port 7000;
        net {
            protocol C;
        }
    }
}
EOF

    out="$("${binary}" -c "${conf}" dump 2>&1 || true)"

    case "${out}" in
        *"resource r0"*)
            echo "PASS: drbdadm dump parsed the resource config and reproduced resource r0"
            return 0
            ;;
    esac

    echo "FAIL: drbdadm dump did not reproduce the configured resource: ${out}"
    return 1
}

main() {
    local failures=0
    test_version      || failures=$((failures + 1))
    test_tools_present || failures=$((failures + 1))
    test_config_dump  || failures=$((failures + 1))

    if [ "${failures}" -eq 0 ]; then
        echo "ALL_TESTS_PASSED"
        return 0
    fi
    echo "TESTS_FAILED: ${failures} failure(s)"
    return 1
}

main "$@"