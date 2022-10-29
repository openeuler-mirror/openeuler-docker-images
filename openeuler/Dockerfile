FROM scratch
ARG TARGETARCH
ADD openEuler-docker-rootfs.$TARGETARCH.tar.xz /
# See more in https://gitee.com/openeuler/cloudnative/issues/I482Q6
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
    sed -i "s/TMOUT=300/TMOUT=0/g" /etc/bashrc && \
    yum -y update && yum clean all
CMD ["bash"]
