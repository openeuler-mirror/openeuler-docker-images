#!/bin/bash

# SPDX-FileCopyrightText: 2025 Jean-Christophe Fillion-Robin <jcfr@kitware.com>
# SPDX-License-Identifier: Apache-2.0

set -eo pipefail

script_dir=$(cd $(dirname $0) || exit 1; pwd)

err() { echo -e >&2 ERROR: $@\\n; }
die() { err $@; exit 1; }

#-----------------------------------------------------------------------------
build_type=Release

source_dir=$script_dir/CTKAppLauncher
build_dir=$script_dir/CTKAppLauncher-$build_type
install_dir=$script_dir/CTKAppLauncher-install

if [[ ! -d $source_dir ]]; then
  git clone https://github.com/commontk/AppLauncher $source_dir
fi

echo "source_dir [$source_dir]"
echo "build_dir  [$build_dir]"

NUMBER_OF_PHYSICAL_CORES=$(grep -c ^processor /proc/cpuinfo)
echo "Found $NUMBER_OF_PHYSICAL_CORES CPU cores"

cmake \
  -DCMAKE_BUILD_TYPE:STRING=$build_type \
  -DCTKAppLauncher_QT_VERSION:STRING=5 \
  -DBUILD_TESTING:BOOL=OFF \
  -DCMAKE_INSTALL_PREFIX:PATH=$install_dir \
  -S $source_dir \
  -B $build_dir

cmake \
  --build $build_dir --target install \
  --parallel $NUMBER_OF_PHYSICAL_CORES