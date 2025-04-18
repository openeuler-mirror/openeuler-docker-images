ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}


ARG VERSION="2.9.4"
ENV ALLUXIO_HOME=/opt/alluxio \
    ALLUXIO_CONF_DIR=/etc/alluxio \
    ALLUXIO_LOGS_DIR=/var/log/alluxio

COPY entrypoint.sh /opt/docker/bin/
COPY libexec/ /opt/docker/libexec/
COPY conf/ ${ALLUXIO_CONF_DIR}

WORKDIR ${ALLUXIO_HOME}
RUN yum install -y java-1.8.0-openjdk-devel hostname
RUN curl -fSL -o /tmp/alluxio.tar.gz https://downloads.alluxio.io/downloads/files/${VERSION}/alluxio-${VERSION}-bin.tar.gz
RUN tar -zxf /tmp/alluxio.tar.gz --strip-components=1 && \
    chown -R root:root ${ALLUXIO_HOME} && \
    mkdir -p ${ALLUXIO_CONF_DIR} && \
    mkdir -p ${ALLUXIO_LOGS_DIR} && \
    chmod 755 /opt/docker/bin/entrypoint.sh

ENV PATH=$PATH:${ALLUXIO_HOME}/bin

ENTRYPOINT ["/opt/docker/bin/entrypoint.sh"]
CMD ["bash"]