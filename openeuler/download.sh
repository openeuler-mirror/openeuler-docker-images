#!/bin/bash

set -ex

archs="x86_64 aarch64"
versions="20.03-lts 20.03-lts-sp1 20.03-lts-sp2 20.09 21.03"
for ARCH in $archs ;
do
    if [[ "$ARCH" = "aarch64" ]];then
        DOCKER_ARCH=arm64
    elif [[ "$ARCH" = "x86_64" ]];then
        DOCKER_ARCH=amd64
    else
        echo "Unknow arch: "$ARCH
        exit 1
    fi
    for VERSION in $versions ;
    do
        mkdir -p $VERSION
        # Download
        cd $VERSION
        if [ ! -f "openEuler-docker.$ARCH.tar.xz" ]; then
            wget https://repo.openeuler.org/openEuler-$VERSION/docker_img/$ARCH/openEuler-docker.$ARCH.tar.xz
        fi
        # Re-download and validate sha256sum everytime
        rm -f openEuler-docker.$ARCH.tar.xz.sha256sum
        wget https://repo.openeuler.org/openEuler-$VERSION/docker_img/$ARCH/openEuler-docker.$ARCH.tar.xz.sha256sum
        shasum -c openEuler-docker.$ARCH.tar.xz.sha256sum
        # Extract rootfs
        if [ ! -f "openEuler-docker-rootfs.$DOCKER_ARCH.tar.xz" ]; then
            tar -xf openEuler-docker.$ARCH.tar.xz --wildcards "*.tar" --exclude "layer.tar"
            ROOT_FS=`ls | xargs -n1 | grep -v openEuler |grep *.tar`
            mv $ROOT_FS openEuler-docker-rootfs.$DOCKER_ARCH.tar
            xz -z openEuler-docker-rootfs.$DOCKER_ARCH.tar
        fi
        cp -f ../Dockerfile ./
        cd ..
    done
done

