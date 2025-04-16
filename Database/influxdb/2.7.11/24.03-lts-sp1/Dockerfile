ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=2.7.11
ENV INFLUXDB_URL=https://dl.influxdata.com/influxdb/releases/influxdb2-${VERSION}_linux_${TARGETARCH}.tar.gz

WORKDIR /influxdb
RUN curl -fSL -o influxdb.tar.gz ${INFLUXDB_URL} && \
    tar -zxf influxdb.tar.gz -C /influxdb --strip-components=1 && \
    rm influxdb.tar.gz

RUN cp -r etc/* /etc/ && \
    cp usr/bin/* /usr/bin/ && \
    cp -r usr/lib/* /usr/lib/ && \
    cp -r usr/share/* /usr/share/ && \
    chmod 755 /usr/bin/influxd

RUN rm -rf /influxdb
CMD ["/usr/bin/influxd"]