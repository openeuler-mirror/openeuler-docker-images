ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=4.3.5_CE_BP2_HF1
ARG TARGETARCH
ARG OCEANBASE=/opt/oceanbase.tar.gz

COPY download.sh /
RUN yum install -y findutils && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    yum clean all && \
    sh /download.sh ${VERSION/CE_/} ${TARGETARCH} ${OCEANBASE} && \
    mkdir -p /opt/oceanbase/ && \
    tar -zxf $OCEANBASE -C /opt/oceanbase/ --strip-components=1 && \
    cd /opt/oceanbase/bin && \
    sh install.sh && \
    source ~/.oceanbase-all-in-one/bin/env.sh && \
    rm -rf ${OCEANBASE} /opt/oceanbase

CMD ["obd", "--version"]