ARG BASE=openeuler/openeuler:24.03-lts-sp3
ARG FDB_VERSION=7.3.77

FROM foundationdb/foundationdb:${FDB_VERSION} AS fdb

FROM ${BASE}

ARG VERSION=22fca04
ARG FDB_VERSION=7.3.77

RUN yum -y install --setopt=timeout=60 cmake meson ninja-build libuv-devel lz4-devel xz-devel double-conversion-devel libdwarf-devel libunwind-devel libaio-devel gflags-devel glog-devel gtest-devel gmock-devel clang lld gperftools-devel libevent-devel git wget gcc gcc-c++ make fuse3-devel openssl-devel boost-devel && \
    yum clean all

RUN bash -c "curl --proto '=https' --tlsv1.2 --retry 5 --retry-delay 3 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.85.0"

ENV PATH="/root/.cargo/bin:${PATH}"

RUN wget --retry-connrefused --tries=5 https://github.com/libfuse/libfuse/releases/download/fuse-3.16.1/fuse-3.16.1.tar.gz && \
    tar xzf fuse-3.16.1.tar.gz && \
    cd fuse-3.16.1 && \
    meson setup build && \
    meson compile -C build && \
    meson install -C build 2>/dev/null || true && \
    cd / && rm -rf fuse-3.16.1 fuse-3.16.1.tar.gz

COPY --from=fdb /usr/bin/fdbcli /usr/bin/fdbcli
COPY --from=fdb /usr/lib/libfdb_c.so /usr/lib64/libfdb_c.so

RUN git config --global http.postBuffer 524288000 && \
    git clone --recurse-submodules https://github.com/deepseek-ai/3fs /tmp/3fs && \
    git -C /tmp/3fs checkout ${VERSION} && \
    git -C /tmp/3fs submodule update --init --recursive && \
    bash -c "cd /tmp/3fs && ./patches/apply.sh" && \
    cmake -S /tmp/3fs -B /tmp/3fs/build \
        -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
        -DCMAKE_C_COMPILER=/usr/bin/clang \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
        -DSHUFFLE_METHOD=g++11 && \
    cmake --build /tmp/3fs/build -j $(nproc) && \
    mkdir -p /opt/3fs/bin /opt/3fs/etc /var/log/3fs && \
    cp /tmp/3fs/build/bin/* /opt/3fs/bin/ && \
    cp /tmp/3fs/deploy/systemd/*.service /usr/lib/systemd/system/ 2>/dev/null || true && \
    rm -rf /tmp/3fs

RUN yum -y remove wget gcc make && \
    yum clean all

RUN yum -y install fuse3-libs openssl-libs lz4 xz-libs double-conversion libdwarf libunwind libaio gflags glog gperftools boost-filesystem boost-system boost-program-options libuv && \
    yum clean all

ENV LD_LIBRARY_PATH=/opt/3fs/lib:/usr/local/lib

EXPOSE 8000 10000

WORKDIR /opt/3fs
VOLUME ["/opt/3fs/etc", "/var/log/3fs", "/opt/3fs/data"]

ENTRYPOINT ["/opt/3fs/bin/mgmtd_main"]
CMD ["--cfg", "/opt/3fs/etc/mgmtd_main_launcher.toml"]
