# Copyright (C) 2025 Huawei Technologies Co., Ltd.
# SPDX-License-Identifier: Apache-2.0

# Build the inference-router binary
ARG BASE=openeuler/go:1.24.1-oe2403lts
ARG VERSION=v0.15.2

FROM ${BASE} AS builder

ARG VERSION

RUN yum update -y && \
    yum install -y \
    shadow-utils \
    git && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN groupadd -g 1001 kserve && \
    useradd -u 1001 -g 1001 -s /sbin/nologin --badname 65532

# Copy in the go src
WORKDIR /go/src/github.com/kserve/kserve

ARG KSERVE_REPO=https://github.com/kserve/kserve.git
RUN git clone -b $VERSION $KSERVE_REPO && \
    cp -r kserve/go.mod go.mod && \
    cp -r kserve/go.sum go.sum && \
    cp -r kserve/cmd cmd && \
    cp -r kserve/pkg pkg && \
    cp -r kserve/LICENSE LICENSE && \
    rm -fr kserve

RUN go mod download


# Build
RUN CGO_ENABLED=0  go build -a -o router ./cmd/router

RUN go install github.com/google/go-licenses@latest
# Forbidden Licenses: https://github.com/google/licenseclassifier/blob/e6a9bb99b5a6f71d5a34336b8245e305f5430f99/license_type.go#L341
RUN go-licenses check ./cmd/... ./pkg/... --disallowed_types="forbidden,unknown"
RUN go-licenses save --save_path third_party/library ./cmd/router

# Copy the inference-router into a thin image
FROM openeuler/distroless-base-nonroot:2.38-oe2403lts

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

COPY --from=builder /go/src/github.com/kserve/kserve/third_party /third_party
WORKDIR /ko-app
COPY --from=builder /go/src/github.com/kserve/kserve/router /ko-app/
ENTRYPOINT ["/ko-app/router"]
