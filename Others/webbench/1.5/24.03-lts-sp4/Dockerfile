ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
ARG VERSION=1.5

RUN dnf update -y \
    && dnf install -y gcc make ctags libtirpc-devel \
    && dnf clean all

WORKDIR /opt

RUN curl -fSL -o webbench.tar.gz https://github.com/baiguo/webbench-1.5/archive/refs/heads/master.tar.gz \
    && tar -xzf webbench.tar.gz \
    && rm -f webbench.tar.gz

WORKDIR /opt/webbench-1.5-master

RUN mkdir -p /usr/local/man/man1 && \
    make CFLAGS="-ggdb -W -I/usr/include/tirpc" && \
    make install

CMD ["webbench", "--help"]
