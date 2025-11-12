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