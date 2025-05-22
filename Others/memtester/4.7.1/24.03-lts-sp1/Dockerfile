ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=4.7.1

RUN dnf update -y \
    && dnf install -y wget gcc make \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN wget https://pyropus.ca./software/memtester/old-versions/memtester-${VERSION}.tar.gz \
    && tar -zxvf memtester-${VERSION}.tar.gz \
    && rm -f memtester-${VERSION}.tar.gz \
    && cd memtester-${VERSION} \
    && make -j $(nproc) \
    && make install

CMD ["/usr/local/bin/memtester"]