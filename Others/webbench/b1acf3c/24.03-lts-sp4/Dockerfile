ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

# WebBench is published without release tags, so the build is pinned to a
# fixed commit and the commit is used as the version of this image.
ARG VERSION=b1acf3c

RUN dnf install -y git gcc make ctags libtirpc-devel \
    && dnf clean all

WORKDIR /opt
RUN git clone https://github.com/EZLippi/WebBench && \
    cd WebBench && \
    git checkout ${VERSION} && \
    rm -rf .git

WORKDIR /opt/WebBench

RUN mkdir -p /usr/local/man/man1 && \
    make CFLAGS="-ggdb -W -I/usr/include/tirpc" && \
    make install

CMD ["webbench", "--help"]
