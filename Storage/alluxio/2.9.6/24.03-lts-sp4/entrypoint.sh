#!/bin/bash
set -eo pipefail

# Setup environment
source /opt/docker/libexec/alluxio-init.sh


get_env() {
    BIN=$ALLUXIO_HOME/bin
    ALLUXIO_LIBEXEC_DIR=${ALLUXIO_LIBEXEC_DIR:-$ALLUXIO_HOME/libexec}
    . ${ALLUXIO_LIBEXEC_DIR}/alluxio-config.sh
    CLASSPATH=${ALLUXIO_CLIENT_CLASSPATH}
}


start_worker() {
    CLASSPATH=${ALLUXIO_SERVER_CLASSPATH}

    alluxio-mount.sh Mount
    MOUNT_FAILED=$?

    if  [ ${MOUNT_FAILED} -ne 0 ] ; then
        echo "Mount failed, not starting worker" >&2
        exit 1
    fi

    if [[ -z ${ALLUXIO_WORKER_JAVA_OPTS} ]]; then
        ALLUXIO_WORKER_JAVA_OPTS=${ALLUXIO_JAVA_OPTS}
    fi

    echo "Starting worker @ $(hostname -f)"
    ${JAVA} -cp ${CLASSPATH} ${ALLUXIO_WORKER_JAVA_OPTS} alluxio.worker.AlluxioWorker 2>&1
}


start_master() {
    CLASSPATH=${ALLUXIO_SERVER_CLASSPATH}

    if [[ -z ${ALLUXIO_MASTER_JAVA_OPTS} ]]; then
        ALLUXIO_MASTER_JAVA_OPTS=${ALLUXIO_JAVA_OPTS}
    fi

    if [ ! -d ${ALLUXIO_MASTER_JOURNAL_FOLDER}/BlockMaster ]; then
        mkdir -p ${ALLUXIO_MASTER_JOURNAL_FOLDER}
        alluxio format
    fi

    echo "Starting master @ $(hostname -f)"
    ${JAVA} -cp ${CLASSPATH} ${ALLUXIO_MASTER_JAVA_OPTS} alluxio.master.AlluxioMaster 2>&1
}


start_proxy() {
    CLASSPATH=${ALLUXIO_SERVER_CLASSPATH}

    if [[ -z ${ALLUXIO_PROXY_JAVA_OPTS} ]]; then
        ALLUXIO_PROXY_JAVA_OPTS=${ALLUXIO_JAVA_OPTS}
    fi

    echo "Starting proxy @ $(hostname -f)"
    ${JAVA} -cp ${CLASSPATH} ${ALLUXIO_PROXY_JAVA_OPTS} alluxio.proxy.AlluxioProxy  2>&1
}


main() {
  # get environment
  get_env

  # ensure log/data dirs
  #ensure_dirs

  case "$1" in
    master)
      start_master
      ;;
    proxy)
      start_proxy
      ;;
    worker)
      start_worker
      ;;
    *)
      exec $@
      exit $?
      ;;
  esac
}

main "$@"