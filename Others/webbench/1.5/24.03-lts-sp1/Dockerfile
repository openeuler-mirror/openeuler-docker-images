ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=1.5

RUN dnf update -y \
    && dnf install -y gcc make ctags libtirpc-devel \
    && dnf clean all

WORKDIR /opt

RUN curl -LO http://home.tiscali.cz/~cz210552/distfiles/webbench-${VERSION}.tar.gz \
    && tar -xzf webbench-${VERSION}.tar.gz \
    && rm -f webbench-${VERSION}.tar.gz

WORKDIR /opt/webbench-${VERSION}

RUN mkdir -p /usr/local/man/man1 && \
    make CFLAGS="-ggdb -W -I/usr/include/tirpc" && \
    make install

CMD ["webbench", "--help"]