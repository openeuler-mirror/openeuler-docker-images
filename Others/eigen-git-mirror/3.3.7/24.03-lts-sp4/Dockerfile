ARG BASE=openeuler/openeuler:24.03-lts-sp4

FROM ${BASE} AS build
ARG VERSION=3.3.7
RUN dnf install -y \
        gcc-c++ \
        make cmake && \
    dnf clean all

WORKDIR /opt

RUN curl -fSL --retry 3 --connect-timeout 10 \
        -o eigen.tar.gz https://github.com/eigenteam/eigen-git-mirror/archive/refs/tags/${VERSION}.tar.gz && \
    tar -xzf eigen.tar.gz && \
    cmake -S eigen-git-mirror-${VERSION} -B eigen-build -DCMAKE_INSTALL_PREFIX=/usr/local && \
    cmake --build eigen-build --target install && \
    rm -rf eigen-git-mirror-${VERSION} eigen-build eigen.tar.gz

FROM ${BASE}
RUN dnf install -y \
        gcc-c++ \
        make cmake && \
    dnf clean all

COPY --from=build /usr/local/include/eigen3 /usr/local/include/eigen3
COPY --from=build /usr/local/share/eigen3 /usr/local/share/eigen3
COPY --from=build /usr/local/share/pkgconfig/eigen3.pc /usr/local/share/pkgconfig/eigen3.pc

USER root

CMD ["bash"]
