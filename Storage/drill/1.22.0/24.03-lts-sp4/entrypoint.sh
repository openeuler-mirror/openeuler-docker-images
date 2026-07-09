#!/usr/bin/env bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

export JAVA_HOME="${JAVA_HOME:-/usr}"
export DRILL_HEAP="${DRILL_HEAP:-900M}"
export ZOOKEEPER_HOST="${ZOOKEEPER_HOST:-zookeeper}"

sed -i -e "s/-Xms1G/-Xms\$DRILL_MAX_HEAP/" apache-drill/conf/drill-env.sh
sed -i -e "s/^DRILL_MAX_HEAP=.*/DRILL_MAX_HEAP=\"${DRILL_HEAP}\"/" apache-drill/conf/drill-env.sh

sed -i -e "s/^DRILL_HEAP=.*/DRILL_HEAP=\"${DRILL_HEAP}\"/" apache-drill/conf/drill-env.sh
sed -i -e "s/^\\([[:space:]]*\\)zk.connect:.*/\\1zk.connect: \"${ZOOKEEPER_HOST}\"/" apache-drill/conf/drill-override.conf

if [ -t 0 ]; then
    sqlline -u jdbc:drill:zk=local
else
    echo "
Running non-interactively, will not open Apache Drill SQL shell

For Apache Drill shell start this image with 'docker run -t -i' switches

Otherwise you will need to have a separate ZooKeeper container linked (one is available from harisekhon/zookeeper) and specify:

docker run -e ZOOKEEPER_HOST=<host>:2181 supervisord -n
"
fi