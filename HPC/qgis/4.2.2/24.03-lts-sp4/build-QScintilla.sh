#!/bin/bash

# SPDX-License-Identifier: Apache-2.0

set -eo pipefail

# openEuler does not ship a Qt6 build of QScintilla2, but QGIS requires it for
# its GUI library (find_package(QScintilla REQUIRED)). Build the C++ library
# from the upstream source distribution and install it into the Qt6 prefix.
QSCINTILLA_VERSION=2.14.1
QSCINTILLA_URL="https://files.pythonhosted.org/packages/a9/f6/a7aa4b495dcee4c521b87205de9363fb62ee5fdc8eab91d4ddb97257c85b/QScintilla-${QSCINTILLA_VERSION}.tar.gz"

cd /opt

if [ ! -f "QScintilla-${QSCINTILLA_VERSION}.tar.gz" ]; then
  wget -q -O "QScintilla-${QSCINTILLA_VERSION}.tar.gz" "${QSCINTILLA_URL}"
fi

tar xzf "QScintilla-${QSCINTILLA_VERSION}.tar.gz"

cd "QScintilla-${QSCINTILLA_VERSION}/src"

qmake6 qscintilla.pro
make -j"$(nproc)"
make install
