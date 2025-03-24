#!/bin/bash

DEPEND_MAP=(cron,multipathd,haproxy,dnsmasq,chrony,mariadb,rabbitmq,memcached,keepalived,kolla-toolbox,nova-libvirt,openstack-base,prometheus-base:base \
            ironic-base,nova-base,neutron-base,cinder-base,glance-base,keystone-base,novajoin-base,trove-base,horizon,ironic-inspector:openstack-base \
            ironic-conductor,ironic-pxe,ironic-api:ironic-base \
            nova-compute,nova-consoleauth,nova-serialproxy,nova-compute-ironic,nova-novncproxy,nova-spicehtml5proxy,nova-placement-api,nova-api,nova-scheduler,nova-ssh,nova-conductor:nova-base \
            neutron-openvswitch-agent,neutron-linuxbridge-agent,neutron-metering-agent,neutron-l3-agent,neutron-sriov-agent,neutron-metadata-agent,neutron-dhcp-agent,neutron-server,neutron-sfc-agent,ironic-neutron-agent:neutron-base \
            cinder-api,cinder-backup,cinder-volume,cinder-scheduler:cinder-base \
            glance-api,glance-registry:glance-base \
            keystone,keystone-fernet,keystone-ssh:keystone-base \
            novajoin-notifier,novajoin-server:novajoin-base \
            trove-guestagent,trove-taskmanager,trove-conductor,trove-api:trove-base \
            prometheus-haproxy-exporter:prometheus-base)

function findInternal()
{
    [[ $# -ne 1 ]] && return 1

    local ANS
    local ARRAY=(${1//,/ })

    for i in ${ARRAY[@]}; do
        for j in ${DEPEND_MAP[@]}; do
            [[ $i == ${j#*:} ]] && ANS=$ANS,${j%:*}
        done
    done

    echo $ANS

    return 0
}

function findDepList()
{
    [[ $# -ne 1 ]] && return 1

    local ANS=${1}
    local ARRAY=${1}

    while true; do
        ARRAY=$(findInternal $ARRAY)
        ANS=$ANS,$ARRAY
        [[ -z $ARRAY ]] && echo $ANS && return 0
    done
}

OS_VERSOIN=20.03-lts-sp2

VERSION=$1
BASE=${2:-"base"}

DEPLIST=($(findDepList $BASE | sed "s/,/ /g"))
for i in ${DEPLIST[@]}
do
    path=$(find $VERSION -name "Dockerfile" | grep -E "\/$i\/Dockerfile$" | sed "s/Dockerfile//g")
    pushd $path &>/dev/null
    docker buildx build -t "openeuler/openeuler-binary-$i:$VERSION-$OS_VERSOIN" --platform linux/amd64,linux/arm64 . --push
    [[ $? -ne 0 ]] && echo "docker buildx failed in `pwd`" && exit 1
    popd &>/dev/null
done

exit 0
