ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)
ARG VERSION=1.5.1

RUN dnf update -y \
    && dnf install -y gcc make wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN wget https://github.com/redis/hiredis/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -xzf v${VERSION}.tar.gz \
    && cd hiredis-${VERSION} \
    && make \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf hiredis-${VERSION} v${VERSION}.tar.gz

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

CMD ["bash"]
