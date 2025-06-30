# Quick reference

- The official accumulo docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# Accumulo | openEuler
Current accumulo docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Accumulo is a sorted, distributed key/value store that provides robust, scalable data storage and retrieval. With Apache Accumulo, users can store and manage large data sets across a cluster.

Learn more on [accumulo website](https://accumulo.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each accumulo docker image is consist of the version of accumulo and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.1.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/accumulo/2.1.3/24.03-lts-sp1/Dockerfile)| Apache accumulo 2.1.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Deploy a accumulo instance with pre-installed hadoop and zookeeper components by following command:
```bash
# Start Accumulo
docker run -it \
    --name accumulo \
    openeuler/accumulo:latest
```
The following message indicates that the accumulo is ready :
```
************************************************************/
Starting Hadoop...
Starting namenodes on [localhost]
localhost: Warning: Permanently added 'localhost' (ED25519) to the list of known hosts.
Starting datanodes
Starting secondary namenodes [183cfa448d9e]
183cfa448d9e: Warning: Permanently added '183cfa448d9e' (ED25519) to the list of known hosts.
2025-06-27 09:44:28,879 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Starting resourcemanager
Starting nodemanagers
Start History Server
WARNING: Use of this script to start the MR JobHistory daemon is deprecated.
WARNING: Attempting to execute replacement "mapred --daemon start" instead.
2025-06-27T09:44:36,603 [conf.SiteConfiguration] INFO : Found Accumulo configuration on classpath at /usr/local/accumulo/conf/accumulo.properties
2025-06-27T09:44:36,758 [util.NativeCodeLoader] WARN : Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
2025-06-27T09:44:37,033 [fs.VolumeManagerImpl] WARN : dfs.datanode.synconclose set to false in hdfs-site.xml: data loss is possible on hard system reset or power loss
2025-06-27T09:44:37,033 [init.Initialize] INFO : Hadoop Filesystem is hdfs://localhost:8020
2025-06-27T09:44:37,033 [init.Initialize] INFO : Accumulo data dirs are [[hdfs://localhost:8020/accumulo]]
2025-06-27T09:44:37,033 [init.Initialize] INFO : Zookeeper server is localhost:2181
2025-06-27T09:44:37,033 [init.Initialize] INFO : Checking if Zookeeper is available. If this hangs, then you need to make sure zookeeper is running


Warning!!! Your instance secret is still set to the default, this is not secure. We highly recommend you change it.


You can change the instance secret in accumulo by using:
   bin/accumulo org.apache.accumulo.server.util.ChangeSecret
You will also need to edit your secret in your configuration file by adding the property instance.secret to your accumulo.properties. Without this accumulo will not operate correctly
Instance name : 

```

To stop and remove the container, use these commands.
```
docker stop accumulo
docker rm accumulo
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).