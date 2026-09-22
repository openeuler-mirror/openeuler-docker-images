#!/bin/bash

# SPDX-FileCopyrightText: 2025 Jean-Christophe Fillion-Robin <jcfr@kitware.com>
# SPDX-License-Identifier: Apache-2.0

set -eo pipefail

script_dir=$(cd $(dirname $0) || exit 1; pwd)

err() { echo -e >&2 ERROR: $@\\n; }
die() { err $@; exit 1; }

#-----------------------------------------------------------------------------
if command -v hwloc-ls >/dev/null 2>&1; then
  echo "Binary 'hwloc-ls' is available."
else
  echo "Binary 'hwloc-ls' is not available. Considering running 'sudo apt-get install hwloc libhwloc-dev'\nSee https://uxlfoundation.github.io/oneTBB/GSG/next_steps.html#check-hwloc-on-the-system"
fi

#-----------------------------------------------------------------------------
build_type=Release

source_dir=$script_dir/tbb
build_dir=$script_dir/tbb-$build_type
install_dir=$script_dir/tbb-install

if [[ ! -d $source_dir ]]; then
  git clone https://github.com/uxlfoundation/oneTBB.git $source_dir
fi

echo "source_dir [$source_dir]"
echo "build_dir  [$build_dir]"

NUMBER_OF_PHYSICAL_CORES=$(grep -c ^processor /proc/cpuinfo)
echo "Found $NUMBER_OF_PHYSICAL_CORES CPU cores"

cmake \
  -DCMAKE_BUILD_TYPE:STRING=$build_type \
  -DCMAKE_INSTALL_PREFIX:PATH=$install_dir \
  -DTBB_TEST:BOOL=OFF \
  -S $source_dir \
  -B $build_dir

cmake \
  --build $build_dir --target install \
  --parallel $NUMBER_OF_PHYSICAL_CORES