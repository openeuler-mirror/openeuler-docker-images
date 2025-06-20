ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=2.99.69
ARG TARGETARCH
ARG BUILDARCH

RUN yum install -y \
        git python3-pip wget \
        cmake make gcc g++ libstdc++ libgcc zlib freetype \
        mesa-libGL mesa-libGL-devel mesa-libGLU mesa-libGLU-devel \
        libSM xcb-util-renderutil xcb-util-keysyms xcb-util-image xcb-util-wm 

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$BUILDARCH.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /usr/local/miniconda && \
    /usr/local/miniconda/bin/conda init bash

WORKDIR /opt/

RUN git clone -b v${VERSION} https://github.com/cryoem/eman2.git && \
    cd eman2/ && \
    if [ "$TARGETARCH" = "arm64" ]; then \
        sed -i "s/-m64/-mabi=lp64/g" CMakeLists.txt; \
    fi
RUN source /root/.bashrc && \
    conda create -n eman2 -y python=3.7.11 && \
    conda activate eman2 && \
    pip install matplotlib PyOpenGL PyOpenGL_accelerate future && \
    conda install -y -c conda-forge \
        numpy boost ftgl nose gsl fftw hdf5 libtiff bsddb3 \
        qt libxcb=1.13 pyqt=5.12.3 pyqt-impl=5.12.3 pyqt5-sip=4.19.18 pyqtchart=5.12 pyqtwebengine=5.12.1 && \
    mkdir -p /opt/eman2/build && cd /opt/eman2/build && \
    cmake .. -DENABLE_OPTIMIZE_MACHINE=ON && \
    make && make install

ENV LD_LIBRARY_PATH=/usr/local/miniconda/pkgs/py-boost-1.73.0-py37h839d321_12/lib:$LD_LIBRARY_PATH
ENV QT_QPA_PLATFORM_PLUGIN_PATH=/usr/local/miniconda/envs/eman2/plugins/platforms
ENV QT_QPA_PLATFORM=offscreen

WORKDIR /usr/local/miniconda/envs/eman2/bin/
