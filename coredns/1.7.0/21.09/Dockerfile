FROM openeuler/openeuler:21.09

RUN yum -y update && yum clean all
RUN yum -y install coredns ca-certificates && yum clean all

EXPOSE 53 53/udp
ENTRYPOINT ["/sbin/coredns"]
