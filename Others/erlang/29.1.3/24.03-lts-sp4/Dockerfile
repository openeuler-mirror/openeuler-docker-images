ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=29.1.3

RUN dnf install -y \
        gcc gcc-c++ make \
        flex perl \
        ncurses-devel openssl-devel zlib-devel \
        ca-certificates curl && \
    dnf clean all

RUN curl -fSL --connect-timeout 20 --retry 3 --retry-delay 5 \
        -o /tmp/otp_src_${VERSION}.tar.gz \
        https://github.com/erlang/otp/releases/download/OTP-${VERSION}/otp_src_${VERSION}.tar.gz && \
    echo "44d8ee7f0964537ddb328fe2f6307d3338c3fdd1b2826938d490907771ba70d2  /tmp/otp_src_${VERSION}.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/otp && \
    tar -zxf /tmp/otp_src_${VERSION}.tar.gz -C /tmp/otp --strip-components=1 && \
    rm -f /tmp/otp_src_${VERSION}.tar.gz

RUN cd /tmp/otp && \
    ./configure --prefix=/usr/local && \
    make -j"$(nproc)" && \
    make install && \
    rm -rf /tmp/otp

FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

COPY --from=builder /usr/local /usr/local

USER root

CMD ["erl"]
