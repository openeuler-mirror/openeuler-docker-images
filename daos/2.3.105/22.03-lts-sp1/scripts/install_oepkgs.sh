#!/bin/bash

set -euo pipefail

build_arch=$1

if [[ "$build_arch" != "aarch64" && "$build_arch" != "x86_64" ]]; then
  echo "Error: Invalid architecture '$build_arch'. Only 'aarch64' and 'x86_64' are supported."
  exit 1
fi

build_dir=$2
if [ ! -d "$build_dir" ]; then
  echo "Error: Build directory: $build_dir is not a valid directory."
  exit 1
fi

# On the x86_64 architecture, Lmod and pmdk are not released in openEuler-22.03-LTS-SP1.
BASE_URL="https://repo.oepkgs.net/openeuler/rpm/openEuler-22.03-LTS-SP1/extras/${build_arch}/Packages"

# Packages to be downloaded and installed from the oepkgs repository.
PACKAGES=(
  "libfabric 1.18.1-1"
  "libfabric-devel 1.18.1-1"
  "mercury 2.3.1~rc1-1"
  "mercury-devel 2.3.1~rc1-1"
  "dpdk-daos 21.11.2-2"
  "dpdk-daos-devel 21.11.2-2"
  "ucx 1.12.0-2"
  "ucx-devel 1.12.0-2"
  "argobots 1.1-3"
  "argobots-devel 1.1-3"
  "libisa-l_crypto 2.24.0-1"
  "libisa-l_crypto-devel 2.24.0-1"
  "raft 0.9.1-1"
  "raft-devel 0.9.1-1"
)

if [[ "$build_arch" == "aarch64" ]]; then
  PACKAGES+=(
    "Lmod 8.4.1-1"
    "pmdk 1.12.1-1"
  )
fi

cd  $build_dir

# Function to download and install packages
download_and_install() {
  local package_name=$1
  local version=$2
  local first_letter=$(echo "${package_name:0:1}" | tr '[:upper:]' '[:lower:]')
  local rpm_name="${package_name}-${version}.${build_arch}.rpm"
  local url="${BASE_URL}/${first_letter}/${rpm_name}"

  echo "Downloading: $url"
  wget "$url" -q --show-progress

  if [[ $? -eq 0 ]]; then
    echo "Installing: $rpm_name"
    dnf -y install "$rpm_name"
  else
    echo "Download failed: $url"
    exit 1
  fi
}

# Iterate through the package list and download/install them
for pkg in "${PACKAGES[@]}"; do
  package_name=$(echo "$pkg" | awk '{print $1}')
  version=$(echo "$pkg" | awk '{print $2}')
  download_and_install "$package_name" "$version"
done

if [[ "$build_arch" == "x86_64" ]]; then
  dnf install -y `ls | grep Lmod`
  dnf install -y `ls | grep pmdk`
fi