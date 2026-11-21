ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE AS builder
ARG VERSION=8.6.0
RUN dnf install -y \
      gcc gcc-c++ git make \
      openmpi-devel \
      python3 && \
    dnf clean all
RUN for i in 1 2 3 4 5; do \
      git clone --branch v${VERSION} --depth=1 https://github.com/su2code/SU2.git /usr/src/su2 && break; \
      if [ "$i" -eq 5 ]; then exit 1; fi; \
      sleep 5; \
    done
WORKDIR /usr/src/su2
RUN ./meson.py setup build --prefix=/usr/local/su2 && \
    ./ninja -C build install

FROM $BASE
RUN dnf install -y \
      openmpi \
      python3-numpy python3-scipy && \
    dnf clean all
ENV PATH=/usr/local/su2/bin:$PATH
ENV SU2_RUN=/usr/local/su2/bin
COPY --from=builder /usr/local/su2 /usr/local/su2
USER root
WORKDIR /workspace
CMD ["/bin/bash"]
