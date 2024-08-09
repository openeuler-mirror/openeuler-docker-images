# SPDX-License-Identifier: GPL-2.0
ARG BASE=openeuler/openeuler:22.03-lts-sp4
FROM ${BASE}

LABEL name=openeuler-kselftests-virtme-docker

# dependencies for the script
RUN yum update -y && \
	yum upgrade -y && \
	yum install -y \
        make ncurses-devel gcc openssl-devel bc bison byacc automake \
		elfutils-libelf-devel flex git curl tar perl-Digest-SHA qemu-kvm sudo expect \
		python3 python3-pip python3-setuptools file libvirt-daemon-config-network \
		busybox coreutils python3-requests libvirt-client udev \
		iputils ethtool kbd rsync ccache nc \
		ca-certificates gnupg2 net-tools kmod \
		dbus-devel libnl3-devel libibverbs-devel \
		tcpdump \
		pkgconfig libmnl-devel \
		clang clang-tools-extra lld llvm llvm-devel libcap-devel \
		gdb gdb-gdbserver crash dwarves strace trace-cmd \
		iptables ebtables nftables vim psmisc bash-completion less jq \
		gettext libevent-devel libtraceevent-devel newt-devel slang-devel libutempter-devel python3-newt tmux \
		libdwarf-devel binutils-devel numactl-devel libzstd-devel libunwind-devel elfutils-devel python3-devel binutils-devel libbabeltrace-devel systemtap-sdt-devel perl-devel python3-docutils \
		libxml2-devel sqlite-devel gtk3-devel gtk2-devel perl-JSON \
		zstd \
		wget xz lftp cpio uboot-tools \
		cscope \
		bpftrace && \
	yum clean all

# byobu (not to have a dep to iproute2)
ARG BYOBU_URL="https://github.com/dustinkirkland/byobu/archive/refs/tags/6.12.tar.gz"
ARG BYOBU_SUM="abb000331858609dfda9214115705506249f69237625633c80487abe2093dd45  byobu.tar.gz"
RUN cd /opt && \
    curl -L "${BYOBU_URL}" -o byobu.tar.gz && \
    echo "${BYOBU_SUM}" | sha256sum -c && \
    tar xzf byobu.tar.gz && \
    cd byobu-*/ && \
        ./autogen.sh && \
        ./configure --prefix=/usr && \
        make -j"$(nproc)" -l"$(nproc)" && \
        make install

# packetdrill
ARG PACKETDRILL_GIT_URL="https://github.com/multipath-tcp/packetdrill.git"
ARG PACKETDRILL_GIT_BRANCH="mptcp-net-next"
ENV PACKETDRILL_GIT_BRANCH="${PACKETDRILL_GIT_BRANCH}"
RUN cd /opt && \
    git clone "${PACKETDRILL_GIT_URL}" && \
    cd packetdrill && \
        git checkout "${PACKETDRILL_GIT_BRANCH}" && \
        cd gtests/net/packetdrill/ && \
            ./configure && \
            make -j"$(nproc)" -l"$(nproc)" && \
            ln -s /opt/packetdrill/gtests/net/packetdrill/packetdrill \
                  /opt/packetdrill/gtests/net/packetdrill/run_all.py \
                  /usr/sbin/

# Sparse
ARG SPARSE_GIT_URL="git://git.kernel.org/pub/scm/devel/sparse/sparse.git"
ARG SPARSE_GIT_SHA="09411a7a5127516a0741eb1bd8762642fa9197ce" # include a fix for 'unreplaced' issues and llvm 16
RUN cd /opt && \
    git clone "${SPARSE_GIT_URL}" sparse && \
    cd "sparse" && \
        git checkout "${SPARSE_GIT_SHA}" && \
        make -j"$(nproc)" -l"$(nproc)" && \
        make PREFIX=/usr install && \
        cd .. && \
    rm -rf "sparse"

# iproute
ARG IPROUTE2_GIT_URL="git://git.kernel.org/pub/scm/network/iproute2/iproute2.git"
ARG IPROUTE2_GIT_SHA="v6.10.0"
RUN cd /opt && \
    git clone "${IPROUTE2_GIT_URL}" iproute2 && \
    cd iproute2 && \
        git checkout "${IPROUTE2_GIT_SHA}" && \
        ./configure && \
        make -j"$(nproc)" -l"$(nproc)" && \
        make install

# Virtme NG
ARG VERSION=1.27
RUN pip3 install virtme-ng=="${VERSION}"

# to quickly shutdown the VM and more
RUN for i in /usr/lib/klibc/bin/*; do \
    type "$(basename "${i}")" >/dev/null 2>&1 || ln -sv "${i}" /usr/sbin/; \
    done

# CCache for quicker builds with default colours
# Note: use 'ccache -M xG' to increase max size, default is 5GB
ENV PATH /usr/lib/ccache:${PATH}
ENV CCACHE_COMPRESS true
ENV KBUILD_BUILD_TIMESTAMP "0"
ENV GCC_COLORS error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01

COPY entrypoint.sh tap2json.py /

ENTRYPOINT ["/entrypoint.sh"]