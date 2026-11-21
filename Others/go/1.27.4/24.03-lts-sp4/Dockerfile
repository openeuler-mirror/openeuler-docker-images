ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG TARGETARCH
ARG LOCAL_PATH=/usr/local

ENV GOPATH=/go
ENV GOTOOLCHAIN=local
ENV GOLANG_VERSION=1.27.4
ENV GOROOT=${LOCAL_PATH}/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

RUN set -eux; \
    yum update -y && yum -y install g++ gcc glibc-devel make pkg-config findutils && yum clean all; \
    curl -fSL -o ${LOCAL_PATH}/go.tar.gz https://dl.google.com/go/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz; \
    tar -xvf ${LOCAL_PATH}/go.tar.gz -C ${LOCAL_PATH}; \
    rm -f ${LOCAL_PATH}/go.tar.gz

RUN set -eux; \
    find ${GOROOT}/src -exec touch -r ${GOROOT}/VERSION "{}" \; && \
    touch ${GOROOT}/pkg; \
    find ${GOROOT}/pkg -exec touch -r ${GOROOT}/pkg "{}" \; && \
    mkdir -p ${GOROOT}/bin/linux_${TARGETARCH}; \
    ln -sf ${GOROOT}/bin/go ${GOROOT}/bin/linux_${TARGETARCH}/go; \
    ln -sf ${GOROOT}/bin/gofmt ${GOROOT}/bin/linux_${TARGETARCH}/gofmt

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin"; \
    chmod -R 1777 "$GOPATH"; \
    yum -y remove g++ gcc glibc-devel make pkg-config findutils; \
    yum clean all

WORKDIR $GOPATH

CMD ["go", "version"]
