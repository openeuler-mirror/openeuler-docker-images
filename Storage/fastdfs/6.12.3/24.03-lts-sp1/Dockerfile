ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=6.12.3

RUN dnf update -y \
    && dnf install -y gcc cmake perl libfastcommon-devel libserverframe-devel git \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN git clone -b V1.0.75 --depth 1 https://github.com/happyfish100/libfastcommon.git \
    && cd libfastcommon \
    && ./make.sh clean \
    && ./make.sh \
    && ./make.sh install \
    && cd .. \
    && rm -rf libfastcommon

RUN git clone -b V1.2.5 --depth 1 https://github.com/happyfish100/libserverframe.git \
    && cd libserverframe \
    && ./make.sh clean \
    && ./make.sh \
    && ./make.sh install \
    && cd .. \
    && rm -rf libserverframe

RUN git clone -b V${VERSION} --depth 1 https://github.com/happyfish100/fastdfs.git \
    && cd fastdfs \
    && ./make.sh clean \
    && ./make.sh \
    && ./make.sh install \
    && cd .. \
    && rm -rf fastdfs

CMD ["fdfs_storaged", "--help"]