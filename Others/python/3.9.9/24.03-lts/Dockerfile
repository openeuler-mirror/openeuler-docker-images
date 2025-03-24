FROM openeuler/openeuler:24.03-lts AS py-installer

ARG PY_VERSION=3.9
ARG PY_MAJOR_VERSION=3
ARG PY_LATEST_VERSION=3.9.9
ARG PY_HOME="/usr/local/python${PY_VERSION}"
ARG PY_INSTALLER_TGZ="Python-${PY_LATEST_VERSION}.tgz"
ARG PY_INSTALLER_DIR="Python-${PY_LATEST_VERSION}"
ARG PY_INSTALLER_URL="https://repo.huaweicloud.com/python/${PY_LATEST_VERSION}/${PY_INSTALLER_TGZ}"

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
        systemtap-sdt-devel \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /tmp/*

RUN curl -fsSL -o "/tmp/${PY_INSTALLER_TGZ}" "${PY_INSTALLER_URL}" && \
    tar -xf /tmp/${PY_INSTALLER_TGZ} -C /tmp && \
    cd /tmp/${PY_INSTALLER_DIR} && \
    mkdir -p /${PY_HOME}/lib && \
    ./configure --prefix=${PY_HOME} --enable-shared LDFLAGS="-Wl,-rpath ${PY_HOME}/lib" && \
    make -j "$(nproc)" && \
    make altinstall


RUN rm -rf /tmp/${PY_INSTALLER_TGZ} /tmp/${PY_INSTALLER_DIR}

FROM openeuler/openeuler:24.03-lts AS official

ARG PY_VERSION=3.9
ARG PY_MAJOR_VERSION=3
ARG PY_HOME="/usr/local/python${PY_VERSION}"

COPY --from=py-installer /usr/local/python${PY_VERSION} /usr/local/python${PY_VERSION}

RUN ln -sf ${PY_HOME}/bin/python${PY_VERSION} /usr/bin/python${PY_VERSION} && \
    ln -sf ${PY_HOME}/bin/pip${PY_VERSION} /usr/bin/pip${PY_VERSION} && \
    ln -sf /usr/bin/python${PY_VERSION} /usr/bin/python${PY_MAJOR_VERSION} && \
    ln -sf /usr/bin/pip${PY_VERSION} /usr/bin/pip${PY_MAJOR_VERSION} && \
    ln -sf /usr/bin/python${PY_MAJOR_VERSION} /usr/bin/python && \
    ln -sf /usr/bin/pip${PY_MAJOR_VERSION} /usr/bin/pip

