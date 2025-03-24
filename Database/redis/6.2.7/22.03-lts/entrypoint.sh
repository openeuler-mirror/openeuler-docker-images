#!/bin/sh
set -e

arch=$(case $(uname -m) in i386)   echo "386" ;; i686)   echo "386" ;; x86_64) echo "amd64";; aarch64)echo "arm64";; esac)
if [ "${arch}" = "amd64" ]; then
    GOSU_EXEC=/usr/local/bin/gosu_amd64
else
    GOSU_EXEC=/usr/local/bin/gosu_arm64
fi
if [ ! -f /usr/local/bin/gosu ]; then
    ln -s ${GOSU_EXEC}  /usr/local/bin/gosu
fi

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- redis-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
	find . \! -user redis -exec chown redis '{}' +
	exec gosu redis "$0" "$@"
fi

# set an appropriate umask (if one isn't set already)
# - https://github.com/docker-library/redis/issues/305
# - https://github.com/redis/redis/blob/bb875603fb7ff3f9d19aad906bd45d7db98d9a39/utils/systemd-redis_server.service#L37
um="$(umask)"
if [ "$um" = '0022' ]; then
	umask 0077
fi

exec "$@"
