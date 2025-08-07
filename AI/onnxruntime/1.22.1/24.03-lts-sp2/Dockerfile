ARG BASE=openeuler/openeuler:24.03-lts-sp2
ARG VERSION=v1.22.1

FROM $BASE as builder 

ARG VERSION

RUN yum update -y && \
    yum install -y \
        tar \
        ca-certificates \
        gcc-toolset-14-gcc* \
        gcc-toolset-14-binutils* \
        gcc-toolset-14-c++* \
        python3-devel \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        python3-numpy \
        python3-flatbuffers \
        python3-packaging \
        python3-protobuf \
        git && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN pip install --upgrade pip && \
    pip install --no-cache-dir \
        cmake==3.28

ARG ONNXRUNTIME_REPO=https://github.com/microsoft/onnxruntime.git

RUN ln -sf /usr/lib64/libgcc_s.so.1 /opt/openEuler/gcc-toolset-14/root/usr/lib64/libgcc_s.so.1 && \
    source /opt/openEuler/gcc-toolset-14/enable && \
    git clone --recursive -b $VERSION $ONNXRUNTIME_REPO && \
    cd onnxruntime && \
    ./build.sh --allow_running_as_root --skip_submodule_sync --config Release --build_wheel --update --build --parallel --cmake_extra_defines ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER)

ARG BASE
FROM $BASE as runtime

COPY --from=builder onnxruntime/build/Linux/Release/dist/*.whl /root

WORKDIR /root

RUN yum update -y && \
    yum install -y \
    ca-certificates \
    python3-setuptools \
    python3-wheel \
    python3-pip \
    python3-numpy \
    python3-flatbuffers \
    python3-packaging \
    python3-protobuf \
    python3-mpmath \
    python3-sympy && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN python3 -m pip install coloredlogs humanfriendly onnx && \
    python3 -m pip install --no-index --find-links /root onnxruntime && \
    rm -rf /root/*.whl