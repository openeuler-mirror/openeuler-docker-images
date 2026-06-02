ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=1.4.1
ARG TAG=v${VERSION}
RUN yum install -y \
        git gcc gcc-c++ make which && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone --recursive -b ${TAG} https://github.com/marbl/meryl.git /meryl
WORKDIR /meryl/src
RUN if [ "$(uname -m)" = "aarch64" ]; then \
        printf '' > utility/src/align/align-ksw2-extz2-sse.C && \
        printf '' > utility/src/align/align-ssw-driver.C && \
        printf '' > utility/src/align/align-ssw.C; \
    fi && \
    make -j 4 && \
    cp /meryl/build/bin/meryl /usr/bin/
WORKDIR /workspace
CMD ["/bin/bash"]