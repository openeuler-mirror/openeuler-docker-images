ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG TAG=NOVOPlasty4.3.5
RUN yum install -y \
        perl git && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${TAG} https://github.com/ndierckx/NOVOPlasty.git /NOVOPlasty && \
    cp /NOVOPlasty/NOVOPlasty4.3.5.pl /usr/local/bin/NOVOPlasty.pl && \
    cp /NOVOPlasty/filter_reads.pl /usr/local/bin/ && \
    chmod +x /usr/local/bin/NOVOPlasty.pl /usr/local/bin/filter_reads.pl && \
    cd / && rm -rf /NOVOPlasty
WORKDIR /workspace
CMD ["/bin/bash"]