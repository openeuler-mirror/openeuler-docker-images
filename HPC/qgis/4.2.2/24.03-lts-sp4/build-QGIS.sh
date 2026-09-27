#!/bin/bash

# SPDX-License-Identifier: Apache-2.0

set -eo pipefail

branch=$1
patch_file=$2

source_dir=/opt/QGIS
build_dir=/opt/QGIS-build

if [ ! -d "$source_dir" ]; then
  git clone --depth 1 --branch "$branch" https://github.com/qgis/QGIS.git "$source_dir"
fi

# openEuler 24.03-LTS-SP4 ships Qt 6.5 and GEOS 3.9. Apply the compatibility
# patch for the Qt 6.6-only QSemaphore::tryAcquire(QDeadlineTimer) overload and
# the GEOS < 3.11 concaveHullOfPolygons stub.
if [[ -n "$patch_file" && -f "$patch_file" ]]; then
  echo "Applying patch [$patch_file]"
  cd "$source_dir"
  git apply "$patch_file"
  cd -
fi

# QGIS is built without the Python bindings (PyQt6/SIP are not packaged on
# openEuler) and without the optional providers that have no packaged
# dependencies (PDAL, Draco, SFCGAL, GeographicLib). libspatialindex and Qwt
# are built from the copies bundled with QGIS.
cmake \
  -S "$source_dir" \
  -B "$build_dir" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DWITH_BINDINGS=OFF \
  -DWITH_PYTHON=OFF \
  -DWITH_AUTH=ON \
  -DWITH_PDAL=OFF \
  -DWITH_DRACO=OFF \
  -DWITH_EPT=ON \
  -DWITH_COPC=ON \
  -DWITH_SFCGAL=OFF \
  -DWITH_GEOGRAPHICLIB=OFF \
  -DWITH_INTERNAL_SPATIALINDEX=ON \
  -DWITH_INTERNAL_QWT=ON \
  -DWITH_QSPATIALITE=OFF \
  -DWITH_SERVER=OFF \
  -DWITH_3D=ON \
  -DWITH_DESKTOP=ON \
  -DWITH_GUI=ON \
  -DWITH_QTWEBENGINE=ON

cmake --build "$build_dir" --parallel "$(nproc)"
cmake --install "$build_dir"
