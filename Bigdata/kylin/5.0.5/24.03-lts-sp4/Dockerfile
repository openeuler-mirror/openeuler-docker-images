ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=5.0.5

RUN yum update -y && \
    yum install -y \
        java-1.8.0-openjdk-devel lsof hostname openeuler-lsb \
        openssh openssh-clients mariadb-server wget patch net-tools && \
    yum clean all

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk

COPY <<'KYLIN_CFG_EOF' /etc/ssh/sshd_config
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ListenAddress 0.0.0.0
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' /etc/ssh/ssh_config
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

Host *
	StrictHostKeyChecking no
KYLIN_CFG_EOF
RUN ssh-keygen -A && ssh-keygen -t ed25519 -P '' -f /root/.ssh/id_ed25519 && \
    cat /root/.ssh/id_ed25519.pub > /root/.ssh/authorized_keys && \
    chmod 0400 /root/.ssh/authorized_keys

# install hadoop
ENV HADOOP_VERSION=3.2.4
ENV HIVE_VERSION=3.1.3
ENV ZOOKEEPER_VERSION=3.7.2
ENV SPARK_VERSION=3.3.0

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HIVE_HOME=/opt/apache-hive-$HIVE_VERSION-bin
ENV ZOOKEEPER_HOME=/opt/apache-zookeeper-$ZOOKEEPER_VERSION-bin

WORKDIR /opt
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    wget https://archive.apache.org/dist/zookeeper/zookeeper-$ZOOKEEPER_VERSION/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz && \
    wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-without-hadoop.tgz && \
    wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar && \
    tar -zxf /opt/hadoop-$HADOOP_VERSION.tar.gz && rm -f /opt/hadoop-$HADOOP_VERSION.tar.gz && \
    tar -zxf /opt/apache-hive-$HIVE_VERSION-bin.tar.gz && rm -f /opt/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    tar -zxf /opt/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz && rm -f /opt/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz && \
    tar -zxf /opt/spark-$SPARK_VERSION-bin-without-hadoop.tgz && rm -f /opt/spark-$SPARK_VERSION-bin-without-hadoop.tgz

COPY <<'KYLIN_CFG_EOF' $HADOOP_HOME/sbin/start-historyserver.sh
#!/bin/bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

bash $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh --config $HADOOP_HOME/etc/hadoop start historyserver
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $HADOOP_HOME/etc/hadoop/capacity-scheduler.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->
<configuration>
    <property>
        <name>yarn.scheduler.capacity.default.minimum-user-limit-percent</name>
        <value>100</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.maximum-am-resource-percent</name>
        <value>0.5</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.maximum-applications</name>
        <value>10000</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.node-locality-delay</name>
        <value>40</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.resource-calculator</name>
        <value>org.apache.hadoop.yarn.util.resource.DefaultResourceCalculator</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.capacity</name>
        <value>100</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.default.capacity</name>
        <value>100</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.default.maximum-am-resource-percent</name>
        <value>0.5</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.default.maximum-capacity</name>
        <value>100</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.default.state</name>
        <value>RUNNING</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.default.user-limit-factor</name>
        <value>1</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.queues</name>
        <value>default</value>
    </property>
</configuration>
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $HADOOP_HOME/etc/hadoop/core-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/data/hadoop</value>
    </property>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
    <property>
        <name>hadoop.http.staticuser.user</name>
        <value>root</value>
    </property>
    <property>
        <name>fs.hdfs.impl</name>
        <value>org.apache.hadoop.hdfs.DistributedFileSystem</value>
    </property>
</configuration>
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $HADOOP_HOME/etc/hadoop/hadoop-env.sh

export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export HADOOP_OS_TYPE=${HADOOP_OS_TYPE:-$(uname -s)}
export HDFS_NAMENODE_USER="root"
export HDFS_DATANODE_USER="root"
export HDFS_SECONDARYNAMENODE_USER="root"
export YARN_RESOURCEMANAGER_USER="root"
export YARN_NODEMANAGER_USER="root"
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $HADOOP_HOME/etc/hadoop/hdfs-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $HADOOP_HOME/etc/hadoop/mapred-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.application.classpath</name>
        <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
</configuration>
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $HADOOP_HOME/etc/hadoop/yarn-site.xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->
<configuration>
    <property>
        <name>yarn.nodemanager.disk-health-checker.max-disk-utilization-per-disk-percentage</name>
        <value>98</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_HOME,PATH,LANG,TZ,HADOOP_MAPRED_HOME</value>
    </property>
    <property>
        <name>yarn.resourcemanager.scheduler.class</name>
        <value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler</value>
    </property>
    <property>
        <name>yarn.log-aggregation-enable</name>
        <value>true</value>
    </property>
    <property>
        <name>yarn.log.dir</name>
        <value>/data/hadoop</value>
    </property>
    <property>
        <name>yarn.log.server.url</name>
        <value>http://localhost:19888/jobhistory/logs</value>
    </property>
    <property>
        <name>yarn.scheduler.minimum-allocation-vcores</name>
        <value>1</value>
    </property>
    <property>
        <name>yarn.scheduler.maximum-allocation-vcores</name>
        <value>1</value>
    </property>
    <property>
        <name>yarn.scheduler.minimum-allocation-mb</name>
        <value>256</value>
    </property>
    <property>
        <name>yarn.scheduler.maximum-allocation-mb</name>
        <value>4096</value>
    </property>
</configuration>
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $HIVE_HOME/bin/start-hivemetastore.sh
#!/bin/bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

log_dir="$HIVE_HOME/logs"

if [ ! -d "$log_dir" ]; then
    mkdir -p $log_dir
fi

nohup $HIVE_HOME/bin/hive --service metastore > "$log_dir/hivemetastore.out" 2>&1 &
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $HIVE_HOME/bin/start-hiveserver2.sh
#!/bin/bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

log_dir="$HIVE_HOME/logs"

if [ ! -d "$log_dir" ]; then
    mkdir -p $log_dir
fi

nohup $HIVE_HOME/bin/hive --service hiveserver2 > "$log_dir/hiveserver2.out" 2>&1 &
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $HIVE_HOME/conf/hive-env.sh
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set Hive and Hadoop environment variables here. These variables can be used
# to control the execution of Hive. It should be used by admins to configure
# the Hive installation (so that users do not have to set environment variables
# or set command line parameters to get correct behavior).
#
# The hive service being invoked (CLI etc.) is available via the environment
# variable SERVICE

# Set HADOOP_HOME to point to a specific hadoop install directory
HADOOP_HOME=/opt/hadoop-3.2.4

# Hive Configuration Directory can be controlled by:
export HIVE_CONF_DIR=/opt/apache-hive-3.1.3-bin/conf

# Folder containing extra libraries required for hive compilation/execution can be controlled by:
# export HIVE_AUX_JARS_PATH=
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $HIVE_HOME/conf/hive-site.xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?><!--
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->
<configuration>
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/user/hive3/warehouse</value>
    </property>
    <property>
        <name>hive.txn.manager</name>
        <value>org.apache.hadoop.hive.ql.lockmgr.DbTxnManager</value>
    </property>
    <property>
        <name>hive.support.concurrency</name>
        <value>true</value>
    </property>
    <property>
        <name>hive.server2.enable.doAs</name>
        <value>false</value>
    </property>
    <property>
        <name>hive.server2.thrift.bind.host</name>
        <value>127.0.0.1</value>
    </property>
    <property>
        <name>hive.metastore.uris</name>
        <value>thrift://127.0.0.1:9083</value>
    </property>
    <property>
        <name>hive.metastore.db.type</name>
        <value>mysql</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>com.mysql.cj.jdbc.Driver</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:mysql://127.0.0.1:3306/hive3?useSSL=false&amp;allowPublicKeyRetrieval=true&amp;characterEncoding=UTF-8</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>root</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>123456</value>
    </property>
    <property>
        <name>hive.metastore.event.db.notification.api.auth</name>
        <value>false</value>
    </property>
</configuration>
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $ZOOKEEPER_HOME/conf/zoo.cfg
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir=/data/zookeeper
# the port at which the clients will connect
clientPort=2181
KYLIN_CFG_EOF
RUN mkdir -p /data/hadoop && \
    mkdir -p /data/zookeeper && \
    chmod 0755 $HADOOP_HOME/sbin/start-historyserver.sh && \
    chmod 0755 $HIVE_HOME/bin/start-hivemetastore.sh && \
    chmod 0755 $HIVE_HOME/bin/start-hiveserver2.sh
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HADOOP_HOME/bin:$HIVE_HOME/bin

# hive lib extra
RUN rm -f $HIVE_HOME/lib/guava-*.jar
RUN cp $HADOOP_HOME/share/hadoop/common/lib/guava-*.jar $HIVE_HOME/lib/
RUN cp /opt/mysql-connector-java-8.0.28.jar $HIVE_HOME/lib/

# install apache kylin
RUN mkdir -p /home/kylin/apache-kylin-${VERSION}-bin && \
    (curl -fSL -o apache-kylin.tar.gz https://archive.apache.org/dist/kylin/apache-kylin-${VERSION}/apache-kylin-${VERSION}-bin.tar.gz || \
     curl -fSL -o apache-kylin.tar.gz https://dist.apache.org/repos/dist/dev/kylin/apache-kylin-${VERSION}-rc1/apache-kylin-${VERSION}-bin.tar.gz) && \
    tar -zxf apache-kylin.tar.gz -C /home/kylin/apache-kylin-${VERSION}-bin --strip-components=1 && \
    rm -rf apache-kylin.tar.gz
ENV KYLIN_HOME=/home/kylin/apache-kylin-${VERSION}-bin
RUN cp /opt/mysql-connector-java-8.0.28.jar $KYLIN_HOME/lib/ext/
COPY <<'KYLIN_CFG_EOF' $KYLIN_HOME/conf/kylin.properties.override
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

server.port=7070
kylin.env.apache-hadoop-conf-dir=/opt/hadoop-3.2.4/etc/hadoop
kylin.env.apache-hive-conf-dir=/opt/apache-hive-3.1.3-bin/conf

kylin.metadata.url=kylin@jdbc,driverClassName=com.mysql.jdbc.Driver,url=jdbc:mysql://127.0.0.1:3306/kylin?useSSL=false&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8,username=root,password=123456,maxTotal=50,maxIdle=8
kylin.env.zookeeper-connect-string=127.0.0.1:2181
kylin.env.hdfs-working-dir=/kylin

# Query
kylin.storage.columnar.spark-conf.spark.driver.memory=512M
kylin.storage.columnar.spark-conf.spark.driver.memoryOverhead=256M
kylin.storage.columnar.spark-conf.spark.memory.offHeap.enabled=true
kylin.storage.columnar.spark-conf.spark.memory.offHeap.size=1g
kylin.storage.columnar.spark-conf.spark.executor.cores=1
kylin.storage.columnar.spark-conf.spark.executor.instances=1
kylin.storage.columnar.spark-conf.spark.executor.memory=1024M
kylin.storage.columnar.spark-conf.spark.executor.memoryOverhead=512M
kylin.storage.columnar.spark-conf.spark.driver.host=127.0.0.1

# Build
kylin.engine.driver-memory-strategy=2,500
kylin.engine.spark-conf.spark.driver.memory=512M
kylin.engine.spark-conf.spark.driver.memoryOverhead=256M
kylin.engine.spark-conf.spark.memory.offHeap.enabled=true
kylin.engine.spark-conf.spark.memory.offHeap.size=1g
kylin.engine.spark-conf.spark.executor.cores=1
kylin.engine.spark-conf.spark.executor.instances=1
kylin.engine.spark-conf.spark.executor.memory=1024M
kylin.engine.spark-conf.spark.executor.memoryOverhead=512M
kylin.engine.spark-conf.spark.driver.host=127.0.0.1

# Async Query
kylin.query.async-query.spark-conf.spark.executor.cores=1
kylin.query.async-query.spark-conf.spark.driver.memory=1024M
kylin.query.async-query.spark-conf.spark.executor.memory=1024M
kylin.query.async-query.spark-conf.spark.executor.instances=1
kylin.query.async-query.spark-conf.spark.executor.memoryOverhead=512M

# Other
kylin.metadata.random-admin-password.enabled=false
kylin.query.engine.push-down.enable-prepare-statement-with-params=true
kylin.query.calcite.extras-props.FUN=standard,oracle
kylin.circuit-breaker.threshold.project=500
kylin.engine.resource-request-over-limit-proportion=3.0

# Disable job memory acquire limit
kylin.job.auto-set-concurrent-jobs=false

# ================ kylin5 extra config ================

kylin.storage.columnar.spark-conf.spark.broadcast.autoClean.enabled=false
kylin.storage.columnar.spark-conf.spark.gluten.sql.columnar.backend.ch.runtime_config.storage_configuration.disks.hdfs.endpoint=hdfs://127.0.0.1:9000/
kylin.storage.columnar.spark-conf.spark.gluten.sql.columnar.backend.ch.runtime_config.hdfs.libhdfs3_conf=${KYLIN_HOME}/hadoop_conf/hdfs-site.xml
kylin.storage.columnar.spark-conf.spark.gluten.sql.columnar.backend.ch.runtime_config.storage_configuration.disks.hdfs_cache.max_size=1Gi

kylin.engine.spark-conf.spark-conf.spark.broadcast.autoClean.enabled=false
kylin.engine.spark-conf.spark.gluten.sql.columnar.backend.ch.runtime_config.storage_configuration.disks.hdfs.endpoint=hdfs://127.0.0.1:9000/
kylin.engine.spark-conf.spark.gluten.sql.columnar.backend.ch.runtime_config.hdfs.libhdfs3_conf=${KYLIN_HOME}/hadoop_conf/hdfs-site.xml

kylin.storage.default-storage-type=3
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $KYLIN_HOME/properties.patch
diff --git a/bin/get-properties.sh b/bin/get-properties.sh
index 031db36f3e..e657a2abd8 100755
--- a/bin/get-properties.sh
+++ b/bin/get-properties.sh
@@ -71,7 +71,7 @@ function runTool() {
   fi
 
   mkdir -p "${KYLIN_HOME}"/logs
-  local result=$(java ${KYLIN_KERBEROS_OPTS} -Dlog4j.configurationFile=${kylin_tools_log4j} -Dkylin.hadoop.conf.dir=${kylin_hadoop_conf_dir} -Dhdp.version=current -cp "${kylin_hadoop_conf_dir}:${KYLIN_HOME}/lib/ext/*:${KYLIN_HOME}/server/jars/*:${SPARK_HOME}/jars/*" "$@" 2>>${KYLIN_HOME}/logs/shell.stderr)
+  local result=$(java ${KYLIN_KERBEROS_OPTS} -Dlog4j.configurationFile=${kylin_tools_log4j} -Dkylin.hadoop.conf.dir=${kylin_hadoop_conf_dir} -Dhdp.version=current -cp "${kylin_hadoop_conf_dir}:${KYLIN_HOME}/lib/ext/*:${KYLIN_HOME}/server/jars/*:${SPARK_HOME}/jars/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/common/lib/*" "$@" 2>>${KYLIN_HOME}/logs/shell.stderr)
   echo "$result"
 }
 
KYLIN_CFG_EOF
COPY <<'KYLIN_CFG_EOF' $KYLIN_HOME/bootstrap.patch
diff --git a/sbin/bootstrap.sh b/sbin/bootstrap.sh
index 99f6490f07..91cf9039e2 100755
--- a/sbin/bootstrap.sh
+++ b/sbin/bootstrap.sh
@@ -254,7 +254,7 @@ function runToolInternal() {
     else
         kylin_tools_log4j="file:${KYLIN_HOME}/tool/conf/kylin-tools-log4j.xml"
     fi
-    java -Xms${JAVA_VM_TOOL_XMS} -Xmx${JAVA_VM_TOOL_XMX} ${KYLIN_KERBEROS_OPTS} -Dfile.encoding=UTF-8 -Dlog4j.configurationFile=${kylin_tools_log4j} -Dkylin.hadoop.conf.dir=${kylin_hadoop_conf_dir} -Dhdp.version=current -cp "${kylin_hadoop_conf_dir}:${KYLIN_HOME}/conf/:${KYLIN_HOME}/lib/ext/*:${SPARK_HOME}/jars/*:${KYLIN_HOME}/server/jars/*" "$@"
+    java -Xms${JAVA_VM_TOOL_XMS} -Xmx${JAVA_VM_TOOL_XMX} ${KYLIN_KERBEROS_OPTS} -Dfile.encoding=UTF-8 -Dlog4j.configurationFile=${kylin_tools_log4j} -Dkylin.hadoop.conf.dir=${kylin_hadoop_conf_dir} -Dhdp.version=current -cp "${kylin_hadoop_conf_dir}:${KYLIN_HOME}/conf/:${KYLIN_HOME}/lib/ext/*:${SPARK_HOME}/jars/*:${KYLIN_HOME}/server/jars/*:${HADOOP_HOME}/share/hadoop/common/lib/*:${HADOOP_HOME}/share/hadoop/common/*:${ZOOKEEPER_HOME}/lib/*:${HADOOP_HOME}/share/hadoop/hdfs/*" "$@"
 }
 
 function killChildProcess {
@@ -442,8 +442,10 @@ function startKylin(){
 
     SERVER_MODE=$("${KYLIN_HOME}"/bin/get-properties.sh kylin.server.mode)
 
+    rm -rf ${HADOOP_HOME}/share/hadoop/common/lib/slf4j-reload4j-1.7.35.jar
+
     cd "${KYLIN_HOME}"/server
-    nohup java ${KYLIN_KERBEROS_OPTS} ${KYLIN_EXTRA_START_OPTS} ${TIME_ZONE} -Dfile.encoding=UTF-8 -Dlogging.path=${KYLIN_HOME}/logs -Dspring.profiles.active=prod -Dlogging.config=${KYLIN_SERVER_LOG4J} -Dkylin.hadoop.conf.dir=${kylin_hadoop_conf_dir} -Dhdp.version=current -Dloader.path="${kylin_hadoop_conf_dir},${KYLIN_HOME}/conf,${KYLIN_HOME}/lib/ext,${KYLIN_HOME}/server/jars,${SPARK_HOME}/jars" -XX:OnOutOfMemoryError="sh ${KYLIN_HOME}/bin/guardian.sh kill"  -jar newten.jar --kylin.server.mode=${SERVER_MODE} >> ${KYLIN_HOME}/logs/kylin.out 2>&1 < /dev/null & echo $! >> ${KYLIN_HOME}/pid &
+    nohup java ${KYLIN_KERBEROS_OPTS} ${KYLIN_EXTRA_START_OPTS} ${TIME_ZONE} -Dfile.encoding=UTF-8 -Dlogging.path=${KYLIN_HOME}/logs -Dspring.profiles.active=prod -Dlogging.config=${KYLIN_SERVER_LOG4J} -Dkylin.hadoop.conf.dir=${kylin_hadoop_conf_dir} -Dhdp.version=current -Dloader.path="${kylin_hadoop_conf_dir},${KYLIN_HOME}/conf,${KYLIN_HOME}/lib/ext,${KYLIN_HOME}/server/jars,${SPARK_HOME}/jars,${HADOOP_HOME}/share/hadoop/common,${HADOOP_HOME}/share/hadoop/common/lib/,${ZOOKEEPER_HOME}/lib,${HADOOP_HOME}/share/hadoop/hdfs" -XX:OnOutOfMemoryError="sh ${KYLIN_HOME}/bin/guardian.sh kill"  -jar newten.jar --kylin.server.mode=${SERVER_MODE} >> ${KYLIN_HOME}/logs/kylin.out 2>&1 < /dev/null & echo $! >> ${KYLIN_HOME}/pid &
 
     clearRedundantProcess 3
KYLIN_CFG_EOF

RUN mkdir -p $KYLIN_HOME/spark && \
    mv /opt/spark-$SPARK_VERSION-bin-without-hadoop/* $KYLIN_HOME/spark/ && \
    cd  $KYLIN_HOME && \
    patch -p1 < properties.patch && \
    patch -p1 --forward < bootstrap.patch || true; \
    sed -i 's#\${SPARK_HOME}/jars"#\${SPARK_HOME}/jars,\${HADOOP_HOME}/share/hadoop/common,\${HADOOP_HOME}/share/hadoop/common/lib/,\${ZOOKEEPER_HOME}/lib,\${HADOOP_HOME}/share/hadoop/hdfs"#' $KYLIN_HOME/sbin/bootstrap.sh && \
    sed -i '/cd "\${KYLIN_HOME}"\/server/i\    rm -rf \${HADOOP_HOME}/share/hadoop/common/lib/slf4j-reload4j-1.7.35.jar' $KYLIN_HOME/sbin/bootstrap.sh && \
    rm -rf $KYLIN_HOME/server/jars/guava-*.jar && \
    cd $KYLIN_HOME/server/jars/ && \
    wget https://repo1.maven.org/maven2/com/google/guava/guava/28.0-jre/guava-28.0-jre.jar

# startup script
COPY <<'KYLIN_CFG_EOF' /home/kylin/entrypoint.sh
#!/bin/bash

#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FLAG_INITIALIZED="/home/kylin/initialized"
TIMEOUT=600

function run_command {
    local STEP="$1"
    shift 1

    echo ""
    echo "==============================================================================="
    echo "*******************************************************************************"
    echo "|"
    echo "|   $STEP at $(date)"
    echo "|   Command: $@"
    echo "|"
    "$@" 2>&1

    local EC=$?
    if [ $EC != 0 ]; then
        echo "ERROR!!"
        echo "[$STEP] Command FAILED : $@, please check!!!"
        sleep 7200
        exit $EC
    else
        echo "[$STEP] succeed."
    fi
}

function check_and_monitor_status() {
    local COMPONENT="$1"
    shift 1
    echo "Checking $COMPONENT's status..."
    component_status=
    ((time_left = TIMEOUT))
    while ((time_left > 0)); do
        sleep 10
        "$@" 2>&1
        component_status=$?
        if [[ $component_status -eq 0 ]]; then
            echo "+"
            break
        else
            echo "-"
        fi
        ((timeLeft -= 10))
    done
    if [[ $component_status -eq 0 ]]; then
        echo "Check $COMPONENT succeed."
    else
        echo "ERROR: check $COMPONENT failed."
    fi
    return $component_status
}

function check_hive_port() {
    local port=$1
    if [[ $(lsof -i :$port) == *"LISTEN"* ]]; then
        return 0
    else
        return 1
    fi
}

# clean pid files
rm -f /tmp/*.pid
rm -rf /data/zookeeper/*
rm -f /data/zookeeper/zookeeper_server.pid

##############################################

# start ssh
run_command "Start SSH server" /usr/sbin/sshd

# start mysql
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sleep 3
chown -R mysql:mysql /var/lib/mysql
chmod 750 /var/lib/mysql
run_command "Start MySQL" /usr/bin/mysqld_safe --user=mysql &
sleep 3
run_command "Set MySQL Password" mysqladmin -u root password '123456'

ln -s $JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# env init
if [ ! -f $FLAG_INITIALIZED ]; then
    run_command "Create Database kylin" mysql -uroot -p123456 -e "CREATE DATABASE IF NOT EXISTS kylin default charset utf8mb4 COLLATE utf8mb4_general_ci;"
    run_command "Create Database hive3" mysql -uroot -p123456 -e "CREATE DATABASE IF NOT EXISTS hive3 default charset utf8mb4 COLLATE utf8mb4_general_ci;"
    run_command "Init Hive" schematool -initSchema -dbType mysql
    run_command "Format HDFS" hdfs namenode -format
fi

# start zookeeper
run_command "Start Zookeeper" "$ZOOKEEPER_HOME"/bin/zkServer.sh start

# start hadoop
run_command "Start Hadoop" "$HADOOP_HOME"/sbin/start-all.sh

# start job history server
run_command "Start History Server" "$HADOOP_HOME"/sbin/start-historyserver.sh

# start hive metastore & hiveserver2
run_command "Start Hive metastore" "$HIVE_HOME"/bin/start-hivemetastore.sh
check_and_monitor_status "Check Hive metastore" check_hive_port 9083
run_command "Start Hive server" "$HIVE_HOME"/bin/start-hiveserver2.sh
check_and_monitor_status "Check Hive server" check_hive_port 10000

sleep 10

# pre-running initializing
if [ ! -f $FLAG_INITIALIZED ]
then
    mkdir -p "$KYLIN_HOME"/logs
    hdfs dfs -mkdir -p /kylin
    run_command "Prepare sample data" "$KYLIN_HOME"/bin/sample.sh
fi

# start kylin
run_command "Kylin ENV bypass" touch $KYLIN_HOME/bin/check-env-bypass
run_command "Start Kylin Instance" "$KYLIN_HOME"/bin/kylin.sh -v start

check_and_monitor_status "Check Env Script" ls $KYLIN_HOME/bin/check-env-bypass
check_and_monitor_status "Kylin Instance" grep -c "Initialized Spark" $KYLIN_HOME/logs/kylin.log

touch $FLAG_INITIALIZED
echo "Kylin service is already available for you to preview."

# keep docker running
sleep infinity
KYLIN_CFG_EOF
RUN chmod 0755 /home/kylin/entrypoint.sh

WORKDIR /home/kylin
CMD ["/bin/bash", "entrypoint.sh"]