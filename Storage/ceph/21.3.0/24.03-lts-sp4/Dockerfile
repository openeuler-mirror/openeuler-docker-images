ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE as builder
ARG VERSION=21.3.0

RUN dnf update -y \
    && dnf install -y \
        git gcc-c++ ninja-build cmake python3-sphinx \
        libibverbs libibverbs-devel rdma-core rdma-core-devel \
        systemd-devel libblkid-devel keyutils-libs-devel \
        openldap-devel cryptsetup-devel python3-pip \
        autoconf automake libtool ocaml ocaml-devel \
        libatomic librdkafka librdkafka-devel \
        gnutls-devel libxml2-devel glib2-devel \
        libev-devel fuse3-devel bash-completion \
        ocaml-findlib python3-devel golang rust cargo \
        libaio libaio-devel sqlite sqlite-devel \
        snappy snappy-devel lz4 lz4-devel curl-devel \
        expat-devel liboath liboath-devel lttng-ust lttng-ust-devel \
        babeltrace libbabeltrace-devel libicu libicu-devel \
        thrift-devel libcap-devel lua-devel \
        libcap-ng libcap-ng-devel gperf lmdb lmdb-devel \
        librabbitmq librabbitmq-devel python3-pyyaml \
        numactl-devel make python nasm \
        protobuf-devel protobuf-compiler grpc-devel grpc-plugins jq \
        python3-wheel \
    && dnf clean all

RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install cython prettytable

WORKDIR /opt

RUN git clone https://gitlab.com/nbdkit/libnbd.git \
    && cd libnbd  \
    && autoreconf -fi \
    && ./configure \
    && make -j$(nproc) \
    && make install \
    && cd ..  \
    && rm -rf libnbd

RUN echo 'nodeenv<1.10' > /opt/pip-constraints.txt \
    && export PIP_CONSTRAINT=/opt/pip-constraints.txt \
    && git clone -b v${VERSION} --recursive --depth 1 https://github.com/ceph/ceph.git \
    && cd ceph \
    && sed -i 's/set(_HAVE_ABSEIL OFF)/set(_HAVE_ABSEIL ON)/' src/CMakeLists.txt \
    && ./do_cmake.sh -DCMAKE_BUILD_TYPE=Release -DWITH_TESTS=OFF \
    && cd build \
    && ninja -j$(nproc) \
    && ninja install

ENV LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH

COPY --chmod=755 <<'ENTRYPOINT_EOF' /opt/ceph/entrypoint.sh
#!/bin/bash
set -e

CEPH_SRC_DIR=$(pwd)
BUILD_DIR="$CEPH_SRC_DIR/build"
CLUSTER_DIR="$CEPH_SRC_DIR/ceph-cluster"
ETC_DIR="$CLUSTER_DIR/etc"
LIB_DIR="$CLUSTER_DIR/lib"
LOG_DIR="$CLUSTER_DIR/log"

MON_NAME="mon1"
MON_IP="127.0.0.1"
FSID=$(uuidgen)

echo "[*] Using FSID: $FSID"
echo "[*] Working directory: $CEPH_SRC_DIR"

echo "[*] Cleaning up previous state..."
pkill -9 ceph-mon || true
rm -rf "$CLUSTER_DIR"
rm -f /var/run/ceph/ceph-mon.$MON_NAME.asok

mkdir -p "$ETC_DIR" "$LIB_DIR/mon/$MON_NAME" "$LOG_DIR"

cat > "$ETC_DIR/ceph.conf" <<EOF
[global]
fsid = $FSID
mon_initial_members = $MON_NAME
mon_host = $MON_IP
auth_cluster_required = cephx
auth_service_required = cephx
auth_client_required = cephx
log_to_file = true
log_file = $LOG_DIR/ceph.log
log_to_stderr = false
run_dir = /var/run/ceph
mon_data = $LIB_DIR/mon/\$id
osd_data = $LIB_DIR/osd/\$id
# Critical fix: Specify keyring paths
keyring = $ETC_DIR/ceph.client.admin.keyring
mon_keyring = $ETC_DIR/ceph.mon.keyring
EOF

echo "[*] Generating keys..."
"$BUILD_DIR/bin/ceph-authtool" --create-keyring "$ETC_DIR/ceph.mon.keyring" --gen-key -n mon. --cap mon 'allow *'
"$BUILD_DIR/bin/ceph-authtool" --create-keyring "$ETC_DIR/ceph.client.admin.keyring" --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mgr 'allow *'
"$BUILD_DIR/bin/ceph-authtool" "$ETC_DIR/ceph.mon.keyring" --import-keyring "$ETC_DIR/ceph.client.admin.keyring"

echo "[*] Generating monmap..."
"$BUILD_DIR/bin/monmaptool" --clobber --create --add "$MON_NAME" "$MON_IP" --fsid "$FSID" "$ETC_DIR/monmap"

echo "[*] Initializing monitor..."
"$BUILD_DIR/bin/ceph-mon" --mkfs -i "$MON_NAME" --monmap "$ETC_DIR/monmap" --keyring "$ETC_DIR/ceph.mon.keyring" --conf "$ETC_DIR/ceph.conf"

echo "[*] Starting monitor..."
"$BUILD_DIR/bin/ceph-mon" -i "$MON_NAME" \
    --conf "$ETC_DIR/ceph.conf" \
    --keyring "$ETC_DIR/ceph.mon.keyring" &

sleep 3

if ! pgrep -f "ceph-mon.*$MON_NAME" >/dev/null; then
    echo "[!] Error: ceph-mon process failed to start! Check logs: $LOG_DIR/ceph.log"
    exit 1
fi

echo "[*] Cluster status:"
"$BUILD_DIR/bin/ceph" -s \
    --conf "$ETC_DIR/ceph.conf" \
    --keyring "$ETC_DIR/ceph.client.admin.keyring"

echo "[+] Successfully started single-node Ceph cluster!"
ENTRYPOINT_EOF

WORKDIR /opt/ceph

ENTRYPOINT [ "./entrypoint.sh" ]