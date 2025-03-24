FROM openeuler/openeuler-binary-nova-base:rocky-20.03-lts-sp2

RUN usermod --append --home /var/lib/nova --groups kolla nova \
    && chsh --shell /bin/bash nova \
    && mkdir -p /var/lib/nova \
    && chown -R 42436:42436 /var/lib/nova

RUN yum -y install openssh-server && yum clean all && rm -rf /var/cache/yum

RUN sed -ri 's/session(\s+)required(\s+)pam_loginuid.so/session\1optional\2pam_loginuid.so/' /etc/pam.d/sshd

COPY extend_start.sh /usr/local/bin/kolla_extend_start
RUN chmod 755 /usr/local/bin/kolla_extend_start

