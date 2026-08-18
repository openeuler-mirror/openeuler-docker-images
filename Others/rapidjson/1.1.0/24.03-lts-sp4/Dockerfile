ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS build

ARG VERSION=1.1.0

RUN dnf install -y \
      cmake gcc-c++ make \
      && dnf clean all

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --retry 3 -o rapidjson.tar.gz https://github.com/Tencent/rapidjson/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -zxf rapidjson.tar.gz && \
    rm -f rapidjson.tar.gz && \
    mkdir -p rapidjson-${VERSION}/build && \
    cd rapidjson-${VERSION}/build && \
    cmake .. \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DRAPIDJSON_BUILD_DOC=OFF \
      -DRAPIDJSON_BUILD_EXAMPLES=OFF \
      -DRAPIDJSON_BUILD_TESTS=OFF \
      -DRAPIDJSON_BUILD_THIRDPARTY_GTEST=OFF && \
    make install DESTDIR=/opt/stage && \
    cd / && rm -rf /opt/rapidjson-${VERSION}

FROM ${BASE}

RUN dnf install -y \
      gcc-c++ make \
      && dnf clean all

COPY --from=build /opt/stage/usr /usr

CMD ["bash"]
