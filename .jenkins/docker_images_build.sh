#!/bin/bash

#########################################################################################
# This script is used by jenkins to build the docker images after new Dockerfile merged
# Maintainer: heguofeng<heguofeng@openeuler.sh>
#########################################################################################

set -e

WORKDIR=$(pwd)
IGNORE_DOCKER_LIST="./.jenkins/.ignore"
OWN_BUILD_LIST="./.jenkins/.ownbuild"
APP_NAME_LIST=""
REPOSITORY="openeuler"

## check whether the app name exist in given file
is_app_exist()
{
    local file_name=$1
    local app_name=$2
    local is_exist=$(cat ${WORKDIR}/${file_name} | grep -w  ${app_name})
    if [ "$is_exist"x == ""x ]; then
        echo "no"
    else 
        echo "yes"
    fi
}

## generate the app name list that need to build, ie not ignored by dockerignore file
generate_app_name_list()
{
    for app_name in $(ls -l ${WORKDIR} | grep -v grep | grep ^d |  awk '{print $9}')
    do
        local ret_value=$(is_app_exist ${IGNORE_DOCKER_LIST} ${app_name})
        if [ "${ret_value}" == "no" ]; then
            APP_NAME_LIST="${APP_NAME_LIST} ${app_name}"
            echo "append ${app_name} to APP_NAME_LIST"
        else
            echo "${app_name} is configured to be ignored"
        fi
    done
        
    APP_NAME_LIST=${APP_NAME_LIST}
    echo "docker app names: ${APP_NAME_LIST}"
}

docker_login()
{
    docker login -u $DOCKER_USER -p  $DOCKER_PASSWORD
}

build_app_os()
{
    local app_name=$1
    local app_version=$2
    local platforms="linux/amd64,linux/arm64"
        
    for os_version in $(ls -l ${WORKDIR}/${app_name}/${app_version} | grep -v grep | grep ^d | awk '{print $9}')
    do
        if [[ "$os_version" == "22.03-lts" ]]; then  
            platforms="${platforms},linux/loong64"  
        fi

	##TODO: consider deduplicate the build of the same docker image
        echo "start to build docker image for ${app_name}-${app_version} on openEuler-${os_version}"
        cd ${WORKDIR}/${app_name}/${app_version}/${os_version} && \
	docker buildx build -t "${REPOSITORY}/${app_name}:${app_version}-${os_version}" --platform ${platforms} . --push
    done
}

build_app()
{
    local app_name=$1
    for app_version in $(ls -l  ${WORKDIR}/${app_name} | grep -v README | grep -v grep | grep ^d | awk '{print $9}')
    do
        build_app_os ${app_name} ${app_version}
    done
}

docker_build_push()
{
    for app_name in ${APP_NAME_LIST}
        do
            echo "start to build docker image for ${app_name}"
            local ret_val=$(is_app_exist ${OWN_BUILD_LIST} ${app_name})
            if [ "${ret_val}" == "yes" ]; then
                ##TODO some docker images use thire own build.sh to build
                echo "call ${app_name}'s build.sh to build and push docker images"
            else
                build_app ${app_name}
            fi
            echo "end to build docker image for ${app_name}"
        done
}

## Main
echo "work directory: ${WORKDIR}"
generate_app_name_list
docker_login
docker_build_push

