ARG BASE=openeuler/openeuler:24.03-lts-sp4

FROM ${BASE} AS builder

ARG VERSION=3.15
ARG ROSETTA_REPO=https://github.com/RosettaCommons/rosetta.git
ARG JOBS=

ENV GIT_TERMINAL_PROMPT=0
ENV LANG=C.UTF-8

RUN dnf install -y --setopt=install_weak_deps=False \
        gcc gcc-c++ make zlib-devel findutils \
        ca-certificates git curl xz tar which gawk \
        clang \
        cmake \
        python3 python3-devel python3-pip \
    && dnf clean all && rm -rf /var/cache/dnf \
    && test "$(cmake --version | head -1 | awk '{print $3}' | cut -d. -f1)" -lt 4 \
    && cmajor="$(clang --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 | cut -d. -f1)" \
    && test "$cmajor" -lt 20 \
    && clang++ --version >/dev/null \
    && python3 -c 'import sys; assert (3,8) <= sys.version_info[:2] <= (3,13), sys.version'

RUN python3 -m venv /opt/pyrosetta \
    && /opt/pyrosetta/bin/pip install --no-cache-dir -U pip setuptools wheel ninja

ENV PATH=/opt/pyrosetta/bin:${PATH}

WORKDIR /src
RUN git clone --depth 1 --branch "v${VERSION}" "${ROSETTA_REPO}" rosetta \
    && git -C rosetta describe --tags --exact-match \
    && git -C rosetta rev-parse --short HEAD

WORKDIR /src/rosetta/source/src/python/PyRosetta

# binder uses LLVM 6.0.1's clang and cannot locate openEuler GCC 12's
# libstdc++ headers automatically ("cstddef"/"bits/c++config.h" not found).
# Resolve the GCC major version and the multiarch triplet dynamically so the
# same Dockerfile works on both amd64 and arm64.
RUN set -eux; \
    PY_INC="$(python3 -c 'import sysconfig; print(sysconfig.get_paths()["include"])')"; \
    PY_LIB="$(python3 -c 'import sysconfig, os; print(os.path.join(sysconfig.get_config_var("LIBDIR") or "/usr/lib64", sysconfig.get_config_var("LDLIBRARY") or ("libpython" + sysconfig.get_config_var("VERSION") + ".so")))')"; \
    GCC_MAJOR="$(gcc -dumpversion | cut -d. -f1)"; \
    TRIPLET="$(gcc -dumpmachine)"; \
    test -f "$PY_INC/Python.h"; \
    test -f "$PY_LIB"; \
    test -f "/usr/include/c++/${GCC_MAJOR}/cstddef"; \
    mkdir -p /out; \
    python build.py -j"${JOBS}" \
        --python-include-dir="$PY_INC" \
        --python-lib="$PY_LIB" \
        --binder-llvm-options "-isystem /usr/include/c++/${GCC_MAJOR} -isystem /usr/include/c++/${GCC_MAJOR}/${TRIPLET} -isystem /usr/include/c++/${GCC_MAJOR}/backward"

# Build the wheel separately so the package metadata can be pinned to 3.15.
# ez_setup is removed because it would otherwise download setuptools 3.3,
# which is incompatible with Python 3.11 and modern setuptools.
RUN sed -i '/ez_setup/d' src/setup.py \
    && BUILD_DIR="$(find /src/rosetta/source/build/PyRosetta -type d -path '*/release/build' | head -n 1)" \
    && test -n "$BUILD_DIR" \
    && printf '{"version": "3.15"}\n' > /src/rosetta/source/.version.json \
    && printf '{"version": "3.15"}\n' > "$(dirname "$BUILD_DIR")/version.json" \
    && cd "$BUILD_DIR" \
    && python setup.py bdist_wheel -d /out

FROM ${BASE} AS runtime

ENV LANG=C.UTF-8

RUN dnf install -y --setopt=install_weak_deps=False \
        python3 python3-pip libstdc++ zlib \
    && dnf clean all && rm -rf /var/cache/dnf

COPY --from=builder /out/*.whl /tmp/wheels/
RUN python3 -m venv /opt/pyrosetta \
    && /opt/pyrosetta/bin/pip install --no-cache-dir /tmp/wheels/*.whl \
    && rm -rf /tmp/wheels

ENV PATH=/opt/pyrosetta/bin:${PATH}

RUN python -c "import pyrosetta, pyrosetta.rosetta; print('PyRosetta OK:', pyrosetta.__file__)"

CMD ["python"]
