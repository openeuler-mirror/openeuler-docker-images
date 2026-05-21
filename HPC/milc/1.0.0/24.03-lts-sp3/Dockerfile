ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=1.0.0

ENV MILC_HOME=/opt/milc_qcd

ENV LANG=C.UTF-8 \
    PATH=/usr/lib64/openmpi/bin:${MILC_HOME}/build/ks_imp_rhmc:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN dnf -y update && \
    dnf -y install --nodocs --setopt=install_weak_deps=False \
        gcc gcc-c++ cmake openmpi-devel make git && \
    dnf clean all && rm -rf /var/cache/dnf

WORKDIR /opt

RUN git clone --depth 1 --branch develop https://github.com/milc-qcd/milc_qcd.git ${MILC_HOME} && \
    cd ${MILC_HOME} && \
    mkdir -p build && cd build && \
    cmake .. -DMPP=ON -DOMP=ON -DSUBDIR=ks_imp_rhmc -DPRECISION=2 && \
    cmake --build . -j$(nproc) --target su3_rhmd_hisq

ENV OMPI_ALLOW_RUN_AS_ROOT=1 \
    OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

WORKDIR ${MILC_HOME}

LABEL org.opencontainers.image.title="milc" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.description="MILC collaboration code for lattice QCD calculations"

CMD ["bash"]