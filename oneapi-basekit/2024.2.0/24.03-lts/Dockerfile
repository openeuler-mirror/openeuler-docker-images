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

RUN yum update -y && yum install -y cmake procps make gcc gcc-c++ kernel-devel pkgconfig which bzip2 openssh-server openssh-clients wget net-tools git diffutils cmake intel-basekit intel-opencl intel-level-zero-gpu level-zero level-zero-devel

ENV LANG=C.UTF-8
ENV ADVISOR_2024_DIR='/opt/intel/oneapi/advisor/2024.2'
ENV APM='/opt/intel/oneapi/advisor/2024.2/perfmodels'
ENV CCL_CONFIGURATION='cpu_gpu_dpcpp'
ENV CCL_CONFIGURATION_PATH=''
ENV CCL_ROOT='/opt/intel/oneapi/ccl/2021.13'
ENV CLASSPATH='/opt/intel/oneapi/mpi/2021.13/share/java/mpi.jar'
ENV CMAKE_PREFIX_PATH='/opt/intel/oneapi/tbb/2021.13/env/..:/opt/intel/oneapi/mkl/2024.2/lib/cmake:/opt/intel/oneapi/ipp/2021.12/lib/cmake/ipp:/opt/intel/oneapi/dpl/2022.6/lib/cmake/oneDPL:/opt/intel/oneapi/dnnl/2024.2/lib/cmake:/opt/intel/oneapi/dal/2024.5:/opt/intel/oneapi/compiler/2024.2'
ENV CMPLR_ROOT='/opt/intel/oneapi/compiler/2024.2'
ENV CPATH='/opt/intel/oneapi/tbb/2021.13/env/../include:/opt/intel/oneapi/mpi/2021.13/include:/opt/intel/oneapi/mkl/2024.2/include:/opt/intel/oneapi/ippcp/2021.12/include:/opt/intel/oneapi/ipp/2021.12/include:/opt/intel/oneapi/dpl/2022.6/include:/opt/intel/oneapi/dpcpp-ct/2024.2/include:/opt/intel/oneapi/dnnl/2024.2/include:/opt/intel/oneapi/dev-utilities/2024.2/include:/opt/intel/oneapi/dal/2024.5/include/dal:/opt/intel/oneapi/ccl/2021.13/include'
ENV DALROOT='/opt/intel/oneapi/dal/2024.5'
ENV DAL_MAJOR_BINARY='2'
ENV DAL_MINOR_BINARY='0'
ENV DIAGUTIL_PATH='/opt/intel/oneapi/dpcpp-ct/2024.2/etc/dpct/sys_check/sys_check.sh:/opt/intel/oneapi/debugger/2024.2/etc/debugger/sys_check/sys_check.py:/opt/intel/oneapi/compiler/2024.2/etc/compiler/sys_check/sys_check.sh'
ENV DNNLROOT='/opt/intel/oneapi/dnnl/2024.2'
ENV DPL_ROOT='/opt/intel/oneapi/dpl/2022.6'
ENV FI_PROVIDER_PATH='/opt/intel/oneapi/mpi/2021.13/opt/mpi/libfabric/lib/prov:/usr/lib64/libfabric'
ENV GDB_INFO='/opt/intel/oneapi/debugger/2024.2/share/info/'
ENV INFOPATH='/opt/intel/oneapi/debugger/2024.2/share/info'
ENV INTEL_PYTHONHOME='/opt/intel/oneapi/debugger/2024.2/opt/debugger'
ENV IPPCP_TARGET_ARCH='intel64'
ENV IPPCRYPTOROOT='/opt/intel/oneapi/ippcp/2021.12'
ENV IPPROOT='/opt/intel/oneapi/ipp/2021.12'
ENV IPP_TARGET_ARCH='intel64'
ENV I_MPI_ROOT='/opt/intel/oneapi/mpi/2021.13'
ENV LD_LIBRARY_PATH='/opt/intel/oneapi/tbb/2021.13/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/mpi/2021.13/opt/mpi/libfabric/lib:/opt/intel/oneapi/mpi/2021.13/lib:/opt/intel/oneapi/mkl/2024.2/lib:/opt/intel/oneapi/ippcp/2021.12/lib/:/opt/intel/oneapi/ipp/2021.12/lib:/opt/intel/oneapi/dpl/2022.6/lib:/opt/intel/oneapi/dnnl/2024.2/lib:/opt/intel/oneapi/debugger/2024.2/opt/debugger/lib:/opt/intel/oneapi/dal/2024.5/lib:/opt/intel/oneapi/compiler/2024.2/opt/compiler/lib:/opt/intel/oneapi/compiler/2024.2/lib:/opt/intel/oneapi/ccl/2021.13/lib/'
ENV LIBRARY_PATH='/opt/intel/oneapi/tbb/2021.13/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/mpi/2021.13/lib:/opt/intel/oneapi/mkl/2024.2/lib/:/opt/intel/oneapi/ippcp/2021.12/lib/:/opt/intel/oneapi/ipp/2021.12/lib:/opt/intel/oneapi/dpl/2022.6/lib:/opt/intel/oneapi/dnnl/2024.2/lib:/opt/intel/oneapi/dal/2024.5/lib:/opt/intel/oneapi/compiler/2024.2/lib:/opt/intel/oneapi/ccl/2021.13/lib/'
ENV MANPATH='/opt/intel/oneapi/mpi/2021.13/share/man:/opt/intel/oneapi/debugger/2024.2/share/man:/opt/intel/oneapi/compiler/2024.2/share/man:'
ENV MKLROOT='/opt/intel/oneapi/mkl/2024.2'
ENV NLSPATH='/opt/intel/oneapi/mkl/2024.2/share/locale/%l_%t/%N:/opt/intel/oneapi/compiler/2024.2/lib/compiler/locale/%l_%t/%N'
ENV OCL_ICD_FILENAMES='/opt/intel/oneapi/compiler/2024.2/lib/libintelocl.so'
ENV ONEAPI_ROOT='/opt/intel/oneapi'
ENV PATH='/opt/intel/oneapi/vtune/2024.2/bin64:/opt/intel/oneapi/mpi/2021.13/bin:/opt/intel/oneapi/mkl/2024.2/bin/:/opt/intel/oneapi/dpcpp-ct/2024.2/bin:/opt/intel/oneapi/dev-utilities/2024.2/bin:/opt/intel/oneapi/debugger/2024.2/opt/debugger/bin:/opt/intel/oneapi/compiler/2024.2/bin:/opt/intel/oneapi/advisor/2024.2/bin64:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
ENV PKG_CONFIG_PATH='/opt/intel/oneapi/vtune/2024.2/include/pkgconfig/lib64:/opt/intel/oneapi/tbb/2021.13/env/../lib/pkgconfig:/opt/intel/oneapi/mpi/2021.13/lib/pkgconfig:/opt/intel/oneapi/mkl/2024.2/lib/pkgconfig:/opt/intel/oneapi/ippcp/2021.12/lib/pkgconfig:/opt/intel/oneapi/dpl/2022.6/lib/pkgconfig:/opt/intel/oneapi/dnnl/2024.2/lib/pkgconfig:/opt/intel/oneapi/dal/2024.5/lib/pkgconfig:/opt/intel/oneapi/compiler/2024.2/lib/pkgconfig:/opt/intel/oneapi/ccl/2021.13/lib/pkgconfig/:/opt/intel/oneapi/advisor/2024.2/include/pkgconfig/lib64:'
ENV PYTHONPATH='/opt/intel/oneapi/advisor/2024.2/pythonapi'
ENV SETVARS_COMPLETED='1'
ENV TBBROOT='/opt/intel/oneapi/tbb/2021.13/env/..'
ENV VTUNE_PROFILER_2024_DIR='/opt/intel/oneapi/vtune/2024.2'
ENV VTUNE_PROFILER_DIR='/opt/intel/oneapi/vtune/2024.2'
