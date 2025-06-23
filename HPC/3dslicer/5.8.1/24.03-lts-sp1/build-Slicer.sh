#!/bin/bash

# SPDX-FileCopyrightText: 2025 Jean-Christophe Fillion-Robin <jcfr@kitware.com>
# SPDX-License-Identifier: Apache-2.0

set -eo pipefail

branch=$1
zlib_patch=$2
script_dir=$(cd $(dirname $0) || exit 1; pwd)

err() { echo -e >&2 ERROR: $@\\n; }
die() { err $@; exit 1; }

#-----------------------------------------------------------------------------
CTKAppLauncher_DIR=$script_dir/CTKAppLauncher-install
echo "CTKAppLauncher_DIR [$CTKAppLauncher_DIR]"

if [[ ! -d $CTKAppLauncher_DIR ]]; then
  die "CTKAppLauncher_DIR does not exist"
fi

tbb_install_dir=$script_dir/tbb-install

TBB_DIR=$tbb_install_dir/lib64/cmake/TBB
TBB_BIN_DIR=$tbb_install_dir/lib64
TBB_LIB_DIR=$TBB_BIN_DIR

echo "TBB_DIR [$TBB_DIR]"
echo "TBB_BIN_DIR [$TBB_BIN_DIR]"
echo "TBB_LIB_DIR [$TBB_LIB_DIR]"

if [[ ! -d $TBB_DIR ]]; then
  die "TBB_DIR does not exist"
fi
if [[ ! -d $TBB_BIN_DIR ]]; then
  die "TBB_BIN_DIR does not exist"
fi
if [[ ! -d $TBB_LIB_DIR ]]; then
  die "TBB_LIB_DIR does not exist"
fi

#-----------------------------------------------------------------------------
build_type=Release

source_dir=$script_dir/Slicer
build_dir=$script_dir/Slicer-$build_type

if [[ ! -d $source_dir ]]; then
  git -b v$branch clone https://github.com/Slicer/Slicer $source_dir
fi

echo "source_dir [$source_dir]"
echo "build_dir  [$build_dir]"

cd $source_dir
mv $zlib_patch ./zlib.patch
git apply zlib.patch
cd -

NUMBER_OF_PHYSICAL_CORES=$(grep -c ^processor /proc/cpuinfo)
echo "Found $NUMBER_OF_PHYSICAL_CORES CPU cores"

#-----------------------------------------------------------------------------
cmake \
  -DCMAKE_BUILD_TYPE:STRING=$build_type \
  -DSlicer_BUILD_EXTENSIONMANAGER_SUPPORT:BOOL=OFF \
  -DSlicer_USE_SimpleITK:BOOL=OFF \
  -DBUILD_TESTING:BOOL=OFF \
  -DCTKAppLauncher_DIR:PATH=$CTKAppLauncher_DIR \
  -DTBB_DIR:PATH=$TBB_DIR \
  -DTBB_BIN_DIR:PATH=$TBB_BIN_DIR \
  -DTBB_LIB_DIR:PATH=$TBB_LIB_DIR \
  -S $source_dir \
  -B $build_dir

cmake \
  --build $build_dir \
  --parallel $NUMBER_OF_PHYSICAL_CORES
