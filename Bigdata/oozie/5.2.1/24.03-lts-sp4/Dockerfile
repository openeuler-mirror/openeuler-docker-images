ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE

ARG VERSION=5.2.1

RUN yum install -y git make gcc g++ maven wget && \
    wget https://repo.huaweicloud.com/repository/maven/huaweicloudsdk/org/pentaho/pentaho-aggdesigner-algorithm/5.1.5-jhyde/pentaho-aggdesigner-algorithm-5.1.5-jhyde.jar && \
    mvn install:install-file \
      -Dfile=pentaho-aggdesigner-algorithm-5.1.5-jhyde.jar \
      -DgroupId=org.pentaho \
      -DartifactId=pentaho-aggdesigner-algorithm \
      -Dversion=5.1.5-jhyde \
      -Dpackaging=jar && \
    wget https://repo1.maven.org/maven2/org/glassfish/jaxb/txw2/2.3.1/txw2-2.3.1.jar && \
    mvn install:install-file \
      -Dfile=txw2-2.3.1.jar \
      -DgroupId=org.glassfish.jaxb \
      -DartifactId=txw2 \
      -Dversion=2.4.0-b180608.0325 \
      -Dpackaging=jar

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
RUN git clone -b release-${VERSION} https://github.com/apache/oozie.git && \
    mkdir -p /root/.m2 && \
    printf '<?xml version="1.0" encoding="UTF-8"?>\n<settings>\n  <mirrors>\n    <mirror>\n      <id>block-java-net</id>\n      <mirrorOf>releases.java.net</mirrorOf>\n      <url>https://repo1.maven.org/maven2</url>\n    </mirror>\n  </mirrors>\n</settings>\n' > /root/.m2/settings.xml && \
    cd oozie/bin && \
    ./mkdistro.sh -DskipTests