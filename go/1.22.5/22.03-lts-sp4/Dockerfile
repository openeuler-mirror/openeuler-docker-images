ARG BASE=openeuler/openeuler:22.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG LOCAL_PATH=/usr/local

ENV GOPATH=/go
ENV GOTOOLCHAIN=local
ENV GOLANG_VERSION=1.22.5
ENV GO_ROOT=${LOCAL_PATH}/go
ENV PATH=$GOPATH/bin:$GO_ROOT/bin:$PATH

RUN set -eux; \
    yum update -y && yum -y install g++ gcc glibc-devel make pkg-config findutils && yum clean all; \
    curl -fSL -o ${LOCAL_PATH}/go.tar.gz https://dl.google.com/go/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz; \
    tar -xvf ${LOCAL_PATH}/go.tar.gz -C ${LOCAL_PATH}; \
    rm -f ${LOCAL_PATH}/go.tar.gz

RUN set -eux; \
    find ${GO_ROOT}/src -exec touch -r ${GO_ROOT}/VERSION "{}" \; && \
    touch ${GO_ROOT}/pkg; \
    find ${GO_ROOT}/pkg -exec touch -r ${GO_ROOT}/pkg "{}" \; && \
    mkdir -p ${GO_ROOT}/bin/linux_${TARGETARCH}; \
    ln -sf ${GO_ROOT}/bin/go ${GO_ROOT}/bin/linux_${TARGETARCH}/go; \
    ln -sf ${GO_ROOT}/bin/gofmt ${GO_ROOT}/bin/linux_${TARGETARCH}/gofmt

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin"; \
    chmod -R 1777 "$GOPATH"

WORKDIR $GOPATH

CMD ["go", "version"]