#!/usr/bin/env bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

export JAVA_HOME="${JAVA_HOME:-/usr}"

export SOLR_HOME="/solr"

cd "$SOLR_HOME"

# Solr 5+ insists on SOLR_HOME being set to /solr/server/solr dir containing solr.xml
set +o pipefail # in case solr version doesn't exist in older versions
if [ "$(solr version|cut -c 1)" -ge 5 ]; then
    export SOLR_HOME="$SOLR_HOME/server/solr"
    solr start -f
else
    cd "$SOLR_HOME/example"
    java -jar start.jar
fi