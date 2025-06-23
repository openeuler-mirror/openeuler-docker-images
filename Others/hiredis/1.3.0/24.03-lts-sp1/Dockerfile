ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=1.3.0

RUN dnf update -y \
    && dnf install -y gcc make wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN wget https://github.com/redis/hiredis/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -xzf v${VERSION}.tar.gz \
    && cd hiredis-${VERSION} \
    && make \
    && make install \
    && ln -sf /usr/lib/libhiredis.so.0.13 /usr/lib/libhiredis.so.0 \
    && ldconfig \
    && cd .. \
    && rm -rf hiredis-${VERSION} v${VERSION}.tar.gz

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

CMD ["bash"]