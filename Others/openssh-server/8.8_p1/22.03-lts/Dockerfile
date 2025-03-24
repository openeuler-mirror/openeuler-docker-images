FROM openeuler/openeuler:22.03-lts
MAINTAINER heguofeng <heguofeng@openeuler.sh>
RUN yum -y update && \
    yum -y install openssh-server && \
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
    sed -i 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config && \
    yum clean all

COPY keygen.sh  /keygen.sh
EXPOSE 2222
