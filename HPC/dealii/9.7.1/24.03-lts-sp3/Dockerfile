ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=9.7.1
ARG TAG=v${VERSION}
RUN yum install -y \
        gcc gcc-c++ \
        openmpi-devel openblas-devel lapack-devel \
        cmake git make zlib-devel && \
    yum clean all && rm -rf /var/cache/yum
ENV PATH=/usr/lib64/openmpi/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib
RUN git clone --branch ${TAG} --depth=1 https://github.com/dealii/dealii.git /dealii-src && \
    mkdir /dealii-src/build && \
    cd /dealii-src/build && \
    cmake /dealii-src \
        -DCMAKE_INSTALL_PREFIX=/opt/dealii \
        -DCMAKE_BUILD_TYPE=Release \
        -DDEAL_II_WITH_MPI=ON \
        -DDEAL_II_WITH_LAPACK=ON \
        -DDEAL_II_WITH_ZLIB=ON \
        -DDEAL_II_WITH_64BIT_INDICES=OFF \
        -DDEAL_II_WITH_COMPLEX_VALUES=OFF \
        -DDEAL_II_COMPONENT_EXAMPLES=OFF \
        -DDEAL_II_COMPONENT_DOCUMENTATION=OFF \
        -DDEAL_II_ALLOW_AUTODETECTION=ON && \
    make -j2 && \
    make install && \
    cd / && rm -rf /dealii-src
FROM $BASE
RUN yum install -y \
        openmpi openblas lapack zlib libgomp && \
    yum clean all && rm -rf /var/cache/yum
ENV PATH=/usr/lib64/openmpi/bin:/opt/dealii/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:/opt/dealii/lib:/opt/dealii/lib64
COPY --from=0 /opt/dealii /opt/dealii
WORKDIR /workspace
CMD ["/bin/bash"]