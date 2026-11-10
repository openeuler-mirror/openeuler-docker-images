#!/bin/sh
# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Eclipse Public License - v 2.0

set -e

if [ "$1" = jetty.sh ]; then
	if ! command -v bash >/dev/null 2>&1 ; then
		cat >&2 <<- 'EOWARN'
			********************************************************************
			ERROR: bash not found. Use of jetty.sh requires bash.
			********************************************************************
		EOWARN
		exit 1
	fi
	cat >&2 <<- 'EOWARN'
		********************************************************************
		WARNING: Use of jetty.sh from this image is deprecated and may
			 be removed at some point in the future.

			 See the documentation for guidance on extending this image:
			 https://github.com/docker-library/docs/tree/master/jetty
		********************************************************************
	EOWARN
fi

if ! command -v -- "$1" >/dev/null 2>&1 ; then
	set -- java -jar "$JETTY_HOME/start.jar" "$@"
fi

: ${TMPDIR:=/tmp/jetty}
[ -d "$TMPDIR" ] || mkdir -p $TMPDIR 2>/dev/null

: ${JETTY_START:=$JETTY_BASE/jetty.start}

case "$JAVA_OPTIONS" in
	*-Djava.io.tmpdir=*) ;;
	*) JAVA_OPTIONS="-Djava.io.tmpdir=$TMPDIR $JAVA_OPTIONS" ;;
esac

if expr "$*" : 'java .*/start\.jar.*$' >/dev/null ; then
	# this is a command to run jetty

	# check if it is a terminating command
	for A in "$@" ; do
		case $A in
			--add-module* |\
			--add-to-start* |\
			--create-files |\
			--create-start-ini |\
			--create-startd |\
			--download |\
			--dry-run |\
			--exec-print |\
			--help |\
			--info |\
			--list-all-modules |\
			--list-classpath |\
			--list-config |\
			--list-modules* |\
			--show-module* |\
			--stop |\
			--update-ini |\
			--version |\
			--write-module-graph* |\
			-v )\
			# It is a terminating command, so exec directly
			JAVA="$1"
			shift
			# The $START_OPTIONS is the JVM options for the JVM which will do the --dry-run.
			# The $JAVA_OPTIONS contains the JVM options used in the output of the --dry-run command.
			eval "exec $JAVA $START_OPTIONS \"\$@\" $JAVA_OPTIONS $JETTY_PROPERTIES"
		esac
	done

	if [ $(whoami) != "jetty" ]; then
		cat >&2 <<- EOWARN
			********************************************************************
			WARNING: User is $(whoami)
			         The user should be (re)set to 'jetty' in the Dockerfile
			********************************************************************
		EOWARN
	fi

	if [ -f $JETTY_START ] ; then

		# Search for the Jetty Version comment in the jetty.start file.
		JETTY_START_VERSION="$(
			grep -m1 '^# JETTY_VERSION:' "$JETTY_START" 2>/dev/null \
				| sed 's/^# JETTY_VERSION: //'
		)"

		# If the jetty.start file was generated with a different Jetty version we need to regenerate jetty.start.
		if [ "$JETTY_START_VERSION" != "$JETTY_VERSION" ]; then
			echo "$(date +'%Y-%m-%d %H:%M:%S'):INFO: Jetty version mismatch ($JETTY_START_VERSION -> $JETTY_VERSION), regenerating jetty.start" >&2
			/generate-jetty-start.sh "$@"

		# If the start.d directory has been modified we need to regenerate jetty.start.
		elif [ $JETTY_BASE/start.d -nt $JETTY_START ] ; then
			cat >&2 <<- EOWARN
			********************************************************************
			WARNING: The $JETTY_BASE/start.d directory has been modified since
			         the $JETTY_START files was generated.
			         To avoid regeneration delays at start, either delete
			         the $JETTY_START file or re-run /generate-jetty-start.sh
			         from a Dockerfile.
			********************************************************************
			EOWARN
			/generate-jetty-start.sh "$@"
		fi
		echo $(date +'%Y-%m-%d %H:%M:%S.000'):INFO:docker-entrypoint:jetty start from $JETTY_START
	else
		/generate-jetty-start.sh "$@"
	fi

	## The generate-jetty-start script always starts the jetty.start file with exec, so this command will exec Jetty.
  ## We need to do this because the file may have quoted arguments which cannot be read into a variable.
  . $JETTY_START
fi

if [ "${1##*/}" = java -a -n "$JAVA_OPTIONS" ] ; then
	JAVA="$1"
	shift
	set -- "$JAVA" $JAVA_OPTIONS "$@"
fi

exec "$@"