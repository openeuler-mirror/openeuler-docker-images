# Quick reference

- The official mesos docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# mesos | openEuler
Current mesos docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Mesos is a cluster manager that provides efficient resource isolation and sharing across distributed applications, or frameworks. It can run Hadoop, Jenkins, Spark, Aurora, and other frameworks on a dynamically shared pool of nodes.

For more information about mesos, please visit [http://mesos.apache.org/](http://mesos.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each mesos docker image is consist of the version of mesos and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.11.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/mesos/1.11.0/24.03-lts-sp1/Dockerfile)| Apache Mesos 1.11.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Start a mesos instance by following command:
```bash
docker run -it -p 5050:5050 -p 5051:5051 --name mesos openeuler/mesos:latest
```

When the container is ready, you will see the following outputs
```
I0701 08:36:18.578015    78 slave.cpp:1473] New master detected at master@172.17.0.2:5050
I0701 08:36:18.578051    78 slave.cpp:1527] No credentials provided. Attempting to register without authentication
I0701 08:36:18.578105    78 slave.cpp:1538] Detecting new master
I0701 08:36:19.391682    81 slave.cpp:1698] Registered with master master@172.17.0.2:5050; given agent ID b441f369-5fbb-466b-947a-85de592b2ea8-S0
I0701 08:36:19.391881    77 task_status_update_manager.cpp:188] Resuming sending task status updates
I0701 08:36:19.392374    79 status_update_manager_process.hpp:385] Resuming operation status update manager
I0701 08:36:19.394169    81 slave.cpp:1793] Forwarding agent update {"operations":{},"resource_providers":{},"resource_version_uuid":{"value":"Au7VS/olSSyf9zUUcCNVTw=="},"slave_id":{"value":"b441f369-5fbb-466b-947a-85de592b2ea8-S0"},"update_oversubscribed_resources":false}
I0701 08:37:18.567739    80 slave.cpp:7657] Current disk usage 38.64%. Max allowed age: 3.594878272763982days
I0701 08:38:18.573164    77 slave.cpp:7657] Current disk usage 38.64%. Max allowed age: 3.594877815264410days
I0701 08:39:18.579586    82 slave.cpp:7657] Current disk usage 38.64%. Max allowed age: 3.594877357764850days

```
Users can access `mesos` on broswer `http://localhost:5050`

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).