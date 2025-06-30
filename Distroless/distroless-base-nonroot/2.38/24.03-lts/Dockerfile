ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE} as builder

RUN dnf install -y shadow-utils && \
    groupadd -g 65532 nonroot && \
    useradd -u 65532 -g 65532 -s /sbin/nologin nonroot

FROM openeuler/distroless-base:2.38-oe2403lts

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

USER nonroot