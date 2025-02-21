ARG BASE=openeuler/openeuler:24.03-lts

FROM ${BASE} AS builder
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true
ARG TARGETARCH
ARG BUILDARCH
ARG LIBPRELUDE_VERSION=5.2.0-11

RUN dnf -y install \
    autoconf \
    automake \
    cargo \
    diffutils \
    dpdk-devel \
    elfutils-libelf-devel \
    file \
    file-devel \
    gcc \
    gcc-c++ \
    git \
    hiredis-devel \
    jansson-devel \
    jq \
    kmod \
    lua-devel \
    libbpf-devel \
    libtool \
    libyaml-devel \
    libnfnetlink-devel \
    libnetfilter_queue-devel \
    libnet-devel \
    libcap-ng-devel \
    libevent-devel \
    libmaxminddb-devel \
    libpcap-devel \
    libtool \
    lz4-devel \
    make \
    nspr-devel \
    nss-devel \
    nss-softokn-devel \
    numactl-devel \
    pcre2-devel \
    pkgconfig \
    python3-devel \
    python3-yaml \
    rust \
    wget \
    which \
    zlib-devel

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    wget https://repo.oepkgs.net/openeuler/rpm/openEuler-24.03-LTS/extras/${BUILDARCH}/Packages/l/libprelude-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm && \
    yum install -y libprelude-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm && \
    rm -f libprelude-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    wget https://repo.oepkgs.net/openeuler/rpm/openEuler-24.03-LTS/extras/${BUILDARCH}/Packages/l/libprelude-devel-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm && \
    yum install -y libprelude-devel-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm && \
    rm -f libprelude-devel-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm

RUN cargo install cbindgen

ENV PATH=/root/.cargo/bin:$PATH

RUN if [ "$(arch)" = "x86_64" ]; then \
    dnf -y install hyperscan; \
fi

ARG VERSION=7.0.8

WORKDIR /src

RUN curl -OL https://www.openinfosecfoundation.org/download/suricata-${VERSION}.tar.gz; \
    tar zxf suricata-${VERSION}.tar.gz

WORKDIR /src/suricata-${VERSION}

RUN ./configure \
    --prefix=/usr \
    --disable-shared \
    --disable-gccmarch-native \
    --enable-lua \
    --enable-nfqueue \
    --enable-hiredis \
    --enable-geoip \
    --enable-ebpf \
    --enable-dpdk

RUN make && make install install-conf DESTDIR=/fakeroot


FROM ${BASE} AS runner
ARG TARGETARCH
ARG BUILDARCH
ARG LIBPRELUDE_VERSION=5.2.0-11

RUN dnf -y update && \
    dnf -y install \
    cronie \
    dpdk \
    elfutils-libelf \
    file \
    findutils \
    hiredis \
    iproute \
    jansson \
    kmod \
    lua-libs \
    libbpf \
    libyaml \
    libnfnetlink \
    libnetfilter_queue \
    libnet \
    libcap-ng \
    libevent \
    libmaxminddb \
    libpcap \
    logrotate \
    lz4 \
    net-tools \
    nss \
    nss-softokn \
    numactl \
    pcre2 \
    procps-ng \
    python3 \
    python3-yaml \
    tcpdump \
    wget \
    which \
    zlib && \
    if [ "$(arch)" = "x86_64" ]; then dnf -y install hyperscan; fi && \
    dnf clean all && \
    find /etc/logrotate.d -type f -not -name suricata -delete

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    wget https://repo.oepkgs.net/openeuler/rpm/openEuler-24.03-LTS/extras/${BUILDARCH}/Packages/l/libprelude-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm && \
    yum install -y libprelude-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm && \
    rm -f libprelude-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    wget https://repo.oepkgs.net/openeuler/rpm/openEuler-24.03-LTS/extras/${BUILDARCH}/Packages/l/libprelude-devel-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm && \
    yum install -y libprelude-devel-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm && \
    rm -f libprelude-devel-${LIBPRELUDE_VERSION}.${BUILDARCH}.rpm

COPY --from=builder /fakeroot /

# Create the directories that didn't get copied from the previous stage.
RUN mkdir -p /var/log/suricata /var/run/suricata /var/lib/suricata

COPY /update.yaml /etc/suricata/update.yaml
COPY /suricata.logrotate /etc/logrotate.d/suricata

RUN suricata-update update-sources && \
    suricata-update enable-source oisf/trafficid && \
    suricata-update --no-test --no-reload && \
    /usr/bin/suricata -V

RUN useradd --system --create-home suricata && \
    chown -R suricata:suricata /etc/suricata && \
    chown -R suricata:suricata /var/log/suricata && \
    chown -R suricata:suricata /var/lib/suricata && \
    chown -R suricata:suricata /var/run/suricata && \
    chown -R suricata:suricata /usr/etc/suricata && \
    chown -R suricata:suricata /usr/var/log/suricata && \
    chown -R suricata:suricata /usr/var/lib/suricata && \
    chown -R suricata:suricata /usr/var/run/suricata && \
    cp -a /etc/suricata /etc/suricata.dist && \
    chmod 600 /etc/logrotate.d/suricata

VOLUME /var/log/suricata
VOLUME /var/lib/suricata
VOLUME /var/run/suricata
VOLUME /etc/suricata

COPY --chown=suricata:suricata /entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
RUN /usr/bin/suricata --build-info