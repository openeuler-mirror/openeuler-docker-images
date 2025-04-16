ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=1.0

RUN yum install -y \
        make \
        gcc \
        gcc-c++ \
        cmake \
        git \
        wget \ 
        boost \
        gflags \
        glog-devel \
        hdf5-devel \
        leveldb-devel \
        lmdb-devel \
        protobuf-devel \
        snappy-devel \
        python-pandas \
        boost-devel \
        python3-devel \
        opencv \
        openblas-devel \
        patch \
        python-pip \
        doxygen \
        ghostscript \
        texlive && \
    yum clean all

ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT

RUN git clone -b ${VERSION} --depth 1 https://github.com/BVLC/caffe.git . && \
     pip install --upgrade pip && \
    cd python && \
    for req in $(cat requirements.txt) pydot; do pip install $req; done && \
    ln -s /usr/lib64/libboost_python311.so.1.83.0 /usr/lib64/libboost_python.so && \
    ln -s /usr/bin/python3 /usr/bin/python
 
COPY opencv.patch $CAFFE_ROOT/
COPY protobuf.patch $CAFFE_ROOT/
COPY Makefile.patch $CAFFE_ROOT/
RUN cd $CAFFE_ROOT && \
    patch -Np1 < Makefile.patch && \
    patch -Np1 < opencv.patch && \
    patch -Np1 < protobuf.patch && \
    mkdir build && cd build && \
    cmake -DCPU_ONLY=1 .. && \
    make -j"$(nproc)"

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

WORKDIR /workspace
