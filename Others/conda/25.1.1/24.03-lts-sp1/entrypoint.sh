#!/bin/bash

# Configuration with date-based paths
EXECUTION_TIME=$(date +%s)
CONDA_ROOT_DIR="/var/run/conda"
CONDA_JSON_FILE="$CONDA_ROOT_DIR/result.json"

if [ $# -eq 0 ]; then
    echo "No packages specified. Nothing to do."
    exit 0
fi

# Initialize conda and configure Conda channels
source /usr/local/miniconda/etc/profile.d/conda.sh
if [ ! -f ~/.condarc ]; then
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/ && \
    conda config --set channel_priority strict
fi

# Initialize files with execution info
mkdir -p "$CONDA_ROOT_DIR"
cat > "$CONDA_JSON_FILE" <<EOF
{
  "startTime": $EXECUTION_TIME,
  "input": "$@",
  "packages": []
}
EOF

# get actual channel for installed package
get_package_channel() {
    local pkg=$1
    local info=$(conda list --json | jq -r ".[] | select(.name == \"$pkg\") | .channel")

    if [ -z "$info" ]; then
        echo "\"\""
    else
        # 处理多种可能的channel格式
        case "$info" in
            *"conda.anaconda.org"*)
                echo "$info" | sed -e 's|https://conda.anaconda.org/||' -e 's|/.*||'
                ;;
            *"repo.anaconda.com"*)
                echo "$info" | sed -e 's|https://repo.anaconda.com/pkgs/||' -e 's|/.*||'
                ;;
            *"anaconda/cloud"*)
                echo "$info" | sed -e 's|anaconda/cloud/||' -e 's|/.*||'
                ;;
            *)
                echo "\"\""
                ;;
        esac
    fi
}

# Package installation function
install_package() {
    local start_time=$(date +%s)
    local pkg=$1
    local log="$CONDA_ROOT_DIR/${pkg}.log"
    echo "Installing $pkg..." >> "$log"
    conda install -y "$pkg" >> "$log" 2>&1
    local status=$?

    local version="\"\""
    local channel="\"\""
    local url="\"\""

    if [ $status -eq 0 ]; then
        version="$(conda list | awk -v pkg="$pkg" '$1 == pkg {print $2}')"
        channel="$(get_package_channel "$pkg")"
        url="\"https://anaconda.org/$channel/$pkg\""
    fi

    local end_time=$(date +%s)
    local duration=$(( end_time - start_time ))

    # Build package JSON entry
    json_packages+="$(cat <<EOF
    {
      "package": "$pkg",
      "channel": $channel,
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
cat > "$CONDA_JSON_FILE" <<EOF
{
  "startTime": $EXECUTION_TIME,
  "input": "$@",
  "packages": [
$json_packages
  ],
  "endTime": $(date +%s)
}
EOF
