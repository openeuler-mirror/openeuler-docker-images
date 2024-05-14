ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG ATS_HOME=trafficserver-8.0.5
ARG ATS_PACKAGE=8.0.5.tar.gz
ARG PATCH_AME=95a535b6b8bf459dfe95e3bfebc4cc8896ff42a1.patch

RUN yum -y install autoconf automake libtool make ncurses-devel tcl-devel pcre pcre-devel initscripts wget patch diffutils python gcc gcc-c++ openssl openssl-devel && \
    mkdir /tmp/ats && cd /tmp/ats/ && wget https://github.com/apache/trafficserver/archive/${ATS_PACKAGE} --no-check-certificate && \
    tar -xvf ${ATS_PACKAGE} && cd ${ATS_HOME} && \
    if [ "$TARGETARCH" = "arm64" ]; then \
      sed -i "s/\ -mcx16//g" `find -name Makefile`; \      
      wget https://github.com/apache/trafficserver/commit/${PATCH_AME}; \
      patch -p1 < ${PATCH_AME}; \
    fi && \
    autoreconf -if && ./configure --prefix=/opt/trafficServer CC=/usr/bin/gcc CXX=/usr/bin/g++ --with-ncurses && \
    if [ "$TARGETARCH" = "arm64" ]; then \
      sed -i "s/\ -mcx16//g" `find -name Makefile`; \      
    fi && \
    make clean && make -j "$(nproc)"  && make install && \
    rm -rf /tmp/ats

RUN ln -s /etc/openEuler-release /etc/redhat-release

ENV PATH=/opt/trafficServer/bin/:$PATH

EXPOSE 8080

CMD ["trafficserver", "start"]