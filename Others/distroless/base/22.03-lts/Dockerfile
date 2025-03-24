FROM openeuler/openeuler:22.03-lts AS builder

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=22.03-LTS
ARG BUILD_ROOT=/var/tmp/containers/distroless/openEuler-docker-rootfs

COPY build.sh /tmp/

RUN set -eux; \
    if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi; \
    yum -y install wget xz; \
    bash -x /tmp/build.sh $VERSION $BUILDARCH $BUILD_ROOT

FROM scratch

COPY --from=builder /var/tmp/containers/distroless/openEuler-docker-rootfs/ /
COPY --from=builder /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
COPY --from=builder /etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt /etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt

CMD ["bash"]
