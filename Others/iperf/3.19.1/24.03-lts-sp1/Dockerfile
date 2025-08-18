ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=3.19.1

RUN dnf update -y \
    && dnf install -y git make gcc \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN git clone -b ${VERSION} --depth 1 https://github.com/esnet/iperf \
    && cd iperf \
    && ./configure --prefix=/usr/local \
    && make -j $(nproc) \
    && make install

CMD ["/usr/local/bin/iperf3", "--help"]