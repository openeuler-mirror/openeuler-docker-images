FROM scratch
ARG TARGETARCH
ADD openEuler-docker-rootfs.$TARGETARCH.tar.xz /
# See more in https://gitee.com/openeuler/cloudnative/issues/I482Q6
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime && \
    yum -y update && yum clean all
CMD ["bash"]
