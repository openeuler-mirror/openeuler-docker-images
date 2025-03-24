ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE}
ARG VERSION=1.7r0

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN yum install -y wget make gcc-g++ findutils gnuplot

RUN wget https://zenodo.org/records/10684609/files/olb-${VERSION}.tgz?download=1 -O /home/olb.tar.gz && \
    tar -xvf /home/olb.tar.gz -C /home && \
    cd  /home/olb-${VERSION} && \
    make -j $(nproc) && \
    rm -rf olb*

WORKDIR /home/olb-${VERSION}

CMD [ "bash" ]