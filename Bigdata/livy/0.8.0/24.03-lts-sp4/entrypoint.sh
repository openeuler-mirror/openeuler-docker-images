#!/bin/bash

/opt/livy/bin/livy-server start
tail -f /opt/livy/logs/livy--server.out