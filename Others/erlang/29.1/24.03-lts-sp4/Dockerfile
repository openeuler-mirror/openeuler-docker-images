ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=29.1

RUN dnf install -y \
        gcc gcc-c++ make \
        flex perl \
        ncurses-devel openssl-devel zlib-devel \
        ca-certificates curl && \
    dnf clean all

RUN curl -fSL --connect-timeout 20 --retry 3 --retry-delay 5 \
        -o /tmp/otp_src_${VERSION}.tar.gz \
        https://github.com/erlang/otp/releases/download/OTP-${VERSION}/otp_src_${VERSION}.tar.gz && \
    echo "568b4edbeadc414b87257ebbb5ededc313ad7deaa688679ca0bd6bb49808cce1  /tmp/otp_src_${VERSION}.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/otp && \
    tar -zxf /tmp/otp_src_${VERSION}.tar.gz -C /tmp/otp --strip-components=1 && \
    rm -f /tmp/otp_src_${VERSION}.tar.gz

RUN cd /tmp/otp && \
    ./configure --prefix=/usr/local && \
    make -j"$(nproc)" && \
    make install && \
    rm -rf /tmp/otp

FROM ${BASE}

COPY --from=builder /usr/local /usr/local

USER root

CMD ["erl"]
