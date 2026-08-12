ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=1.0.6

RUN dnf install -y \
        gcc gcc-c++ make && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 3 -o /tmp/SURVIVOR.tar.gz \
        https://github.com/fritzsedlazeck/SURVIVOR/archive/refs/tags/v${VERSION}.tar.gz && \
    mkdir -p /opt/SURVIVOR && \
    tar -xzf /tmp/SURVIVOR.tar.gz -C /opt/SURVIVOR --strip-components=1 && \
    rm -f /tmp/SURVIVOR.tar.gz && \
    cd /opt/SURVIVOR/Debug && \
    make -j$(nproc) && \
    install -m 0755 SURVIVOR /usr/local/bin/SURVIVOR && \
    rm -rf /opt/SURVIVOR

FROM ${BASE}

COPY --from=builder /usr/local/bin/SURVIVOR /usr/local/bin/SURVIVOR

USER root
CMD ["/bin/bash"]
