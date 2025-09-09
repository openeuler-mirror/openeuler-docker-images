ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}

ARG VERSION=3.2.44

RUN yum install -y wget java-1.8.0-openjdk

RUN mkdir /orientdb \
    && wget -O orientdb-community.tar.gz https://repo1.maven.org/maven2/com/orientechnologies/orientdb-community/${VERSION}/orientdb-community-${VERSION}.tar.gz \
    && tar -xvzf orientdb-community.tar.gz -C /orientdb --strip-components=1 \
    && rm -f orientdb-community.tar.gz

WORKDIR /orientdb

ENV PATH /orientdb/bin:$PATH

VOLUME ["/orientdb/backup", "/orientdb/databases", "/orientdb/config"]

EXPOSE 2480

CMD ["server.sh"]