ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE} AS builder
ARG VERSION=4.5.0
ARG TARGETARCH
ARG BUILDARCH
ARG OPENLDAP_ARGS

RUN yum install -y java-1.8.0-openjdk-devel maven make gcc cyrus-sasl-devel krb5-devel \
    libxml2-devel libxslt-devel glibc-static g++ vim-common libdb-devel perl wget \
    git

ARG LIBFFI_VERSION=3.0.13
RUN wget https://github.com/libffi/libffi/archive/refs/tags/v${LIBFFI_VERSION}.tar.gz -O /tmp/v${LIBFFI_VERSION}.tar.gz && \
    cd /tmp && tar -xvf v${LIBFFI_VERSION}.tar.gz && \
    chmod +x /tmp/libffi-${LIBFFI_VERSION}/configure && \
    /tmp/libffi-${LIBFFI_VERSION}/configure ${LIBFFI_ARGS} --prefix=/usr/local && \
    make -j $(nproc) install && \
    ln -s /usr/local/lib64/libffi.so.6 /usr/lib64/libffi.so.6 && \
    rm -rf /tmp/*

ARG OPENSSL_VERSION=1.1.1g
ARG OPENSSL_ROOT_DIR=/usr/local/openssl
RUN wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz -O /tmp/openssl-${OPENSSL_VERSION}.tar.gz && \
    cd /tmp && tar -xvf openssl-${OPENSSL_VERSION}.tar.gz && \
    cd openssl-${OPENSSL_VERSION} && \
    ./config shared --openssldir=${OPENSSL_ROOT_DIR} --prefix=${OPENSSL_ROOT_DIR} && \
    make -j$(nproc) && make install && \
    ln -s ${OPENSSL_ROOT_DIR}/lib/libssl.so.1.1 /usr/lib64/libssl.so.1.1 && \
    ln -s ${OPENSSL_ROOT_DIR}/lib/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1 && \
    rm -rf /tmp/*

ARG OPENLDAP_VERSION=2.4.47
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        OPENLDAP_ARGS=""; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        OPENLDAP_ARGS="--build=arm"; \
    fi; \
    wget https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-${OPENLDAP_VERSION}.tgz -O /tmp/openldap-${OPENLDAP_VERSION}.tgz && \
    cd /tmp && tar -xvf openldap-${OPENLDAP_VERSION}.tgz && \
    cd openldap-${OPENLDAP_VERSION} && \
    ./configure ${OPENLDAP_ARGS} --prefix=/usr/local/openldap-${OPENLDAP_VERSION} CFLAGS="-fPIC" CXXFLAGS="-fPIC" && \
    make -j$(nproc) depend && \
    make -j$(nproc) install && \
    rm -rf /tmp/*

ARG PYTHON_VERSION=3.8.11
COPY patches/build_impala.patch /opt/build_impala.patch
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${BUILDARCH}.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /usr/local/miniconda && rm -f ~/miniconda.sh && \
    /usr/local/miniconda/bin/conda init bash && \
    /usr/local/miniconda/bin/conda tos accept --channel https://repo.anaconda.com/pkgs/main && \
    /usr/local/miniconda/bin/conda create --name python_impala -y python=${PYTHON_VERSION} && \
    bash -c 'source /usr/local/miniconda/etc/profile.d/conda.sh && \
    conda activate python_impala && \
    cd /opt && \
    git clone -b $VERSION https://github.com/apache/impala.git && \
    cd impala && \
    git apply --ignore-space-change --ignore-whitespace --whitespace=nowarn /opt/build_impala.patch && \
    sed -i -e "s/^ID=\"openEuler\"/ID=\"centos\"/" \
           -e "s/^VERSION_ID=\"24.03\"/VERSION_ID=\"8\"/" /etc/os-release && \
    ./buildall.sh -notests -release -noclean && \
    sed -i -e "s/^ID=\"centos\"/ID=\"openEuler\"/" \
           -e "s/^VERSION_ID=\"8\"/VERSION_ID=\"24.03\"/" /etc/os-release && \
    conda deactivate && \
    /usr/local/miniconda/_conda constructor uninstall --prefix /usr/local/miniconda'  && \
    rm -rf /tmp/*