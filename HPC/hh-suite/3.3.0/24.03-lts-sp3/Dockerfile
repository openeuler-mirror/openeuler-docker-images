ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM $BASE
ARG VERSION=3.3.0
ARG TAG=v${VERSION}
RUN yum install -y \
        git gcc gcc-c++ cmake make which && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${TAG} https://github.com/soedinglab/hh-suite.git /opt/hh-suite && \
    mkdir -p /opt/hh-suite/build && \
    cd /opt/hh-suite/build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local/hh-suite .. && \
    make -j 4 && \
    make install && \
    rm -rf /opt/hh-suite/build /opt/hh-suite/.git
ENV HHLIB=/usr/local/hh-suite
ENV PATH=/usr/local/hh-suite/bin:/usr/local/hh-suite/scripts:${PATH}
WORKDIR /workspace
CMD ["/bin/bash"]