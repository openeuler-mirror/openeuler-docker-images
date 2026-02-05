ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS builder
ARG VERSION=26.01

RUN dnf update -y \
    && dnf install -y git make gcc \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

RUN git clone -b v${VERSION} --depth 1 https://github.com/spdk/spdk \
    && cd spdk/ \
    && git submodule update --init

WORKDIR /opt/spdk

# Workaround: pip 26.0 removed PackageFinder.allow_all_prereleases used by
# pip-tools 7.5.2 in pkgdep.sh. Remove --upgrade-deps to keep venv pip at
# the compatible version bundled with system Python.
RUN sed -i 's/--upgrade-deps //' scripts/pkgdep/rhel.sh

RUN ./scripts/pkgdep.sh \
    && ./configure \
    && make -j$(nproc)

CMD ["./test/unit/unittest.sh"]
