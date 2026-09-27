ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=5.12.4
ARG BRANCH=v${VERSION}
ARG TARGETARCH

RUN yum install -y \
        git gcc g++ make cmake patch \
        qt5-devel qt5-qtbase-devel qt5-qtx11extras-devel qt5-qtmultimedia-devel \
        qt5-qtsvg-devel qt5-qtwebengine-devel qt5-qtxmlpatterns-devel qt5-qttools-devel \
        qt5-qtbase-private-devel libXt-devel openssl-devel hwloc hwloc-devel && \
    yum clean all

# PythonQt's wrapper generator uses its own preprocessor, which needs the
# system include directory to resolve glibc headers referenced by Qt's
# qconfig.h (e.g. <bits/wordsize.h>). Without it the generator silently emits
# zero classes and the generated wrapper sources are missing when PythonQt is
# configured, failing with "PythonQt: missing generated wrapper sources".
ENV PYTHONQT_INCLUDE=/usr/include

COPY build-tbb.sh /opt/
COPY build-Slicer.sh /opt/
COPY build-CTKAppLauncher.sh /opt/
COPY slicer-arm64.patch /opt/

WORKDIR /opt/
RUN ./build-CTKAppLauncher.sh && \
    ./build-tbb.sh && \
    ./build-Slicer.sh ${BRANCH} /opt/slicer-arm64.patch