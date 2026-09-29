ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2.99.85
ARG TARGETARCH
ARG BUILDARCH

RUN yum install -y \
        git python3-pip wget cmake make gcc gcc-c++ \
        libstdc++ libgcc zlib freetype \
        mesa-libGL mesa-libGL-devel mesa-libGLU mesa-libGLU-devel \
        libSM xcb-util-renderutil xcb-util-keysyms xcb-util-image xcb-util-wm && \
    yum clean all

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
    conda create -n eman2 -y python=3.12 && \
    conda activate eman2 && \
    conda install -y -c conda-forge \
        biopython boost cmake configparser fftw freetype ftgl future gsl \
        hdf5 ipython ipywidgets jupyterlab libfreetype libpng libtiff \
        matplotlib nodejs numpy pandas scikit-learn scipy tqdm umap-learn zlib && \
    pip install PyOpenGL PyOpenGL_accelerate && \
    mkdir -p /opt/eman2/build && cd /opt/eman2/build && \
    cmake .. -DENABLE_OPTIMIZE_MACHINE=ON && \
    make -j4 && make install

ENV QT_QPA_PLATFORM_PLUGIN_PATH=/usr/local/miniconda/envs/eman2/plugins/platforms
ENV QT_QPA_PLATFORM=offscreen

WORKDIR /usr/local/miniconda/envs/eman2/bin/
