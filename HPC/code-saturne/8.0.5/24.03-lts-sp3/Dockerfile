ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=8.0.5
ARG TAG=v${VERSION}
RUN yum install -y \
        gcc gcc-c++ gcc-gfortran \
        git make autoconf automake libtool \
        python3 python3-devel python3-setuptools \
        openmpi-devel openblas-devel zlib-devel \
        xz && \
    yum clean all && rm -rf /var/cache/yum
ENV PATH=/usr/lib64/openmpi/bin:/usr/local/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib64/openmpi/lib
RUN git clone -b ${TAG} https://github.com/code-saturne/code_saturne.git /code-saturne && \
    cd /code-saturne && \
    ./sbin/bootstrap && \
    mkdir build && cd build && \
    CC=mpicc CXX=mpicxx FC=gfortran \
    ../configure \
        --prefix=/usr/local \
        --disable-gui \
        --enable-relocatable && \
    make -j 4
RUN cd /code-saturne/build && \
    make install V=1 && \
    rm -rf /code-saturne
WORKDIR /workspace
CMD ["/bin/bash"]