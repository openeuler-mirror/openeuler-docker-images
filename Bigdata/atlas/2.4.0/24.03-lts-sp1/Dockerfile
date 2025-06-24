ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=2.4.0

RUN yum install -y git maven java-17-openjdk-devel make gcc g++

RUN git clone -b release-${VERSION} https://github.com/apache/atlas.git

WORKDIR /atlas
ENV MAVEN_OPTS="-Xms8g -Xmx8g"
RUN mvn clean install -DskipTests -T 2C
RUN mvn clean package -Pdist -DskipTests

CMD ["bash"]