ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2.7

RUN dnf install -y gcc make wget tar gzip && \
    dnf clean all && rm -rf /var/cache/dnf

RUN curl -fSL --connect-timeout 30 --retry 3 -o /tmp/gsl.tar.gz \
        https://ftp.gnu.org/gnu/gsl/gsl-${VERSION}.tar.gz && \
    tar -xzf /tmp/gsl.tar.gz -C /tmp && \
    cd /tmp/gsl-${VERSION} && \
    ./configure --prefix=/usr/local && \
    make -j"$(nproc)" && \
    make install && \
    rm -rf /tmp/gsl.tar.gz /tmp/gsl-${VERSION}

ENV LD_LIBRARY_PATH=/usr/local/lib:${LD_LIBRARY_PATH}
ENV PATH=/usr/local/bin:${PATH}

WORKDIR /workspace
CMD ["bash"]
