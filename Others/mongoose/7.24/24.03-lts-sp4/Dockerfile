ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} as builder
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)
ARG VERSION=7.24

RUN yum install -y gcc-c++ wget  && \
    yum clean all

WORKDIR /mongoose

COPY example.c .

RUN wget https://github.com/cesanta/mongoose/archive/refs/tags/${VERSION}.tar.gz \
    && tar -zxvf ${VERSION}.tar.gz -C /mongoose --strip-components=1 \
    && gcc example.c mongoose.c -o server -lpthread

FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

WORKDIR /mongoose

COPY --from=builder /mongoose/server /mongoose/server

CMD ["./server"]
