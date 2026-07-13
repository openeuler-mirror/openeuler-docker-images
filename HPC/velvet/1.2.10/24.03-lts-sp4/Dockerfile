ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
ARG TAG=v1.2.10
RUN yum install -y \
        gcc make git zlib-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone -b ${TAG} https://github.com/dzerbino/velvet.git /velvet
WORKDIR /velvet
RUN sed -i 's/^CFLAGS = -Wall -m64$/CFLAGS = -Wall/' Makefile && \
    make MAXKMERLENGTH=127 && \
    cp velveth velvetg /usr/local/bin/ && \
    cd / && rm -rf /velvet
WORKDIR /workspace
CMD ["/bin/bash"]