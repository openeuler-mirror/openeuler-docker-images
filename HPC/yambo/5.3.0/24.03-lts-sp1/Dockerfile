ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=5.3.0

WORKDIR /opt/

RUN yum install -y gcc gcc-c++ libstdc++-devel autoconf automake libtool wget git gcc-gfortran cmake zlib-devel && \
    git clone -b ${VERSION} https://github.com/yambo-code/yambo.git && \
    cd yambo && ./configure && \
    sed -i '/^lblas/d' config/setup && \
    sed -i '/^llapack/d' config/setup && \
    sed -i "\$a lblas       =$(echo "$PWD")/lib/external/gfortran/gfortran/lib64/libblas.a" config/setup && \
    sed -i "\$a lblaspetsc  =$(echo "$PWD")/lib/external/gfortran/gfortran/lib64/libblas.so" config/setup && \
    sed -i "\$a llapack     =$(echo "$PWD")/lib/external/gfortran/gfortran/lib64/liblapack.a" config/setup && \
    sed -i "\$a llapackpetsc=$(echo "$PWD")/lib/external/gfortran/gfortran/lib64/liblapack.so" config/setup && \
    make all

WORKDIR /opt/yambo