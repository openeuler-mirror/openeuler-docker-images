ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder
ARG VERSION=26.09

RUN dnf update -y \
    && dnf install -y git make gcc \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

RUN git clone -b v${VERSION} --depth 1 https://github.com/spdk/spdk \
    && cd spdk/ \
    && git submodule update --init

WORKDIR /opt/spdk

# SPDK v26.09 generates include/spdk_internal/rpc_autogen.h during `make`,
# which runs scripts/genrpc.py (imports pyyaml, jinja2, tabulate). pkgdep.sh
# installs those into its Python venv, so make the venv active for the build.
ENV PATH="/var/spdk/dependencies/pip/bin:${PATH}"

RUN ./scripts/pkgdep.sh \
    && ./configure \
    && make -j$(nproc)

CMD ["./test/unit/unittest.sh"]
