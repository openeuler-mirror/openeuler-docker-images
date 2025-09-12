ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=3.4.2
ENV INFLUXDB_URL=https://dl.influxdata.com/influxdb/releases/influxdb3-core-${VERSION}_linux_${TARGETARCH}.tar.gz

WORKDIR /influxdb
RUN curl -fSL -o influxdb.tar.gz ${INFLUXDB_URL} && \
    tar -zxf influxdb.tar.gz -C /influxdb --strip-components=1 && \
    rm influxdb.tar.gz

RUN ln -sf /influxdb/influxdb3 /usr/bin/influxdb3

CMD ["/usr/bin/influxdb3", "serve", "--node-id", "host01", "--object-store", "file", "--data-dir", "~/.influxdb3" ]