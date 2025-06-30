ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=2.1.3

# install -y openjdk
COPY ssh/* /etc/ssh/
RUN yum install -y java-11-openjdk-devel openssh openssh-clients sudo hostname && \
    yum clean all && \
    ssh-keygen -A && ssh-keygen -t ed25519 -P '' -f /root/.ssh/id_ed25519 && \
    cat /root/.ssh/id_ed25519.pub > /root/.ssh/authorized_keys && \
    chmod 0400 /root/.ssh/authorized_keys
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk

# install zookeeper
RUN curl -fSL -o zookeeper.tar.gz https://archive.apache.org/dist/zookeeper/zookeeper-3.9.3/apache-zookeeper-3.9.3-bin.tar.gz; \
    mkdir -p /usr/local/zookeeper && \
    tar -zxf zookeeper.tar.gz -C /usr/local/zookeeper --strip-components=1 && \
    rm -rf zookeeper.tar.gz && \
    cd /usr/local/zookeeper/conf && \
    touch zoo.cfg && echo -e 'tickTime=2000\ndataDir=/var/lib/zookeeper\nclientPort=2181\nadmin.serverPort=8081' > zoo.cfg
ENV PATH=$PATH:/usr/local/zookeeper/bin
ENV ZOOKEEPER_HOME=/usr/local/zookeeper/

# install dependent hadoop
ARG HADOOP_VERSION=3.4.1
RUN curl -fSL -o hadoop.tar.gz https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz; \
    mkdir -p /usr/local/hadoop && \
    tar -zxf hadoop.tar.gz -C /usr/local/hadoop --strip-components=1 && \
    rm -rf hadoop.tar.gz
ENV PATH=$PATH:/usr/local/hadoop/bin
ENV HADOOP_HOME=/usr/local/hadoop/
COPY hadoop/* $HADOOP_HOME/etc/hadoop/

# install accumulo
RUN curl -fSL -o accumulo.tar.gz https://dlcdn.apache.org/accumulo/${VERSION}/accumulo-${VERSION}-bin.tar.gz; \
    mkdir -p /usr/local/accumulo && \
    tar -zxf accumulo.tar.gz -C /usr/local/accumulo --strip-components=1 && \
    rm -rf accumulo.tar.gz
ENV PATH=$PATH:/usr/local/accumulo/bin
ENV ACCUMULO_HOME=/usr/local/accumulo/
COPY properties/* $ACCUMULO_HOME/conf/

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["init", "--upload-accumulo-props"]