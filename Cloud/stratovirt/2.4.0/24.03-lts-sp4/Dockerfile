ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=2.4.0

RUN dnf install -y \
      cargo rust \
      gcc git \
      pixman-devel && \
    dnf clean all

WORKDIR /build

RUN git clone --depth 1 --branch v${VERSION} \
        https://gitcode.com/openeuler/stratovirt.git && \
    cd stratovirt && \
    cargo build --bin stratovirt --release

FROM ${BASE}

COPY --from=builder /build/stratovirt/target/release/stratovirt /usr/local/bin/stratovirt
COPY --from=builder /build/stratovirt/license/ /usr/share/licenses/stratovirt/

USER root

CMD ["stratovirt", "-help"]