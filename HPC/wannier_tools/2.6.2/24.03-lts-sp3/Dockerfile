ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=2.6.2
ARG TAG=v${VERSION}
RUN yum install -y \
        git gcc-gfortran gcc gcc-c++ make which \
        lapack-devel openblas-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${TAG} https://github.com/quanshengwu/wannier_tools.git /wannier-tools
WORKDIR /wannier-tools/src
RUN cp Makefile.gfortran_travis Makefile && \
    sed -i 's/-fprofile-arcs -ftest-coverage//' Makefile && \
    sed -i 's/main.o/arpack_stub.o main.o/' Makefile
RUN printf '%s\n' \
    'subroutine arpack_sparse_coo_eigs(ndims,nnzmax,nnz,acoo,jcoo,icoo,neval,nvecs,deval,sigma,zeigv,ritzvec)' \
    '  use para, only : dp' \
    '  implicit none' \
    '  integer, intent(inout) :: ndims' \
    '  integer, intent(in) :: nnzmax, neval, nvecs' \
    '  integer, intent(inout) :: nnz' \
    '  complex(dp), intent(inout) :: acoo(nnzmax)' \
    '  integer, intent(inout) :: jcoo(nnzmax), icoo(nnzmax)' \
    '  logical, intent(in) :: ritzvec' \
    '  real(dp), intent(out) :: deval(neval)' \
    '  complex(dp), intent(in) :: sigma' \
    '  complex(dp), intent(out) :: zeigv(ndims, nvecs)' \
    '  deval= 0d0' \
    '  zeigv= 0d0' \
    "  write(*,*) 'ERROR: sparse ARPACK mode not available'" \
    "  write(*,*) 'Please use dense hr.dat format'" \
    '  stop 1' \
    'end subroutine arpack_sparse_coo_eigs' \
    > arpack_stub.f90
RUN make module.o && \
    gfortran -c -O2 -ffree-line-length-512 arpack_stub.f90 && \
    make -j 4 && \
    cp wt.x /usr/bin/
WORKDIR /workspace
CMD ["/bin/bash"]