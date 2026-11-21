ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
ARG VERSION=2.8.3

RUN dnf update -y && dnf install -y shadow-utils findutils

RUN groupadd --system netdata && useradd --system -g netdata -s /sbin/nologin -M netdata

RUN arch="$(uname -m)"; \
    if [ "${arch}" = "x86_64" ]; then nd_arch=x86_64; else nd_arch=aarch64; fi; \
    curl -fSL --retry 3 -o /tmp/netdata.run \
        "https://github.com/netdata/netdata/releases/download/v2.8.3/netdata-${nd_arch}-v2.8.3.gz.run" && \
    chmod +x /tmp/netdata.run && \
    yes | /tmp/netdata.run -- --install-prefix=/opt/netdata --dont-start-it --dont-wait --non-interactive --no-updates --disable-telemetry && \
    rm -f /tmp/netdata.run

WORKDIR /opt

# installed by the pinned static build above



CMD ["./netdata/bin/netdata", "--help"]