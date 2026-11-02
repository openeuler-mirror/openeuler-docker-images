#!/bin/sh

MODULES=`dirname "$0"`/..
MODULES=`cd "$MODULES" && pwd`

# check for overridden launch command (for use in integration tests), otherwise
# use the default.
if [ -z "$LAUNCH_CMD" ]; then
  LAUNCH_CMD=java
  LAUNCH_OPTS=
  # Only check for xvfb-run when using default java launcher
  if command -v xvfb-run > /dev/null 2>&1; then
    LAUNCH_CMD="xvfb-run $LAUNCH_CMD"
  fi
else
  # We are integration-testing. Force UTF-8 as the encoding.
  LAUNCH_OPTS=-Dfile.encoding=UTF-8
fi

eval "$LAUNCH_CMD" $LAUNCH_OPTS --module-path "$MODULES/modules:$MODULES/modules-thirdparty" --module org.apache.lucene.luke "$@"
exit $?