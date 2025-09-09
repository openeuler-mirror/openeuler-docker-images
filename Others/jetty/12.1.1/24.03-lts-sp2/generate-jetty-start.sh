#!/bin/sh
# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Eclipse Public License - v 2.0

if [ -z "$JETTY_START" ] ; then
	JETTY_START=$JETTY_BASE/jetty.start
fi
rm -f $JETTY_START

DRY_RUN=$(/docker-entrypoint.sh "$@" --dry-run | tee /dev/stderr)
DRY_RUN=$(echo "$DRY_RUN" \
	| egrep '[^ ]*java .*org\.eclipse\.jetty\.xml\.XmlConfiguration ' \
	| sed -e 's/ -Djava.io.tmpdir=[^ ]*//g' -e 's/\\$//')
echo "# JETTY_VERSION: $JETTY_VERSION" > "$JETTY_START"
echo "exec $DRY_RUN" >> "$JETTY_START"

# If jetty.start doesn't have content then the dry-run failed.
if ! [ -s $JETTY_START ]; then
	echo "jetty dry run failed:"
	echo "$DRY_RUN" | awk '/\\$/ { printf "%s", substr($0, 1, length($0)-1); next } 1'
	exit 1
fi