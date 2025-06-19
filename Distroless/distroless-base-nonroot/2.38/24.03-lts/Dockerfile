ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE} as builder

WORKDIR /tmp

RUN echo "root:x:0:0:root:/root:/sbin/nologin" > passwd && \
    echo "nobody:x:65534:65534:nobody:/nonexistent:/sbin/nologin" >> passwd && \
    echo "nonroot:x:65532:65532:nonroot:/home/nonroot:/sbin/nologin" >> passwd

RUN echo "root:x:0:" > group && \
    echo "nobody:x:65534:" >> group && \
    echo "tty:x:5:" >> group && \
    echo "staff:x:50:" >> group && \
    echo "nonroot:x:65532:" >> group

RUN mkdir -p /home/nonroot && \
    chmod 700 /home/nonroot

FROM openeuler/distroless-base:2.38-oe2403lts

COPY --from=builder /tmp/passwd /etc/passwd
COPY --from=builder /tmp/group /etc/group
COPY --from=builder --chown=nonroot:nonroot /home/nonroot /home/nonroot

USER nonroot
WORKDIR /home/nonroot