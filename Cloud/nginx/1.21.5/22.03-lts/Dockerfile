FROM openeuler/openeuler:22.03-lts
MAINTAINER heguofeng <heguofeng@openeuler.sh>
RUN yum -y update \
    && yum -y install nginx \
    && yum clean all
ENTRYPOINT ["nginx", "-g", "daemon off;"]
