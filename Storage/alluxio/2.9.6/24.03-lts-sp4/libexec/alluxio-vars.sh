#!/usr/bin/env bash
# The directory where log files are stored. (Default: ${ALLUXIO_HOME}/logs).
# ALLUXIO_LOGS_DIR

# The directory where a worker stores in-memory data. (Default: /mnt/ramdisk).
# E.g. On linux,  /mnt/ramdisk for ramdisk, /dev/shm for tmpFS; on MacOS, /Volumes/ramdisk for ramdisk
export ALLUXIO_RAM_FOLDER=${ALLUXIO_RAM_FOLDER=/mnt/ramdisk}

# Address of the under filesystem address. (Default: ${ALLUXIO_HOME}/underFSStorage)
# E.g. "/my/local/path" to use local fs, "hdfs://localhost:9000/alluxio" to use a local hdfs
export ALLUXIO_UNDERFS_ADDRESS=${ALLUXIO_UNDERFS_ADDRESS=${ALLUXIO_HOME}/underFSStorage}

# How much memory to use per worker. (Default: 1GB)
# E.g. "1000MB", "2GB"
export ALLUXIO_WORKER_MEMORY_SIZE=${ALLUXIO_WORKER_MEMORY_SIZE=1GB}

# Config properties set for Alluxio master, worker and shell. (Default: "")
# E.g. "-Dalluxio.master.port=39999"
# ALLUXIO_JAVA_OPTS

# Config properties set for Alluxio master daemon. (Default: "")
# E.g. "-Dalluxio.master.port=39999"
# ALLUXIO_MASTER_JAVA_OPTS

# Config properties set for Alluxio worker daemon. (Default: "")
# E.g. "-Dalluxio.worker.port=49999" to set worker port, "-Xms2048M -Xmx2048M" to limit the heap size of worker.
# ALLUXIO_WORKER_JAVA_OPTS

# Config properties set for Alluxio shell. (Default: "")
# E.g. "-Dalluxio.user.file.writetype.default=CACHE_THROUGH"
# ALLUXIO_USER_JAVA_OPTS


# Hostname of the master.
export ALLUXIO_MASTER_HOSTNAME=${ALLUXIO_MASTER_HOSTNAME=localhost}
export ALLUXIO_MASTER_PORT=${ALLUXIO_MASTER_PORT=19998}
export ALLUXIO_MASTER_WEB_PORT=${ALLUXIO_MASTER_WEB_PORT=19999}
export ALLUXIO_MASTER_JOURNAL_FOLDER=${ALLUXIO_MASTER_JOURNAL_FOLDER=/mnt/journal}

# Hostname of the worker
export ALLUXIO_WORKER_HOSTNAME=${ALLUXIO_WORKER_HOSTNAME=$(hostname -f)}
export ALLUXIO_WORKER_PORT=${ALLUXIO_WORKER_PORT=29998}
export ALLUXIO_WORKER_WEB_PORT=${ALLUXIO_WORKER_WEB_PORT=30000}
export ALLUXIO_WORKER_DATA_PORT=${ALLUXIO_WORKER_DATA_PORT=29999}
export ALLUXIO_WORKER_FOLDER=${ALLUXIO_WORKER_FOLDER=alluxio}

# S3 properties
export S3_PROXY_HOST=${S3_PROXY_HOST}
export S3_PROXY_PORT=${S3_PROXY_PORT=-1}
export S3_PROXY_USE_HTTPS=${S3_PROXY_USE_HTTPS=false}
export S3_ENDPOINT=${S3_ENDPOINT}
export S3_ENDPOINT_HTTP_PORT=${S3_ENDPOINT_HTTP_PORT=80}
export S3_ENDPOINT_HTTPS_PORT=${S3_ENDPOINT_HTTPS_PORT=443}

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}