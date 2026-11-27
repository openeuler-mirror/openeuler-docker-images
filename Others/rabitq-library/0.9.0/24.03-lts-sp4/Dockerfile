ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=0.9.0

RUN dnf install -y git && dnf clean all

WORKDIR /workspace
RUN git clone https://github.com/VectorDB-NTU/RaBitQ-Library.git && \
    cd RaBitQ-Library && git checkout v${VERSION} && \
    cp -r include /usr/local/include/rabitq
