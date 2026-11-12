#!/bin/bash
set -e
if [ $# -eq 0 ] || [ "$1" = "/opt/celeborn/sbin/start-master.sh" ]; then
    /opt/celeborn/sbin/start-master.sh
    exec tail -f /dev/null
fi
exec "$@"
