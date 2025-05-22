ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER
ARG VERSION=0.73

RUN dnf update -y \
    && dnf install -y gcc make git automake \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN git clone -b v${VERSION} --depth 1 https://github.com/samhocevar/rinetd \
    && cd rinetd \
    && ./bootstrap \
    && ./configure \
    && make \
    && make install

CMD ["bash"]