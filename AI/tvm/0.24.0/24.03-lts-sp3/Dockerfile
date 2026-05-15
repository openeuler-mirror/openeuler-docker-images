ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE

ARG VERSION=0.24.0

RUN yum install -y \
        git cmake make gcc-c++ \
        libxml2-devel llvm-devel zlib-devel \
        python3-devel python3-pip && \
    yum clean all && rm -rf /var/cache/yum

RUN git clone --recursive -b v${VERSION} https://github.com/apache/tvm.git /tvm

WORKDIR /tvm/build
RUN cp /tvm/cmake/config.cmake . && \
    echo 'set(CMAKE_BUILD_TYPE Release)' >> config.cmake && \
    echo 'set(USE_LLVM ON)' >> config.cmake && \
    echo 'set(HIDE_PRIVATE_SYMBOLS ON)' >> config.cmake && \
    cmake .. && \
    cmake --build . --parallel $(nproc)

RUN cd /tvm/3rdparty/tvm-ffi && \
    pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple . && \
    pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple \
        cloudpickle ml_dtypes numpy packaging psutil pytest scipy tornado typing_extensions xgboost

ENV TVM_LIBRARY_PATH=/tvm/build
ENV PYTHONPATH=/tvm/python:$PYTHONPATH

WORKDIR /workspace
CMD ["/bin/bash"]
