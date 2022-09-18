FROM openeuler/openeuler-binary-base:rocky-20.03-lts-sp2

ARG TARGETARCH

RUN usermod --append --home /var/lib/nova --groups kolla nova \
    && usermod --append --groups qemu nova \
    && mkdir -p /var/lib/nova \
    && chown -R 42436:42436 /var/lib/nova

RUN yum -y install ceph-common cyrus-sasl-scram libguestfs libvirt-client libvirt-daemon libvirt-daemon-config-nwfilter libvirt-daemon-driver-nwfilter openvswitch qemu-block-rbd qemu && yum clean all && rm -rf /var/cache/yum

RUN if [[ "${TARGETARCH}" =~ arm ]] ; then yum -y install edk2-aarch64 ; else yum -y install edk2-ovmf ; fi

RUN if [[ "${TARGETARCH}" =~ arm ]] ; then mkdir -p /usr/share/AAVMF && ln -s /usr/share/edk2/aarch64/QEMU_EFI-pflash.raw /usr/share/AAVMF/AAVMF_CODE.fd && ln -s /usr/share/edk2/aarch64/vars-template-pflash.raw /usr/share/AAVMF/AAVMF_VARS.fd ; else mkdir -p /usr/share/OVMF && ln -s /usr/share/edk2/ovmf/OVMF_CODE.fd /usr/share/OVMF/OVMF_CODE.fd && ln -s /usr/share/edk2/ovmf/OVMF_VARS.fd /usr/share/OVMF/OVMF_VARS.fd ; fi

COPY extend_start.sh /usr/local/bin/kolla_extend_start
RUN chmod 755 /usr/local/bin/kolla_extend_start

