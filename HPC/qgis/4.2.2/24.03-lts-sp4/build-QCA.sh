#!/bin/bash

# SPDX-License-Identifier: Apache-2.0

set -eo pipefail

# openEuler only provides QCA for Qt5. QGIS uses QCA (QtCrypto) for its
# authentication framework, including the QtCrypto header which is included
# unconditionally, so build a Qt6 QCA with the OpenSSL plugin from source.
QCA_TAG=v2.3.9

cd /opt

if [ ! -d qca ]; then
  git clone --depth 1 --branch "${QCA_TAG}" https://github.com/KDE/qca.git qca
fi

cd qca
rm -rf build

cmake \
  -S . \
  -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DQT6=ON \
  -DBUILD_TESTS=OFF \
  -DBUILD_TOOLS=OFF \
  -DBUILD_PLUGINS=ossl \
  -DQCA_FEATURE_INSTALL_DIR=/usr/lib64/qt6/mkspecs/features

cmake --build build --parallel "$(nproc)"
cmake --install build

# QCA installs its libraries into /usr/lib, refresh the loader cache so that
# build-time tools (e.g. QGIS crssync) can resolve libqca-qt6.so.
ldconfig
