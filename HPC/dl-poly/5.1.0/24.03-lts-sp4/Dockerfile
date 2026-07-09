ARG BASE=openeuler/openeuler:24.03-lts-sp4
ARG VERSION=5.1.0
FROM ${BASE} AS builder
ARG VERSION=5.1.0

RUN dnf update -y --disablerepo=source \
    && dnf install -y --disablerepo=source gcc-gfortran cmake make wget openmpi-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

ENV PATH="/usr/lib64/openmpi/bin:${PATH}"

WORKDIR /opt

RUN wget https://github.com/ccp5UK/dl-poly/archive/refs/tags/${VERSION}.tar.gz \
    && tar -xzf ${VERSION}.tar.gz \
    && rm -f ${VERSION}.tar.gz

WORKDIR /opt/dl-poly-${VERSION}

RUN mkdir -p build \
    && cd build \
    && cmake .. -DCMAKE_BUILD_TYPE=Release -DWITH_MPI=ON \
    && make -j$(nproc)

FROM ${BASE}
ARG VERSION=5.1.0

RUN dnf update -y --disablerepo=source \
    && dnf install -y --disablerepo=source openmpi \
    && dnf clean all \
    && rm -rf /var/cache/dnf

ENV PATH="/usr/lib64/openmpi/bin:${PATH}"
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

COPY --from=builder /opt/dl-poly-${VERSION}/build /opt/dl-poly

WORKDIR /opt/dl-poly

CMD ["bash"]