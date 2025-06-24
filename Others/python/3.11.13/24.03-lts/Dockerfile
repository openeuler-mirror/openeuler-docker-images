ARG BASE=openeuler/openeuler:24.03-lts
ARG VERSION=3.11.13

FROM ${BASE} as builder

ARG VERSION
ARG TARGETARCH

# Install dependencies
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
        systemtap-sdt-devel && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    rm -rf /tmp/*

RUN PY_HOME=/usr/local/python${VERSION} && \
    PY_INSTALLER_DIR=Python-${VERSION} && \
    PY_INSTALLER_TGZ=Python-${VERSION}.tgz && \
    curl -fsSL -o "/tmp/${PY_INSTALLER_TGZ}" "https://repo.huaweicloud.com/python/${VERSION}/${PY_INSTALLER_TGZ}" && \
    tar -xf /tmp/${PY_INSTALLER_TGZ} -C /tmp && \
    cd /tmp/${PY_INSTALLER_DIR} && \
    mkdir -p /${PY_HOME}/lib && \
    ./configure --prefix=${PY_HOME} --enable-shared LDFLAGS="-Wl,-rpath ${PY_HOME}/lib" && \
    make -j "$(nproc)" && \
    make altinstall && \
    rm -rf /tmp/*

FROM ${BASE} AS official

ARG VERSION

COPY --from=builder /usr/local/python${VERSION} /usr/local/python${VERSION}

RUN VERSION_SHORT=$(echo "${VERSION}" | cut -d. -f1,2) && \
    VERSION_MAJOR=$(echo "${VERSION}" | cut -d. -f1) && \
    PY_HOME=/usr/local/python${VERSION} && \
    ln -sf ${PY_HOME}/bin/python${VERSION_SHORT} ${PY_HOME}/bin/python${VERSION_MAJOR} && \
    ln -sf ${PY_HOME}/bin/pip${VERSION_SHORT} ${PY_HOME}/bin/pip${VERSION_MAJOR} && \
    ln -sf ${PY_HOME}/bin/python${VERSION_MAJOR} ${PY_HOME}/bin/python && \
    ln -sf ${PY_HOME}/bin/pip${VERSION_MAJOR} ${PY_HOME}/bin/pip

RUN echo "${VERSION}" > /test.txt

ENV PATH=/usr/local/python${VERSION}/bin:${PATH}