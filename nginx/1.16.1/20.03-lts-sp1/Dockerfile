FROM openeuler/openeuler:20.03-lts-sp1
MAINTAINER gaohechao <suisuisuisuixin@gmail.com>
RUN yum -y update \
    && yum -y install nginx \
    && yum clean all
ENTRYPOINT ["nginx", "-g", "daemon off;"]
