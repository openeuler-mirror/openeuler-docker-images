ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)
ARG VERSION=fb32cae86117254cb27c4695e6aa77299724d62d

RUN dnf install -y gcc make ctags libtirpc-devel \
    && dnf clean all

WORKDIR /opt

RUN curl -fSL -o webbench.tar.gz https://github.com/EZLippi/WebBench/archive/${VERSION}.tar.gz \
    && tar -xzf webbench.tar.gz \
    && rm -f webbench.tar.gz

WORKDIR /opt/WebBench-${VERSION}

RUN make CFLAGS="-ggdb -W -I/usr/include/tirpc" \
    && make install

CMD ["webbench", "--help"]
