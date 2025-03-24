FROM openeuler/openeuler:20.03-lts-sp1

MAINTAINER Yikun Jiang <yikunkero@gmail.org>

RUN yum -y update && yum clean all
RUN yum -y install nodejs npm && yum clean all

CMD [ "node" ]
