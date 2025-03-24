#!/bin/bash

# Configuration with date-based paths
EXECUTION_TIME=$(date +%s)
NPM_ROOT_DIR="/var/run/npm"
NPM_JSON_FILE="$NPM_ROOT_DIR/result.json"
NPM_CENTRAL_URL="https://www.npmjs.com/package"

if [ $# -eq 0 ]; then
    echo "No packages specified. Nothing to do."
    exit 0
fi

# Initialize files with execution info
mkdir -p "$NPM_ROOT_DIR"
cat > "$NPM_JSON_FILE" <<EOF
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
    local log="$NPM_ROOT_DIR/${pkg}.log"
    npm install --no-fund --no-audit --save-exact "$pkg" >> "$log" 2>&1
    local status=$?

    local version="\"\""
    local url="\"\""
    if [ $status -eq 0 ]; then
        version="$(npm list --depth=0 --json | jq -r ".dependencies.\"${pkg}\".version")"
        url="\"$NPM_CENTRAL_URL/$pkg\""
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
      "log_file": "$log",
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
cat > "$NPM_JSON_FILE" <<EOF
{
  "startTime": $EXECUTION_TIME,
  "input": "$@",
  "packages": [
$json_packages
  ],
  "endTime": $(date +%s)
}
EOF
