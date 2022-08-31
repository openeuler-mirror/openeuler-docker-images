FROM openeuler/openeuler:22.03-lts
MAINTAINER heguofeng <heguofeng@openeuler.sh>
RUN yum -y update \
    && yum -y install python python-pip \
    && yum clean all
CMD ["python"]
