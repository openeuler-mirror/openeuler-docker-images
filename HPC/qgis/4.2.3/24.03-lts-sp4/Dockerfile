ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=4.2.3
ARG QGIS_BRANCH=final-4_2_2
ARG TARGETARCH

RUN dnf install -y --setopt=install_weak_deps=False \
        git gcc gcc-c++ make cmake patch bison flex wget \
        qt6-qtbase-devel qt6-qtbase-private-devel qt6-qttools-devel qt6-qt5compat-devel \
        qt6-qtsvg-devel qt6-qtdeclarative-devel qt6-qtpositioning-devel qt6-qtserialport-devel \
        qt6-qtmultimedia-devel qt6-qt3d-devel qt6-qtlocation-devel qt6-qtwebengine-devel \
        qtkeychain-qt6-devel \
        gdal-devel geos-devel proj-devel sqlite-devel libspatialite-devel freexl-devel \
        zlib-devel expat-devel libzip-devel zstd-devel protobuf-devel protobuf-compiler \
        protobuf-lite protobuf-lite-devel openssl-devel \
        exiv2-devel hdf5-devel netcdf-devel libpq-devel gsl-devel nlohmann-json-devel \
        python3-devel python3 && \
    dnf clean all

COPY build-QScintilla.sh /opt/
COPY build-QCA.sh /opt/
COPY build-QGIS.sh /opt/
COPY qgis-qt65.patch /opt/

WORKDIR /opt/
RUN ./build-QScintilla.sh && \
    ./build-QCA.sh && \
    ./build-QGIS.sh ${QGIS_BRANCH} /opt/qgis-qt65.patch && \
    rm -rf /opt/QGIS /opt/QGIS-build /opt/qca /opt/QScintilla-* && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/qgis.conf && \
    ldconfig
