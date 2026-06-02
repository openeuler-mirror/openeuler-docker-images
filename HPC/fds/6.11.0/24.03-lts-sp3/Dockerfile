ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=6.11.0
ARG TAG=FDS-${VERSION}
RUN yum install -y \
        gcc gcc-c++ gcc-gfortran \
        openmpi-devel cmake git make \
        python3-pip && \
    yum clean all && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir cmake>=3.24
ENV PATH=/usr/lib64/openmpi/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib
RUN git clone --branch ${TAG} https://github.com/firemodels/fds.git /fds-src
WORKDIR /fds-src
RUN cmake -S . -B Build/cmakeb/ompi_gnu_rel \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/fds \
        -DGIT_HASH="${TAG}-0-fds" \
        -DGIT_BRANCH="${TAG}" \
        -DGIT_DATE="2025-01-01" \
        -DBUILD_DATE="Jan 01, 2025 00:00:00" && \
    cmake --build Build/cmakeb/ompi_gnu_rel -j$(nproc) && \
    cmake --install Build/cmakeb/ompi_gnu_rel && \
    cd / && rm -rf /fds-src
FROM $BASE
RUN yum install -y \
        openmpi libgomp && \
    yum clean all && rm -rf /var/cache/yum
ENV PATH=/usr/lib64/openmpi/bin:/opt/fds/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib
COPY --from=0 /opt/fds /opt/fds
WORKDIR /workspace
CMD ["/bin/bash"]