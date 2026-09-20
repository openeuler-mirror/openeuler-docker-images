#!/bin/sh
set -e

# allow arguments to be passed to squid
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid || ${1} == $(which squid) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    $(which squid) -N -f /usr/local/squid/etc/squid.conf -z
  fi
  echo "Starting squid..."
  exec $(which squid) -f /usr/local/squid/etc/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
