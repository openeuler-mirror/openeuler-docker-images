ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS builder

ARG VERSION=11.4.1

RUN dnf update -y \
    && dnf install -y gcc gcc-c++ cmake make wget expat-devel zlib-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/Geant4/geant4/archive/v${VERSION}.tar.gz \
    && tar -xzf v${VERSION}.tar.gz \
    && rm -f v${VERSION}.tar.gz

WORKDIR /opt/geant4-${VERSION}-build

RUN cmake -DCMAKE_INSTALL_PREFIX=/opt/geant4-${VERSION}-install \
    -DGEANT4_BUILD_MULTITHREADED=ON \
    -DGEANT4_INSTALL_DATA=OFF \
    -DGEANT4_USE_SYSTEM_EXPAT=ON \
    -DGEANT4_USE_SYSTEM_ZLIB=ON \
    /opt/geant4-${VERSION}

RUN make -j$(nproc) \
    && make install

FROM ${BASE}

RUN dnf install -y gcc gcc-c++ expat-devel zlib-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

COPY --from=builder /opt/geant4-11.4.1-install /opt/geant4-11.4.1-install

ENV G4BASE=/opt/geant4-11.4.1-install
ENV PATH=${G4BASE}/bin:${PATH}
ENV LD_LIBRARY_PATH=${G4BASE}/lib:${LD_LIBRARY_PATH}

WORKDIR /opt/geant4-11.4.1-install/share/Geant4-11.4.1/examples/basic/B1

CMD ["bash"]