ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=4.5.6
ARG TARGETARCH
ARG BUILDARCH
ARG JDK_VERSION=11.0.27_6

RUN dnf update -y \
    && dnf install -y git wget make java-11-openjdk-devel mailcap maven \
    unzip openssl bind-utils postgresql-server postgresql postgresql-contrib \
    ovirt-engine-wildfly ovirt-engine-wildfly-overlay python3-daemon \
    python3-dateutil python3-cryptography python3-m2crypto \
    python3-psycopg2 python3-jinja2 python3-libxml2 python3-distro \
    && dnf clean all

WORKDIR /usr/local

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi \
    && cd / \
    && wget https://mirrors.tuna.tsinghua.edu.cn/Adoptium/11/jdk/${BUILDARCH}/linux/OpenJDK11U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && tar -zxvf OpenJDK11U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && rm -f OpenJDK11U-jdk_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz

ENV JAVA_HOME=/jdk-11.0.27+6
ENV PATH=${JAVA_HOME}/bin:$PATH

RUN git clone -b ovirt-engine-${VERSION} --recursive --depth 1 https://github.com/oVirt/ovirt-engine \
    && cd ovirt-engine \
    && make clean install-dev PREFIX="/usr/local/" \
    && cd .. \
    && rm -rf ovirt-engine

CMD ["engine-setup", "--help"]