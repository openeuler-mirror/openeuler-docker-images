ARG BASE=openeuler/openeuler:24.03-lts-sp4

FROM openeuler/openeuler:20.03-lts-sp4 AS builder

ARG VERSION=0.52
ARG VASPKIT_URL=https://sourceforge.net/projects/vaspkit/files/Src/vaspkit.${VERSION}.tar.gz

RUN yum install -y \
        gcc gcc-c++ gcc-gfortran make wget tar && \
    yum clean all && rm -rf /var/cache/yum

RUN wget ${VASPKIT_URL} -O /tmp/vaspkit.tar.gz && \
    mkdir -p /opt/vaspkit && \
    tar -xzf /tmp/vaspkit.tar.gz -C /opt/vaspkit --strip-components=1 && \
    rm -f /tmp/vaspkit.tar.gz && \
    make -C /opt/vaspkit/src

FROM ${BASE}

COPY --from=builder /opt/vaspkit/src/vaspkit /usr/local/bin/vaspkit
COPY --from=builder /usr/lib64/libgfortran.so.4* /usr/lib64/
COPY --from=builder /usr/lib64/libquadmath.so.0* /usr/lib64/

WORKDIR /workspace
CMD ["/bin/bash"]
