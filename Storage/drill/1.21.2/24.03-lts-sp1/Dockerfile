ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=1.21.2


ARG PACKAGE=apache-drill-${VERSION}.tar.gz
ARG PACKAGE_RUL=https://dlcdn.apache.org/drill/${VERSION}/${PACKAGE}

ENV DRILL_HEAP=900M
ENV ZOOKEEPER_HOST=zookeeper
ENV PATH $PATH:/apache-drill/bin:/zookeeper/bin

WORKDIR /
RUN dnf install -y java-1.8.0-openjdk-devel supervisor which && \
    yum clean all && \
    mkdir -p /etc/supervisor.d

RUN curl -fSL -o "${PACKAGE}" "$PACKAGE_RUL" && \
    tar zxf "${PACKAGE}" && \
    test -d "apache-drill-${VERSION}" && \
    rm -fv "${PACKAGE}" && \
    ln -sv "apache-drill-${VERSION}" apache-drill

COPY entrypoint.sh /
COPY drill.ini /etc/supervisor.d/
RUN sed -i -e "s/-Xms1G/-Xms\$DRILL_MAX_HEAP/" apache-drill/conf/drill-env.sh && \
    sed -i -e "s/^DRILL_MAX_HEAP=.*/DRILL_MAX_HEAP=\"${DRILL_HEAP}\"/" apache-drill/conf/drill-env.sh && \
    sed -i -e "s/^DRILL_HEAP=.*/DRILL_HEAP=\"${DRILL_HEAP}\"/" apache-drill/conf/drill-env.sh && \
    sed -i -e "s/^\([[:space:]]*\)zk.connect:.*/\\1zk.connect: \"${ZOOKEEPER_HOST}\"/" apache-drill/conf/drill-override.conf && \
    chmod 755 /entrypoint.sh



EXPOSE 8047

CMD ["/entrypoint.sh"]