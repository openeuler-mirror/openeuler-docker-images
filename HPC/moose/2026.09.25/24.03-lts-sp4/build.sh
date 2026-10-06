#!/bin/bash
set -euo pipefail

# Pinned upstream revisions (must match the moose 2025-09-05-release submodules)
PETSC_GIT=95934b0d3930a39ae37491dd05d108b6eb525436
SLEPC_VER=3.23.0
LIBMESH_GIT=8d1b4c43d1ab2283d4702aa86cf040d2ae2ec5c0
METAPHYSICL_GIT=617299e5787d6e5b69fcc436e296075798f72538
TIMPI_GIT=12b75441f7698cf00ad418f491d2616275ad619a
AUTOCONF_SUB_GIT=58a3529cff6ae39754cf4e912c0eee7a3e0e7de5
NETCDF_C_GIT=9328ba17cb53f13a63707547c94f4715243dafdf
POLY2TRI_GIT=529470f1d079c2526576d5ee9ab9e6783ae5758c
NANOFLANN_GIT=92bae2a0f44e3a29e720c751866b1eeb36416baf
WASP_GIT=cf46fbd0d224cc2a70edbc668d3e65d45bec9e16
TRIBITS_GIT=4dba8aad15b170d92f69a41f51a465ca802d886e
TESTFRAMEWORK_GIT=2aafc1d21c5d38d63f9c3943bb81f20138cde05e
MOOSE_TAG=2025-09-05-release

NPROC="$(nproc)"
BUILD=/opt/moose-build
mkdir -p "${BUILD}"
cd "${BUILD}"

echo "==> downloading sources"
curl -fsSL -o petsc.tar.gz             "https://github.com/petsc/petsc/archive/${PETSC_GIT}.tar.gz"
curl -fsSL -o slepc.tar.gz             "https://github.com/slepc/slepc/archive/refs/tags/v${SLEPC_VER}.tar.gz"
curl -fsSL -o libmesh.tar.gz           "https://github.com/libMesh/libmesh/archive/${LIBMESH_GIT}.tar.gz"
curl -fsSL -o metaphysicl.tar.gz       "https://github.com/libMesh/MetaPhysicL/archive/${METAPHYSICL_GIT}.tar.gz"
curl -fsSL -o timpi.tar.gz             "https://github.com/libMesh/TIMPI/archive/${TIMPI_GIT}.tar.gz"
curl -fsSL -o autoconf-submodule.tar.gz "https://github.com/libMesh/autoconf-submodule/archive/${AUTOCONF_SUB_GIT}.tar.gz"
curl -fsSL -o netcdf-c.tar.gz          "https://github.com/Unidata/netcdf-c/archive/${NETCDF_C_GIT}.tar.gz"
curl -fsSL -o poly2tri.tar.gz          "https://github.com/jhasse/poly2tri/archive/${POLY2TRI_GIT}.tar.gz"
curl -fsSL -o nanoflann.tar.gz         "https://github.com/jlblancoc/nanoflann/archive/${NANOFLANN_GIT}.tar.gz"
curl -fsSL -o wasp.tar.gz              "https://github.com/ornl-neams-workbench/wasp/archive/${WASP_GIT}.tar.gz"
curl -fsSL -o tribits.tar.gz           "https://github.com/lefebvre/TriBITS/archive/${TRIBITS_GIT}.tar.gz"
curl -fsSL -o moose.tar.gz             "https://github.com/idaholab/moose/archive/refs/tags/${MOOSE_TAG}.tar.gz"

# testframework: github codeload is unreliable for this repo, use a git checkout
git clone --quiet https://github.com/lefebvre/testframework.git testframework
git -C testframework checkout --quiet "${TESTFRAMEWORK_GIT}"

echo "==> building PETSc ${PETSC_GIT}"
mkdir -p petsc && tar -xzf petsc.tar.gz -C petsc --strip-components=1
cd petsc
export PETSC_DIR="${PWD}"
export PETSC_ARCH=arch-linux-c-opt
python3 ./configure \
  --prefix=/usr/lib64/petsc \
  --with-cc=/usr/bin/mpicc \
  --with-cxx=/usr/bin/mpicxx \
  --with-fc=/usr/bin/mpif90 \
  --with-mpi=1 \
  --with-debugging=0 \
  --with-shared-libraries=1 \
  --with-scalar-type=real \
  --with-64-bit-indices=0 \
  --with-blaslapack-lib=-lopenblas \
  --with-blaslapack-include=/usr/include/openblas \
  --with-ldflags=-Wl,-rpath,/usr/lib64/openmpi/lib \
  --with-hypre=0 --with-metis=0 --with-parmetis=0 \
  --with-mumps=0 --with-suitesparse=0 --with-superlu_dist=0 \
  --with-scalapack=0 --with-fftw=0 --with-hdf5=0 --with-netcdf=0 \
  --with-ptscotch=0 --with-scotch=0 --with-x=0 \
  --with-cuda=0 --with-hip=0 --with-opencl=0
make -j"${NPROC}" all
make install
cd "${BUILD}"

echo "/usr/lib64/petsc/lib" > /etc/ld.so.conf.d/petsc.conf

echo "==> building SLEPc ${SLEPC_VER}"
mkdir -p slepc && tar -xzf slepc.tar.gz -C slepc --strip-components=1
cd slepc
# allow a development PETSc (the moose-pinned PETSc is 3.23.0 development)
sed -i "s/if slepc.release=='1' and not petsc.release=='1':/if False:/" config/packages/petsc.py
export PETSC_DIR=/usr/lib64/petsc
export PETSC_ARCH=
export SLEPC_DIR="${PWD}"
python3 ./configure --prefix=/usr/lib64/slepc
make SLEPC_DIR="${PWD}" PETSC_DIR=/usr/lib64/petsc -j"${NPROC}"
make SLEPC_DIR="${PWD}" PETSC_DIR=/usr/lib64/petsc install
cd "${BUILD}"

echo "/usr/lib64/slepc/lib" > /etc/ld.so.conf.d/slepc.conf
ldconfig

echo "==> building libMesh ${LIBMESH_GIT}"
mkdir -p libmesh && tar -xzf libmesh.tar.gz -C libmesh --strip-components=1
cd libmesh

rm -rf contrib/metaphysicl
mkdir -p contrib/metaphysicl
tar -xzf "${BUILD}/metaphysicl.tar.gz" --strip-components=1 -C contrib/metaphysicl

rm -rf contrib/timpi
mkdir -p contrib/timpi
tar -xzf "${BUILD}/timpi.tar.gz" --strip-components=1 -C contrib/timpi

rm -rf m4/autoconf-submodule
mkdir -p m4/autoconf-submodule
tar -xzf "${BUILD}/autoconf-submodule.tar.gz" --strip-components=1 -C m4/autoconf-submodule

rm -rf contrib/netcdf/netcdf-c
mkdir -p contrib/netcdf/netcdf-c
tar -xzf "${BUILD}/netcdf-c.tar.gz" --strip-components=1 -C contrib/netcdf/netcdf-c

rm -rf contrib/poly2tri/poly2tri
mkdir -p contrib/poly2tri/poly2tri
tar -xzf "${BUILD}/poly2tri.tar.gz" --strip-components=1 -C contrib/poly2tri/poly2tri

rm -rf contrib/nanoflann/nanoflann
mkdir -p contrib/nanoflann/nanoflann
tar -xzf "${BUILD}/nanoflann.tar.gz" --strip-components=1 -C contrib/nanoflann/nanoflann

# netgen/eigen are not provided; eigen comes from the system (eigen3-devel)
rm -rf contrib/netgen/netgen contrib/eigen/git

export PETSC_DIR=/usr/lib64/petsc
export SLEPC_DIR=/usr/lib64/slepc
./configure \
  --prefix=/usr \
  --libdir=/usr/lib64 \
  --with-methods=opt \
  --enable-silent-rules \
  --enable-unique-id \
  --with-thread-model=openmp \
  --enable-petsc-required \
  --with-slepc-dir=/usr/lib64/slepc \
  --enable-metaphysicl-required \
  --enable-xdr-required \
  --with-xdr-include=/usr/include/tirpc \
  --enable-netcdf=v492 \
  --with-eigen-include=/usr/include/eigen3 \
  --with-future-timpi-dir=/usr \
  --with-cxx-std-min=2014 \
  --without-gdb-command \
  --disable-netgen \
  --disable-warnings \
  --disable-maintainer-mode \
  --disable-dependency-tracking \
  --disable-examples \
  --disable-tests
make -j"${NPROC}"
make install
cd "${BUILD}"

echo "==> building MOOSE ${MOOSE_TAG}"
mkdir -p moose && tar -xzf moose.tar.gz -C moose --strip-components=1
cd moose

rm -rf framework/contrib/wasp
mkdir -p framework/contrib/wasp
tar -xzf "${BUILD}/wasp.tar.gz" --strip-components=1 -C framework/contrib/wasp

rm -rf framework/contrib/wasp/TriBITS
mkdir -p framework/contrib/wasp/TriBITS
tar -xzf "${BUILD}/tribits.tar.gz" --strip-components=1 -C framework/contrib/wasp/TriBITS

rm -rf framework/contrib/wasp/testframework
mkdir -p framework/contrib/wasp/testframework
tar --exclude=.git -C "${BUILD}/testframework" -cf - . | tar -C framework/contrib/wasp/testframework -xf -

export LIBMESH_DIR=/usr
export PETSC_DIR=/usr/lib64/petsc
export WASP_SRC_DIR="${PWD}/framework/contrib/wasp"
export MOOSE_JOBS=4

bash scripts/update_and_rebuild_wasp.sh
./configure
make -C framework -j4 GEN_REVISION=no
make -C test -j4 GEN_REVISION=no

mkdir -p /usr/share/moose_test
make -C test install PREFIX=/usr INSTALLABLE_DIRS= GEN_REVISION=no MOOSE_SKIP_DOCS=yes

find /usr -name '*.la' -delete
mkdir -p /usr/lib/moose_test
cp -a framework/contrib/wasp/install/lib/libwasp*.so* /usr/lib/moose_test/ 2>/dev/null || true

for f in /usr/bin/moose_test-opt /usr/bin/moose_test_runner /usr/bin/exodiff /usr/bin/hit; do
  [ -x "${f}" ] && patchelf --set-rpath /usr/lib/moose_test "${f}" || true
done
find /usr/lib/moose_test -maxdepth 1 -type f -name '*.so*' -exec patchelf --set-rpath /usr/lib/moose_test {} \;
find /usr/share/moose_test/bin /usr/share/moose/python -maxdepth 1 -type f \( -name '*.so' -o -perm -u+x \) -exec patchelf --set-rpath /usr/lib/moose_test {} \; 2>/dev/null || true

printf '%s\n' "2025.09.05" > /usr/share/moose_test/VERSION

ldconfig
cd /
rm -rf "${BUILD}"

echo "==> moose build finished"
/usr/bin/moose_test-opt --help >/dev/null 2>&1 || true
