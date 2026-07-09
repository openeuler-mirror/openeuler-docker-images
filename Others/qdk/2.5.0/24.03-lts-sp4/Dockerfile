ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2.5.0

RUN dnf install -y \
      git gcc make \
      wget curl openssl rsync \
      coreutils findutils grep sed gawk && \
    dnf clean all

WORKDIR /build

RUN git clone --depth 1 --branch v${VERSION} https://github.com/qnap-dev/QDK.git . && \
    cd src && make && \
    cp -rf /build/shared /usr/share/QDK && \
    mkdir -p /usr/share/QDK/bin && \
    cp -f /build/src/bin/* /usr/share/QDK/bin/ && \
    cd / && rm -rf /build

RUN mkdir -p /etc/config && \
    sed -e '2d' /usr/share/QDK/qdk.conf > /etc/config/qdk.conf && \
    sed -i '2iQDK_PATH_P=/usr/share' /etc/config/qdk.conf

ENV PATH=$PATH:/usr/share/QDK/bin

WORKDIR /workspace