ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2.9.0

RUN dnf install -y java-17-openjdk-headless wget && \
    dnf clean all

RUN wget -q https://downloads.apache.org/ranger/${VERSION}/services/admin/ranger-${VERSION}-admin.tar.gz -O /tmp/ranger-admin.tar.gz \
    && tar -zxf /tmp/ranger-admin.tar.gz -C /opt \
    && rm -f /tmp/ranger-admin.tar.gz

WORKDIR /opt/ranger-${VERSION}-admin

EXPOSE 6080

CMD ["bash", "-c", "echo 'Ranger Admin: configure database via setup.sh, then start with ews/ranger-admin-services.sh start'; exec bash"]
