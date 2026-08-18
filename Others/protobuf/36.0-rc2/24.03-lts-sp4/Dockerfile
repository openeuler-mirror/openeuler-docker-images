ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=36.0-rc2

RUN dnf install -y \
      unzip \
      && dnf clean all \
      && rm -rf /var/cache/dnf

WORKDIR /opt

RUN case "$(uname -m)" in \
        x86_64) ARCH=x86_64; CHECKSUM=2321fed0bfc051439e537aa1dfc3139ea03b133a85d150b9374172278d202c44;; \
        aarch64) ARCH=aarch_64; CHECKSUM=5c1349440da784943ca6aa4e28409c31b9ee4a4847c764c8c831fb383649a7c6;; \
        *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1;; \
    esac \
    && PROTOC_VERSION=$(echo "${VERSION}" | sed -E 's/-rc([0-9]+)$/-rc-\1/') \
    && curl -fSL --connect-timeout 30 --retry 3 -o protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v${VERSION}/protoc-${PROTOC_VERSION}-linux-${ARCH}.zip" \
    && echo "${CHECKSUM}  protoc.zip" | sha256sum -c - \
    && unzip -q protoc.zip -d /opt/protoc \
    && rm -f protoc.zip

FROM ${BASE}

COPY --from=builder /opt/protoc/bin/protoc /usr/local/bin/protoc
COPY --from=builder /opt/protoc/include /usr/local/include

USER root

CMD ["protoc", "--version"]
