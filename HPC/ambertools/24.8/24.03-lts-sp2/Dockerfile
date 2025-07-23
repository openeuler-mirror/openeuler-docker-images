ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE} AS builder

ARG VERSION=24.8

RUN dnf update -y \
    && dnf install -y tcsh make cmake gcc gcc-gfortran gcc-c++ which flex bison patch bc libXt-devel libXext-devel perl util-linux wget bzip2 bzip2-devel zlib-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

COPY UseMiniconda.cmake .

RUN wget https://ambermd.org/downloads/AmberTools24_rc5.tar.bz2

RUN tar xf AmberTools24_rc5.tar.bz2 \
    && cd amber24_src \
    && mv -f /opt/UseMiniconda.cmake ./cmake/UseMiniconda.cmake \
    && cd build \
    && ./run_cmake \
    && make install

FROM ${BASE}
ARG MAJOR_VERSION=24

COPY --from=builder /opt/amber${MAJOR_VERSION} /opt/amber${MAJOR_VERSION}

ENV AMBERHOME=/opt/amber${MAJOR_VERSION}
ENV PATH=$AMBERHOME/bin:$PATH
ENV LD_LIBRARY_PATH=$AMBERHOME/lib
ENV PYTHONPATH=$AMBERHOME/lib/python3.12/site-packages
ENV QUICK_BASIS=$AMBERHOME/AmberTools/src/quick/basis

CMD ["tleap"]
