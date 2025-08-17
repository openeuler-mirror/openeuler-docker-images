ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=7.7.2

RUN dnf update -y \
    && dnf install -y wget diffutils jemalloc-devel libunwind-devel \
    python3-sphinx make autoconf automake libedit-devel libtool \
    ncurses-devel pcre2-devel pkgconfig python3-docutils cpio graphviz \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://varnish-cache.org/downloads/varnish-${VERSION}.tgz \
    && tar -zxvf varnish-${VERSION}.tgz \
    && rm -f varnish-${VERSION}.tgz

WORKDIR /opt/varnish-${VERSION}

RUN ./autogen.sh \
    && ./configure \
    && make -j \
    && make install

CMD ["varnishd", "--help"]