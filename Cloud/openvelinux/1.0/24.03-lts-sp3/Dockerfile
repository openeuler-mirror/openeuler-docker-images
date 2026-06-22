ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=1.0

RUN dnf install -y curl perl && \
    curl -fSL "https://github.com/openvelinux/flamegraph/archive/refs/tags/velinux/${VERSION}%2Bvelinux2.tar.gz" \
        -o flamegraph.tar.gz && \
    tar -xzf flamegraph.tar.gz && \
    cp flamegraph-velinux-${VERSION}-velinux2/*.pl /usr/local/bin/ && \
    chmod +x /usr/local/bin/*.pl && \
    rm -rf flamegraph-velinux-${VERSION}-velinux2 flamegraph.tar.gz && \
    dnf clean all

CMD ["flamegraph.pl"]
