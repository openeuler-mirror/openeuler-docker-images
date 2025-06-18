ARG BASE=openeuler/openeuler:22.03
ARG PY_VERSION=3.10.12
ARG PY_MAJOR_VERSION=3.10

# Stage 1: Install Python
FROM ${BASE} AS python-installer

ARG PY_VERSION
ARG PY_MAJOR_VERSION

# Python Environment variables
ENV PATH=${PY_HOME}/bin:${PATH}

RUN yum update -y && \
    yum install -y \
        gcc \
        gcc-c++ \
        make \
        cmake \
        curl \
        zlib-devel \
        bzip2-devel \
        openssl-devel \
        ncurses-devel \
        sqlite-devel \
        readline-devel \
        tk-devel \
        gdbm-devel \
        libpcap-devel \
        xz-devel \
        libev-devel \
        expat-devel \
        libffi-devel \
        systemtap-sdt-devel \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*

# Install Python
RUN PY_INSTALLER_DIR=Python-${PY_VERSION} && \
    PY_HOME=/usr/local/python${PY_VERSION} && \
    curl -fsSL https://repo.huaweicloud.com/python/${PY_VERSION}/${PY_INSTALLER_DIR}.tgz -o /tmp/${PY_INSTALLER_DIR}.tgz && \
    tar -xf /tmp/${PY_INSTALLER_DIR}.tgz -C /tmp && \
    cd /tmp/${PY_INSTALLER_DIR} && \
    mkdir -p ${PY_HOME}/lib && \
    ./configure --enable-shared --enable-shared LDFLAGS="-Wl,-rpath ${PY_HOME}/lib" --prefix=${PY_HOME} && \
    make -j $(nproc) && \
    make altinstall && \
    ln -sf ${PY_HOME}/bin/python${PY_MAJOR_VERSION} ${PY_HOME}/bin/python3 && \
    ln -sf ${PY_HOME}/bin/pip${PY_MAJOR_VERSION} ${PY_HOME}/bin/pip3 && \
    ln -sf ${PY_HOME}/bin/python3 ${PY_HOME}/bin/python && \
    ln -sf ${PY_HOME}/bin/pip3 ${PY_HOME}/bin/pip && \
    rm -rf /tmp/*

# Stage 2: Install CUDA
FROM ${BASE} AS cuda-installer

ARG TARGETPLATFORM
ARG PY_VERSION
ARG PY_MAJOR_VERSION
ARG PY_HOME=/usr/local/python${PY_VERSION}

ENV PATH=${PY_HOME}/bin:${PATH}
ENV PATH=${PATH}:/usr/local/cuda-11.8/bin
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-11.8/lib64

COPY --from=python-installer ${PY_HOME} ${PY_HOME}

RUN yum update -y && \
    yum install -y \
        wget \
        gcc \
        make \
        xz-devel \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN \
    if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then \
        CUDA_URL="https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux_sbsa.run"; \
    else \
        CUDA_URL="https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run"; \
    fi && \
    wget --quiet ${CUDA_URL} -O ~/cuda_11.8.0_520.61.05_linux.run && \
    chmod +x ~/cuda_11.8.0_520.61.05_linux.run && \
    ~/cuda_11.8.0_520.61.05_linux.run --toolkit --silent && \
    rm -f ~/cuda_11.8.0_520.61.05_linux.run

RUN ARCH=$(case "${TARGETPLATFORM}" in \
    "linux/amd64") echo "x86_64" ;; \
    "linux/arm64") echo "aarch64" ;; \
    *) echo "Unsupported TARGETPLATFORM: ${TARGETPLATFORM}" && exit 1 ;; \
    esac) && \
    mkdir -p /tmp/cudnn && \
    wget https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-${ARCH}/cudnn-linux-${ARCH}-8.9.1.23_cuda11-archive.tar.xz -O /tmp/cudnn.tar.xz && \
    tar -xvf /tmp/cudnn.tar.xz -C /tmp/cudnn --strip-components=1 && \
    cp /tmp/cudnn/include/cudnn.h /usr/local/cuda-11.8/include && \
    cp /tmp/cudnn/lib/libcudnn* /usr/local/cuda-11.8/lib64 && \
    chmod a+r /usr/local/cuda-11.8/include/cudnn.h /usr/local/cuda-11.8/lib64/libcudnn* && \
    rm -rf /tmp/cudnn*
