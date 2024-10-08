# Copyright (c) 2020-2021 Intel Corporation.
# SPDX-License-Identifier: BSD-3-Clause

FROM openeuler/openeuler:24.03-lts
COPY third-party-programs.txt /

# repository to install Intel(R) oneAPI Libraries
RUN echo $'\
[oneAPI]\n\
name=Intel(R) oneAPI repository\n\
baseurl=https://yum.repos.intel.com/oneapi\n\
enabled=1\n\
gpgcheck=1\n\
repo_gpgcheck=1\n\
gpgkey=https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB' \
> /etc/yum.repos.d/oneAPI.repo

# We share all rpm based packages under Intel hosted RHEL folder,
# however, it's verified support openEuler platforms
# add repository to install Intel(R) GPU drivers for openEuler
RUN echo $'\
[intel-graphics-9.3-unified]\n\
name=Intel graphics 9.3 unified\n\
enabled=1\n\
gpgcheck=1\n\
baseurl=https://repositories.intel.com/gpu/rhel/9.3/lts/2350/unified/\n\
gpgkey=https://repositories.intel.com/gpu/intel-graphics.key' \
> /etc/yum.repos.d/intel-graphics.repo

RUN yum update -y && yum install -y cmake procps make gcc gcc-c++ kernel-devel pkgconfig which bzip2 openssh-server openssh-clients wget net-tools git diffutils cmake intel-oneapi-runtime-ccl intel-oneapi-runtime-compilers-2024 intel-oneapi-runtime-dal intel-oneapi-runtime-dnnl intel-oneapi-runtime-dpcpp-cpp intel-oneapi-runtime-dpcpp-library intel-oneapi-runtime-fortran intel-oneapi-runtime-ipp intel-oneapi-runtime-ipp-crypto intel-oneapi-runtime-libs intel-oneapi-runtime-mkl intel-oneapi-runtime-mpi intel-oneapi-runtime-opencl-2024 intel-oneapi-runtime-openmp intel-oneapi-runtime-tbb intel-oneapi-tcm-1.0 intel-opencl intel-level-zero-gpu level-zero level-zero-devel

ENV LANG=C.UTF-8
ENV LD_LIBRARY_PATH=/opt/intel/oneapi/lib
ENV CMAKE_PREFIX_PATH='/opt/intel/oneapi/tbb/2021.13/env/..'
ENV CPATH='/opt/intel/oneapi/tbb/2021.13/env/../include'
ENV LD_LIBRARY_PATH='/opt/intel/oneapi/tbb/2021.13/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/lib'
ENV LIBRARY_PATH='/opt/intel/oneapi/tbb/2021.13/env/../lib/intel64/gcc4.8'
ENV ONEAPI_ROOT='/opt/intel/oneapi'
ENV PKG_CONFIG_PATH='/opt/intel/oneapi/tbb/2021.13/env/../lib/pkgconfig'
ENV SETVARS_COMPLETED='1'
ENV TBBROOT='/opt/intel/oneapi/tbb/2021.13/env/..'
