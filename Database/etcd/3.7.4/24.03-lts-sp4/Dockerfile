ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS grabber
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=3.7.4
ARG TARGETARCH
RUN yum install -y curl tar gzip && yum clean all && rm -rf /var/cache/yum

WORKDIR /opt
RUN curl -fSL -o etcd.tar.gz https://github.com/etcd-io/etcd/releases/download/v${VERSION}/etcd-v${VERSION}-linux-${TARGETARCH}.tar.gz && \
    tar -xzf etcd.tar.gz && \
    mv etcd-v${VERSION}-linux-${TARGETARCH} /etcd

FROM openeuler/distroless-static:1.0.0-oe2403lts
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

COPY --from=grabber /etcd/etcd /usr/bin/etcd
COPY --from=grabber /etcd/etcdctl /usr/bin/etcdctl
COPY --from=grabber /etcd/etcdutl /usr/bin/etcdutl

EXPOSE 2379 2380
CMD [ "etcd" ]
