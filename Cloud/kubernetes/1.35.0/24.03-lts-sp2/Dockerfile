ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=1.35.0

RUN dnf update -y \
    && dnf install -y wget golang rsync \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /usr/local

RUN wget https://github.com/kubernetes/kubernetes/archive/refs/tags/v${VERSION}.tar.gz \
    && tar -zxvf v${VERSION}.tar.gz \
    && rm -f v${VERSION}.tar.gz

WORKDIR /usr/local/kubernetes-${VERSION}

RUN make -j

CMD ["./_output/bin/kubeadm", "--help"]