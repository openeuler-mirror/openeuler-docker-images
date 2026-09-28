#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

ANSIBLE_BIN="ansible"
PLAYBOOK_BIN="ansible-playbook"
PROBE_FILE="/tmp/ansible-core-probe-output.txt"

WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/ansible-test.XXXXXX")"
trap 'rm -rf "${WORKDIR}"' EXIT

test_version() {
    local output first_line reported="" rc

    if ! command -v "${ANSIBLE_BIN}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${ANSIBLE_BIN}" >&2
        return 1
    fi

    if output="$("${ANSIBLE_BIN}" --version 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: "%s --version" exited %s: %s\n' \
            "${ANSIBLE_BIN}" "${rc}" "${output}" >&2
        return 1
    fi

    first_line="${output%%$'\n'*}"
    if [[ "${first_line}" =~ ^ansible\ \[core\ ([0-9]+\.[0-9]+\.[0-9]+)\] ]]; then
        reported="${BASH_REMATCH[1]}"
    fi

    if [[ -z "${reported}" ]]; then
        printf 'FAIL: no ansible-core version in first line: <%s>\n' \
            "${first_line}" >&2
        return 1
    fi

    if [[ "${reported}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${reported}" >&2
        return 1
    fi

    if [[ "${output}" != *"ansible python module location"* ]]; then
        printf 'FAIL: unexpected "ansible --version" output:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    printf 'PASS: exact ansible-core version: %s\n' "${reported}"
}

test_core_function() {
    local playbook="${WORKDIR}/probe.yml"
    local output rc content

    if ! command -v "${PLAYBOOK_BIN}" >/dev/null 2>&1; then
        printf 'FAIL: binary not found in PATH: %s\n' "${PLAYBOOK_BIN}" >&2
        return 1
    fi

    rm -f "${PROBE_FILE}"

    cat > "${playbook}" <<'YAML'
- name: ansible-core functional probe
  hosts: localhost
  gather_facts: false
  connection: local
  vars:
    probe_file: /tmp/ansible-core-probe-output.txt
  tasks:
    - name: Write known content to the target filesystem
      ansible.builtin.copy:
        content: "ansible-core-probe-ok\n"
        dest: "{{ probe_file }}"
        mode: "0644"
    - name: Read the content back
      ansible.builtin.command:
        argv:
          - cat
          - "{{ probe_file }}"
      register: probe_read
      changed_when: false
    - name: Verify the round-trip content
      ansible.builtin.assert:
        that:
          - probe_read.stdout == "ansible-core-probe-ok"
        success_msg: "ANSIBLE_CORE_PROBE_OK"
        fail_msg: "unexpected content: <{{ probe_read.stdout }}>"
YAML

    if output="$(ANSIBLE_NOCOLOR=1 "${PLAYBOOK_BIN}" \
            -i localhost, \
            -c local \
            "${playbook}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: playbook exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != *"ANSIBLE_CORE_PROBE_OK"* ]]; then
        printf 'FAIL: functional marker missing from playbook output:\n%s\n' \
            "${output}" >&2
        return 1
    fi

    if [[ "${output}" != *"failed=0"* ]]; then
        printf 'FAIL: playbook recap reports failures:\n%s\n' "${output}" >&2
        return 1
    fi

    if [[ ! -f "${PROBE_FILE}" ]]; then
        printf 'FAIL: probe output file was not created: %s\n' \
            "${PROBE_FILE}" >&2
        return 1
    fi

    content="$(cat "${PROBE_FILE}")"
    if [[ "${content}" != "ansible-core-probe-ok" ]]; then
        printf 'FAIL: probe file content mismatch: expected=<ansible-core-probe-ok> actual=<%s>\n' \
            "${content}" >&2
        return 1
    fi

    printf 'PASS: playbook write/read data path: %s\n' "${content}"
}

main() {
    local failures=0

    if ! test_version; then
        failures=$((failures + 1))
    fi
    if ! test_core_function; then
        failures=$((failures + 1))
    fi

    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    printf 'ALL_TESTS_PASSED\n'
}

main "$@"
