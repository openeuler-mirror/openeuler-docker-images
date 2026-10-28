#!/usr/bin/env bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

export SOLR_USER="solr"

if [ $# -gt 0 ]; then
    exec "$@"
else
    /solr-start.sh
fi