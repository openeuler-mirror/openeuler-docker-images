wait_for_port() {
    local port=$1 timeout=${2:-30}
    for _ in $(seq 1 "$timeout"); do
        if ss -tlnp 2>/dev/null | grep -q ":$port "; then return 0; fi
        sleep 1
    done; return 1
}
