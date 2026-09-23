#!/bin/bash

# Start SSH service
/usr/sbin/sshd

# Format HDFS
echo "Starting Zookeeper..."
"$ZOOKEEPER_HOME"/bin/zkServer.sh start

# Format HDFS
echo "Formatting HDFS NameNode..."
hdfs namenode -format

# Run Hadoop
echo "Starting Hadoop..."
$HADOOP_HOME/sbin/start-all.sh start
echo "Start History Server"
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh --config $HADOOP_HOME/etc/hadoop start historyserver

# Run accumulo with CMD
accumulo "$@"

tail -f /dev/null