#!/bin/bash
set -euo pipefail

: "${EXPECTED_VERSION:?EXPECTED_VERSION is required}"

# The image ships the header-only hnswlib C++ library:
#   /usr/local/include/hnswlib/*.h  (installed from the upstream v0.9.0 archive)
#   /usr/local/share/licenses/hnswlib/LICENSE
# There is no hnswlib binary and the C++ headers expose no version macro, so the
# library is exercised by compiling a small program against the installed header
# and running real HNSW index operations (insert -> search -> serialize -> reload
# -> search again).

HNSWLIB_INCLUDE_DIR="/usr/local/include/hnswlib"
HNSWLIB_HEADER="${HNSWLIB_INCLUDE_DIR}/hnswlib.h"
HNSWLIB_LICENSE="/usr/local/share/licenses/hnswlib/LICENSE"
WORKDIR=""

cleanup() {
    if [[ -n "${WORKDIR}" && -d "${WORKDIR}" ]]; then
        rm -rf "${WORKDIR}"
    fi
}
trap cleanup EXIT

require_command() {
    local tool="$1"
    if ! command -v "${tool}" >/dev/null 2>&1; then
        printf 'FAIL: required runtime command not found: %s\n' "${tool}" >&2
        return 1
    fi
}

# Exact release identity per upstream revision. The installed headers are copied
# byte-for-byte from the pinned upstream archive, so a SHA-256 fingerprint of
# hnswlib.h uniquely identifies the release and rejects any other version.
expected_header_sha256() {
    case "$1" in
        0.9.0)
            printf '%s\n' "54403db81f55fd28246114c5c9f683e663a2a55ad64903b56578c73e6db5ad2c"
            ;;
        *)
            return 1
            ;;
    esac
}

test_headers_installed() {
    local header

    if [[ ! -f "${HNSWLIB_HEADER}" ]]; then
        printf 'FAIL: hnswlib main header not found: %s\n' "${HNSWLIB_HEADER}" >&2
        return 1
    fi

    for header in hnswalg.h space_l2.h space_ip.h bruteforce.h \
                  stop_condition.h visited_list_pool.h; do
        if [[ ! -f "${HNSWLIB_INCLUDE_DIR}/${header}" ]]; then
            printf 'FAIL: expected hnswlib header missing: %s/%s\n' \
                "${HNSWLIB_INCLUDE_DIR}" "${header}" >&2
            return 1
        fi
    done

    if [[ ! -f "${HNSWLIB_LICENSE}" ]]; then
        printf 'FAIL: hnswlib license file not found: %s\n' "${HNSWLIB_LICENSE}" >&2
        return 1
    fi

    printf 'PASS: hnswlib headers installed under %s\n' "${HNSWLIB_INCLUDE_DIR}"
}

test_exact_version() {
    local expected actual rc

    if ! expected="$(expected_header_sha256 "${EXPECTED_VERSION}")"; then
        printf 'FAIL: no verified release fingerprint for hnswlib <%s>\n' \
            "${EXPECTED_VERSION}" >&2
        return 1
    fi

    if actual="$(sha256sum "${HNSWLIB_HEADER}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: sha256sum exited %s: %s\n' "${rc}" "${actual}" >&2
        return 1
    fi
    actual="${actual%% *}"

    if [[ "${actual}" != "${expected}" ]]; then
        printf 'FAIL: installed hnswlib.h is not release %s: expected sha256=<%s> actual=<%s>\n' \
            "${EXPECTED_VERSION}" "${expected}" "${actual}" >&2
        return 1
    fi

    printf 'PASS: exact release fingerprint for hnswlib %s\n' "${EXPECTED_VERSION}"
}

test_core_function() {
    local src="${WORKDIR}/hnsw_check.cpp"
    local bin="${WORKDIR}/hnsw_check"
    local index_path="${WORKDIR}/hnsw_index.bin"
    local expected output rc

    cat > "${src}" <<'EOF'
#include <hnswlib/hnswlib.h>
#include <cstdio>
#include <queue>
#include <string>
#include <utility>
#include <vector>

int main(int argc, char **argv) {
    if (argc != 2) {
        std::fprintf(stderr, "usage: %s <index-path>\n", argv[0]);
        return 2;
    }
    const std::string index_path = argv[1];

    const size_t dim = 16;
    const size_t max_elements = 200;
    const size_t M = 16;
    const size_t ef_construction = 200;

    hnswlib::L2Space space(dim);
    hnswlib::HierarchicalNSW<float> *index =
        new hnswlib::HierarchicalNSW<float>(&space, max_elements, M, ef_construction);
    index->setEf(max_elements);

    std::vector<float> data(dim * max_elements, 0.0f);
    for (size_t i = 0; i < max_elements; ++i) {
        data[i * dim] = static_cast<float>(i);
        index->addPoint(data.data() + i * dim, static_cast<hnswlib::labeltype>(i));
    }

    std::vector<float> query(dim, 0.0f);

    query[0] = 7.0f;
    std::priority_queue<std::pair<float, hnswlib::labeltype> > self =
        index->searchKnn(query.data(), 1);
    if (self.empty()) {
        std::fprintf(stderr, "FAIL: empty result for exact self query\n");
        return 1;
    }
    std::printf("self_label=%zu self_dist=%.6f\n",
                static_cast<size_t>(self.top().second), self.top().first);

    query[0] = 150.25f;
    std::priority_queue<std::pair<float, hnswlib::labeltype> > far =
        index->searchKnn(query.data(), 1);
    if (far.empty()) {
        std::fprintf(stderr, "FAIL: empty result for interpolated query\n");
        return 1;
    }
    std::printf("far_label=%zu far_dist=%.6f\n",
                static_cast<size_t>(far.top().second), far.top().first);

    query[0] = 42.4f;
    std::priority_queue<std::pair<float, hnswlib::labeltype> > nearest =
        index->searchKnn(query.data(), 1);
    if (nearest.empty()) {
        std::fprintf(stderr, "FAIL: empty k=1 result\n");
        return 1;
    }
    std::printf("interp_label=%zu\n", static_cast<size_t>(nearest.top().second));

    std::vector<std::pair<float, hnswlib::labeltype> > neighbors =
        index->searchKnnCloserFirst(query.data(), 3);
    if (neighbors.size() != 3) {
        std::fprintf(stderr, "FAIL: k=3 returned %zu results\n", neighbors.size());
        return 1;
    }
    std::printf("knn3=%zu,%zu,%zu\n",
                static_cast<size_t>(neighbors[0].second),
                static_cast<size_t>(neighbors[1].second),
                static_cast<size_t>(neighbors[2].second));

    index->saveIndex(index_path);
    delete index;

    index = new hnswlib::HierarchicalNSW<float>(&space, index_path);
    index->setEf(max_elements);
    std::priority_queue<std::pair<float, hnswlib::labeltype> > reloaded =
        index->searchKnn(query.data(), 1);
    if (reloaded.empty()) {
        std::fprintf(stderr, "FAIL: empty result after reloading saved index\n");
        return 1;
    }
    std::printf("reload_interp_label=%zu\n",
                static_cast<size_t>(reloaded.top().second));
    delete index;

    std::printf("HNSWLIB_CORE_OK\n");
    return 0;
}
EOF

    if output="$(g++ -std=c++11 -O2 -pthread -I/usr/local/include "${src}" -o "${bin}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: g++ compile of hnswlib probe exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    if output="$("${bin}" "${index_path}" 2>&1)"; then
        :
    else
        rc=$?
        printf 'FAIL: hnswlib probe exited %s:\n%s\n' "${rc}" "${output}" >&2
        return 1
    fi

    expected="$(cat <<'EXPECTED'
self_label=7 self_dist=0.000000
far_label=150 far_dist=0.062500
interp_label=42
knn3=42,43,41
reload_interp_label=42
HNSWLIB_CORE_OK
EXPECTED
)"

    if [[ "${output}" != "${expected}" ]]; then
        printf 'FAIL: hnswlib core result mismatch:\nexpected:\n%s\nactual:\n%s\n' \
            "${expected}" "${output}" >&2
        return 1
    fi

    printf 'PASS: HNSW add/search + save/reload data path returned exact labels\n'
}

main() {
    local failures=0

    for tool in g++ sha256sum mktemp; do
        if ! require_command "${tool}"; then
            failures=$((failures + 1))
        fi
    done
    if (( failures > 0 )); then
        printf 'TESTS_FAILED: %s failure(s)\n' "${failures}" >&2
        return 1
    fi

    WORKDIR="$(mktemp -d /tmp/hnswlib_test.XXXXXX)" || {
        printf 'FAIL: could not create temporary working directory\n' >&2
        return 1
    }

    if ! test_headers_installed; then
        failures=$((failures + 1))
    fi
    if ! test_exact_version; then
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
