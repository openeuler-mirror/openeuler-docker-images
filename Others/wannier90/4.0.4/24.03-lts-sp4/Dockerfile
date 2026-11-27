ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=4.0.4

RUN dnf install -y \
      cmake gcc gcc-gfortran make \
      openblas-devel lapack-devel \
      curl tar && \
    dnf clean all

WORKDIR /workspace
RUN curl -fSL --connect-timeout 30 --retry 3 \
      -o wannier90-${VERSION}.tar.gz \
      https://github.com/wannier-developers/wannier90/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -zxf wannier90-${VERSION}.tar.gz && \
    cmake -S wannier90-${VERSION} -B wannier90-${VERSION}/build \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DWANNIER90_TEST=OFF && \
    cmake --build wannier90-${VERSION}/build -j$(nproc) && \
    cmake --install wannier90-${VERSION}/build && \
    rm -rf wannier90-${VERSION} wannier90-${VERSION}.tar.gz

FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

RUN dnf install -y \
      libgfortran openblas lapack && \
    dnf clean all

COPY --from=builder /usr/local /usr/local

ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib

WORKDIR /workspace
USER root
