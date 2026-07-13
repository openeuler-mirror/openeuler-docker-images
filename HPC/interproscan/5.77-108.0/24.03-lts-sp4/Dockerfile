ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
ARG VERSION=5.77-108.0
RUN yum install -y \
        java-11-openjdk-headless python3 perl wget curl \
        pcre2-devel libgomp which && \
    yum clean all && rm -rf /var/cache/yum
RUN ln -s /usr/bin/python3 /usr/bin/python
WORKDIR /opt
RUN curl -L -o interproscan-core-${VERSION}.tar.gz \
        https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/${VERSION}/alt/interproscan-core-${VERSION}.tar.gz && \
    tar -zxf interproscan-core-${VERSION}.tar.gz && \
    rm interproscan-core-${VERSION}.tar.gz && \
    mv /opt/interproscan-${VERSION} /opt/interproscan
WORKDIR /opt/interproscan
RUN sed -i 's|^temporary\.file\.directory=temp/|temporary.file.directory=/temp/|' interproscan.properties
ENV PATH=/opt/interproscan:$PATH
WORKDIR /workspace
CMD ["/bin/bash"]