#!/bin/bash

# Configuration with date-based paths
EXECUTION_TIME=$(date +%s)
PYPI_ROOT_DIR="/var/run/pypi"
PYPI_JSON_FILE="$PYPI_ROOT_DIR/result.json"
PYPI_CENTRAL_URL="https://pypi.org/project"

if [ $# -eq 0 ]; then
    echo "No packages specified. Nothing to do."
    exit 0
fi

# Initialize files with execution info
mkdir -p "$PYPI_ROOT_DIR"
cat > "$PYPI_JSON_FILE" <<EOF
{
  "startTime": $EXECUTION_TIME,
  "input": "$@",
  "packages": []
}
EOF

# Package installation function
install_package() {
    local start_time=$(date +%s)
    local pkg=$1
    local log="$PYPI_ROOT_DIR/${pkg}.log"
    pip install --no-cache-dir "$pkg" >> "$log" 2>&1
    local status=$?

    local version="\"\""
    local url="\"\""
    if [ $status -eq 0 ]; then
        version="$(pip show "$pkg" | grep "Version:" | awk '{print $2}')"
        url="\"$PYPI_CENTRAL_URL/$pkg/\""
    fi

    local end_time=$(date +%s)
    local duration=$(( end_time - start_time ))

    # Build package JSON entry
    json_packages+="$(cat <<EOF
    {
      "package": "$pkg",
      "version": $version,
      "status": "$([ $status -eq 0 ] && echo "success" || echo "failed")",
      "duration": $duration,
      "log": "$log",
      "url": $url
    },
EOF
)"
}

# Process all packages
for pkg in "$@"; do
    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
    install_package "$pkg"
done

# Write final JSON file
json_packages=${json_packages%,}
cat > "$PYPI_JSON_FILE" <<EOF
{
  "startTime": $EXECUTION_TIME,
  "input": "$@",
  "packages": [
$json_packages
  ],
  "endTime": $(date +%s)
}
EOF
