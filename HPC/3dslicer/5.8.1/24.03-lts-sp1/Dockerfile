ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=5.8.1
ARG TARGETARCH

RUN yum install -y \
        git gcc g++ make cmake patch \
        qt5-devel qt5-qtbase-devel qt5-qtx11extras-devel qt5-qtmultimedia-devel \
        qt5-qtsvg-devel qt5-qtwebengine-devel qt5-qtxmlpatterns-devel qt5-qttools-devel \
        qt5-qtbase-private-devel libXt-devel openssl-devel hwloc hwloc-devel && \
    yum clean all

COPY zlib.patch /opt/
COPY build-tbb.sh /opt/
COPY build-Slicer.sh /opt/
COPY build-CTKAppLauncher.sh /opt/

WORKDIR /opt/
RUN ./build-CTKAppLauncher.sh && \
    ./build-tbb.sh && \
    ./build-Slicer.sh $VERSION /opt/zlib.patch
