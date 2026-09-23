#!/bin/bash
set -euo pipefail

# Functional tests for the openeuler/vue image (Vue 2.7.16 on openEuler 24.03-LTS-SP4).
#
# The Dockerfile installs the `vue` npm package globally:
#     RUN npm install -g vue@${VERSION}
# vue@2 is a library package, not a CLI: its package.json declares no "bin"
# entry, so no `vue` executable exists.  The library is consumed from Node via
# require(), therefore the tests drive the real library through `node`.
#
# The runtime image is `openeuler/npmjs` (openEuler rootfs + nodejs), so `node`
# and `npm` are both present.  npm's global module root is put on NODE_PATH so
# that `require('vue')` resolves the globally installed package.

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

WORKDIR="$(mktemp -d)"
cleanup() {
    rm -rf "${WORKDIR}"
}
trap cleanup EXIT

if ! command -v node >/dev/null 2>&1; then
    printf 'FAIL: node interpreter not found in PATH\n' >&2
    exit 1
fi
if ! command -v npm >/dev/null 2>&1; then
    printf 'FAIL: npm not found in PATH\n' >&2
    exit 1
fi

if ! GLOBAL_ROOT="$(npm root -g 2>&1)"; then
    printf 'FAIL: unable to resolve npm global module root: %s\n' \
        "${GLOBAL_ROOT}" >&2
    exit 1
fi
if [[ ! -d "${GLOBAL_ROOT}/vue" ]]; then
    printf 'FAIL: vue package not installed under global root: %s/vue\n' \
        "${GLOBAL_ROOT}" >&2
    exit 1
fi
export NODE_PATH="${GLOBAL_ROOT}${NODE_PATH:+:${NODE_PATH}}"

test_installed_version() {
    local output rc

    if output="$(node -e 'process.stdout.write(require("vue").version)' 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: require("vue").version probe exited %s: %s\n' \
            "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != "${EXPECTED_VERSION}" ]]; then
        printf 'FAIL: version mismatch: expected=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${output}" >&2
        return 1
    fi

    printf 'PASS: exact vue version: %s\n' "${output}"
}

test_core_function() {
    local output rc

    cat > "${WORKDIR}/vue_core.js" <<'JS'
'use strict'

// Exercises the real Vue runtime in Node (no DOM is required for these paths):
// options-API reactivity feeding a computed property, the asynchronous $watch
// flush driven by Vue.nextTick, the composition-API ref/computed helpers that
// Vue 2.7 exposes, and the component render pipeline producing a VNode tree.
const Vue = require('vue')

function assert(condition, message) {
  if (!condition) {
    throw new Error(message)
  }
}

// 1) data -> computed reacts synchronously on read.
const counter = new Vue({
  data() {
    return { count: 1 }
  },
  computed: {
    double() {
      return this.count * 2
    }
  }
})
assert(counter.double === 2, 'computed initial=' + counter.double)
counter.count = 5
assert(counter.double === 10, 'computed updated=' + counter.double)

// 2) $watch is scheduled and flushed on the next tick.
const watched = []
counter.$watch('count', function (value) {
  watched.push(value)
})
counter.count = 8
assert(watched.length === 0, 'watcher fired synchronously')

Vue.nextTick()
  .then(function () {
    assert(
      watched.length === 1 && watched[0] === 8,
      'watcher values=' + JSON.stringify(watched)
    )

    // 3) Composition-API ref/computed exported by Vue 2.7.
    const count = Vue.ref(3)
    const triple = Vue.computed(function () {
      return count.value * 3
    })
    assert(triple.value === 9, 'composition computed initial=' + triple.value)
    count.value = 4
    assert(triple.value === 12, 'composition computed updated=' + triple.value)

    // 4) Component render function -> VNode tree.
    const vm = new Vue({
      data() {
        return { message: 'Hello Vue!' }
      },
      render(h) {
        return h('div', { staticClass: 'greeting' }, [this.message])
      }
    })
    const vnode = vm._render()
    assert(vnode && vnode.tag === 'div', 'vnode tag=' + (vnode && vnode.tag))
    assert(
      vnode.data && vnode.data.staticClass === 'greeting',
      'vnode class=' + JSON.stringify(vnode.data)
    )
    assert(
      vnode.children.length === 1 &&
        vnode.children[0].text === 'Hello Vue!',
      'vnode text=' + JSON.stringify(vnode.children)
    )

    process.stdout.write('CORE_OK\n')
  })
  .catch(function (err) {
    console.error(err && err.stack ? err.stack : String(err))
    process.exit(1)
  })
JS

    if output="$(node "${WORKDIR}/vue_core.js" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: vue core probe exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if [[ "${output}" != *"CORE_OK"* ]]; then
        printf 'FAIL: core probe did not report success:\n%s\n' "${output}" >&2
        return 1
    fi

    printf 'PASS: reactivity, computed, watcher and VNode render\n'
}

main() {
    local failures=0

    if ! test_installed_version; then
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
