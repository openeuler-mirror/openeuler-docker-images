ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=3.0.0

RUN dnf update -y \
    && dnf install -y glib2-devel libxml2-devel libxslt-devel gnutls-devel pam-devel libaio-devel  \
    sqlite-devel ncurses-devel libuuid-devel systemd-devel krb5-devel nss-devel nspr-devel  \
    pciutils-devel popt-devel git gcc make gettext-devel libtool autoconf automake pkgconfig  \
    libtool-devel bzip2-devel libqb-devel dbus-devel corosync corosync-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN git clone -b Pacemaker-${VERSION} --depth 1 https://github.com/ClusterLabs/pacemaker.git \
    && cd pacemaker \
    && ./autogen.sh \
    && ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
    && make -j $(nproc) \
    && make install

CMD [" /usr/sbin/pacemakerd", "--help"]