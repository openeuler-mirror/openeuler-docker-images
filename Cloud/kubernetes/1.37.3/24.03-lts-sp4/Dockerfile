ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)
ARG VERSION=1.37.3

RUN dnf update -y \
    && dnf install -y wget golang rsync \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /usr/local

RUN wget https://github.com/kubernetes/kubernetes/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -zxvf v${VERSION}.tar.gz \
    && rm -f v${VERSION}.tar.gz

WORKDIR /usr/local/kubernetes-${VERSION}

RUN make -j$(nproc)

CMD ["./_output/bin/kubeadm", "--help"]
