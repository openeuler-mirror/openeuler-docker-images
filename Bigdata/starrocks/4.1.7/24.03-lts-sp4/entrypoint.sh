#!/bin/bash
/opt/starrocks/fe/bin/start_fe.sh "$@"
exec tail -f /dev/null
