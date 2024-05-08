#!/bin/bash

set -ex;

input_version=$1;
versions=${input_version:-"21.09"};
calico_version="3.22.0";
SHA256_3_22_0="204c12a6394784861b38ad1951ef720f24dff53b5b8c56ced7b701257e4bba2b  v3.22.0.tar.gz"
component_list="cni kube-controllers node pod2daemon-flexvol";

SITE="docker.io";
USER="hollowman6";

cni_DIR="cni-plugin";
kube_controllers_DIR="kube-controllers";
node_DIR="node";
pod2daemon_flexvol_DIR="pod2daemon";

for VERSION in $calico_version; do
    for OEVERSION in $versions; do
        mkdir -p $OEVERSION;
        cd $OEVERSION;
        # Download
        if [ ! -f "v$VERSION.tar.gz" ]; then
            git clone --depth=1 https://gitee.com/src-openeuler/calico.git;
            cp calico/v$VERSION.tar.gz .;
            rm -rf calico;
        fi
        # Validate sha256sum everytime
        if [ "$(eval echo \"\$SHA256_`echo ${VERSION} | tr . _`\")" = "$(shasum --algorithm 256 v$VERSION.tar.gz)" ]; then
            echo "v$VERSION.tar.gz is valid";
        else
            echo "v$VERSION.tar.gz is invalid";
            continue;
        fi
        # Extract
        rm -rf ./calico-$VERSION;
        tar -xf v$VERSION.tar.gz;
        cd calico-$VERSION;
        cp -arf ../../cni/$VERSION/$OEVERSION/* cni-plugin/;
        cp -arf ../../kube-controllers/$VERSION/$OEVERSION/* kube-controllers/;
        cp -arf ../../node/$VERSION/$OEVERSION/* node/;
        sed -i 's#TARGET_PLATFORM=--platform=linux/arm64/v8#TARGET_PLATFORM=--platform=arm64#g' node/Makefile;
        cp -arf ../../pod2daemon-flexvol/$VERSION/$OEVERSION/* pod2daemon/;
        # Make calico recognize the version
        git init; git add -A .; git -c user.name='jiangsonglin2' -c user.email='songlin@isrc.iscas.ac.cn' commit -m "v$VERSION"; git tag "v$VERSION";
        # Prepare for building
        for COMP in $component_list; do
            eval "cd \$`echo \"$COMP\" | tr - _`_DIR";
            ARCH="amd64";
            if [ "aarch64" = "`arch`" ]; then
                ARCH="arm64";
            elif [ ! "x86_64" = "`arch`" ]; then
                echo "Unsupported architecture `arch`";
                exit 1;
            fi;
            IMAGE_ID=$SITE/$USER/calico-${COMP}-openeuler:${VERSION}-${OEVERSION}
            make sub-image-${ARCH};
            docker tag calico/${COMP}:latest-${ARCH} ${IMAGE_ID}-${ARCH};
            docker push ${IMAGE_ID}-${ARCH};
            cd ..;
        done;
        cd ../..;
    done;
done;

