FROM openeuler/openeuler-binary-base:rocky-20.03-lts-sp2

RUN usermod --append --home /var/lib/nova --groups kolla nova \
    && usermod --append --groups qemu nova \
    && mkdir -p /var/lib/nova \
    && chown -R 42436:42436 /var/lib/nova

RUN yum -y install ceph-common cyrus-sasl-scram libguestfs libvirt-client libvirt-daemon libvirt-daemon-config-nwfilter libvirt-daemon-driver-nwfilter openvswitch qemu-block-rbd qemu edk2-aarch64 && yum clean all && rm -rf /var/cache/yum

RUN mkdir -p /usr/share/AAVMF \
    && ln -s /usr/share/edk2/aarch64/QEMU_EFI-pflash.raw /usr/share/AAVMF/AAVMF_CODE.fd \
    && ln -s /usr/share/edk2/aarch64/vars-template-pflash.raw /usr/share/AAVMF/AAVMF_VARS.fd 

COPY extend_start.sh /usr/local/bin/kolla_extend_start
RUN chmod 755 /usr/local/bin/kolla_extend_start

