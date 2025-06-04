ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=5.2.1

RUN yum install -y git make gcc g++ maven wget && \
    wget https://repo.huaweicloud.com/repository/maven/huaweicloudsdk/org/pentaho/pentaho-aggdesigner-algorithm/5.1.5-jhyde/pentaho-aggdesigner-algorithm-5.1.5-jhyde.jar && \
    mvn install:install-file \
      -Dfile=pentaho-aggdesigner-algorithm-5.1.5-jhyde.jar \
      -DgroupId=org.pentaho \
      -DartifactId=pentaho-aggdesigner-algorithm \
      -Dversion=5.1.5-jhyde \
      -Dpackaging=jar

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
RUN git clone -b release-${VERSION} https://github.com/apache/oozie.git && \
    cd oozie/bin && \
    ./mkdistro.sh -DskipTests