#!/bin/bash

# Start SSH service
/usr/sbin/sshd

# Format HDFS
echo "Formatting HDFS NameNode..."
hdfs namenode -format

# Run Hadoop with CMD arguments
$HADOOP_HOME/sbin/start-all.sh "$@"

echo "Start History Server"
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh --config $HADOOP_HOME/etc/hadoop start historyserver

tail -f /dev/null