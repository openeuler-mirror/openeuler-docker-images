# Quick reference

- The official storm docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# storm | openEuler
Current storm docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Storm is a distributed realtime computation system. Similar to how Hadoop provides a set of general primitives for doing batch processing, Storm provides a set of general primitives for doing realtime computation.

For more information about storm, please visit [https://storm.apache.org/](https://storm.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each storm docker image is consist of the version of storm and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.8.2-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/storm/2.8.2/24.03-lts-sp2/Dockerfile) | storm 2.8.2 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[2.8.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/storm/2.8.0/24.03-lts-sp1/Dockerfile)| Storm 2.8.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

- Start a storm instance by following command:
```bash
docker run -it --name storm openeuler/storm:latest storm
```
- Options
```
usage: storm [-h]
             {jar,localconfvalue,remoteconfvalue,local,sql,kill,upload-credentials,blobstore,heartbeats,activate,set_log_level,list,deactivate,rebalance,get-errors,node-health-check,kill_workers,admin,shell,repl,nimbus,pacemaker,supervisor,ui,logviewer,drpc-client,drpc,dev-zookeeper,version,classpath,server_classpath,monitor}
             ...

positional arguments:
  {jar,localconfvalue,remoteconfvalue,local,sql,kill,upload-credentials,blobstore,heartbeats,activate,set_log_level,list,deactivate,rebalance,get-errors,node-health-check,kill_workers,admin,shell,repl,nimbus,pacemaker,supervisor,ui,logviewer,drpc-client,drpc,dev-zookeeper,version,classpath,server_classpath,monitor}
    jar                 Runs the main method of class with the specified arguments. The storm worker dependencies and configs in
                        ~/.storm are put on the classpath. The process is configured so that StormSubmitter
                        (https://storm.apache.org/releases/current/javadocs/org/apache/storm/StormSubmitter.html) will upload
                        the jar at topology-jar-path when the topology is submitted. When you pass jars and/or artifacts
                        options, StormSubmitter will upload them when the topology is submitted, and they will be included to
                        classpath of both the process which runs the class, and also workers for that topology.
    localconfvalue      Prints out the value for conf-name in the local Storm configs. The local Storm configs are the ones in
                        ~/.storm/storm.yaml merged in with the configs in defaults.yaml.
    remoteconfvalue     Prints out the value for conf-name in the cluster's Storm configs. The cluster's Storm configs are the
                        ones in $STORM-PATH/conf/storm.yaml merged in with the configs in defaults.yaml. This command must be
                        run on a cluster machine.
...
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).