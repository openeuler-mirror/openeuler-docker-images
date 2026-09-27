#!/bin/bash

# SPDX-FileCopyrightText: 2025 Jean-Christophe Fillion-Robin <jcfr@kitware.com>
# SPDX-License-Identifier: Apache-2.0

set -eo pipefail

branch=$1
patch_file=$2
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
  git clone -b $branch https://github.com/Slicer/Slicer $source_dir
fi

echo "source_dir [$source_dir]"
echo "build_dir  [$build_dir]"

if [[ -n "$patch_file" && -f "$patch_file" ]]; then
  echo "Applying patch [$patch_file]"
  cd $source_dir
  git apply "$patch_file"
  cd -
fi

NUMBER_OF_PHYSICAL_CORES=$(grep -c ^processor /proc/cpuinfo)
echo "Found $NUMBER_OF_PHYSICAL_CORES CPU cores"

# Several translation units (e.g. Slicer's Libs/vtkITK and VTK itself) are very
# memory-hungry. Building them with full parallelism exhausts memory and the
# compiler (cc1plus) is OOM-killed. Cap the number of parallel jobs using the
# memory actually available to the build container and never exceed the CPU
# count.
#
# /proc/meminfo reports the host MemTotal, which can be far larger than the
# cgroup limit enforced on the container, so it must not be trusted inside a
# build container. Prefer the cgroup v2 (memory.max) or cgroup v1
# (memory/memory.limit_in_bytes) limit and only fall back to /proc/meminfo when
# no finite limit is set.
detect_memory_limit_mb() {
  local limit
  for f in /sys/fs/cgroup/memory.max \
           /sys/fs/cgroup/memory/memory.limit_in_bytes; do
    if [ -r "$f" ]; then
      limit=$(cat "$f")
      case "$limit" in
        ''|max|*[!0-9]*) continue ;;
      esac
      # Values at/near the 64-bit maximum mean "unlimited".
      if [ "$limit" -lt 9223372036854771712 ]; then
        echo $(( limit / 1048576 ))
        return
      fi
    fi
  done
  awk '/^MemTotal:/ {printf "%d", $2 / 1024}' /proc/meminfo
}

TOTAL_MEMORY_MB=$(detect_memory_limit_mb)
echo "Detected available memory: ${TOTAL_MEMORY_MB} MiB"

# Reserve 8 GiB per compiler job: single cc1plus processes compiling the
# VTK/vtkITK template-heavy translation units regularly exceed 4 GiB at peak,
# so the previous ~4 GiB estimate was too optimistic.
MEMORY_PER_JOB_MB=8192
PARALLEL_JOBS=$(( TOTAL_MEMORY_MB / MEMORY_PER_JOB_MB ))
if [ "$PARALLEL_JOBS" -gt "$NUMBER_OF_PHYSICAL_CORES" ]; then
  PARALLEL_JOBS=$NUMBER_OF_PHYSICAL_CORES
fi
if [ "$PARALLEL_JOBS" -lt 1 ]; then
  PARALLEL_JOBS=1
fi
echo "Using $PARALLEL_JOBS parallel job(s)"

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

# Build the VTK external project first with limited parallelism: its large
# template-instantiation translation units (e.g. vtkArrayBulkInstantiate_*.cxx)
# are especially memory-hungry.
cmake \
  --build $build_dir \
  --target VTK \
  --parallel 2

# Build the rest of Slicer (including the memory-hungry inner Libs/vtkITK
# targets, e.g. vtkITKGrowCut.cxx) with the memory-capped parallelism computed
# above. The inner build is not available as a standalone target in this
# superbuild directory, so it must be built through the default target.
cmake \
  --build $build_dir \
  --parallel $PARALLEL_JOBS