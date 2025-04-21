ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=4.1.7
ENV SIEGE_URL=http://download.joedog.org/siege/siege-${VERSION}.tar.gz

RUN yum install -y make openssl-devel zlib-devel libtool && \
    yum clean all

WORKDIR /siege
RUN curl -fSL -o siege.tar.gz ${SIEGE_URL} && \
    tar -xzf siege.tar.gz --strip-components=1 && \
    rm -rf siege.tar.gz

RUN sed -i.orig doc/siegerc.in -e 's/^# logfile = *$/logfile = ${HOME}\/siege.log/' && \
    ./configure --sysconfdir=/etc/siege && \
    make -j$nproc && \
    make install

CMD ["/usr/local/bin/siege"]