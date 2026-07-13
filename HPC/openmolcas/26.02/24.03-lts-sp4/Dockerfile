ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
ARG VERSION=26.02
RUN yum install -y \
        gcc gcc-gfortran make cmake git which \
        python3 python3-devel \
        hdf5-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b v${VERSION} \
        https://github.com/Molcas/OpenMolcas.git /OpenMolcas && \
    cd /OpenMolcas && \
    git submodule update --init External/lapack External/libmsym External/libwfa External/NECI
WORKDIR /build
RUN cmake ../OpenMolcas -DLINALG=Internal -DBUILD_TESTING=OFF -DWITH_EFP=OFF && \
    make -j $(nproc) && \
    make install && \
    cd / && rm -rf /build /OpenMolcas
ENV MOLCAS=/opt/OpenMolcas
ENV PATH=/opt/OpenMolcas/bin:$PATH
WORKDIR /workspace
CMD ["/bin/bash"]