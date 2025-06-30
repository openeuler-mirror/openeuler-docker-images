# Quick reference

- The official hadoop docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# hadoop | openEuler
Current hadoop docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Apache Hadoop software library is a framework that allows for the distributed processing of large data sets across clusters of computers using simple programming models.

Learn more on [hadoop website](https://hadoop.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each hadoop docker image is consist of the version of hadoop and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3.4.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/hadoop/3.4.1/24.03-lts-sp1/Dockerfile)| Apache hadoop 3.4.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Deploy a hadoop instance by following command:
```bash
docker run -d \
    --name hadoop \
    --hostname localhost \
    -p 9870:9870 \
    -p 8088:8088 \
    -p 19888:19888 \
    openeuler/hadoop:latest

docker logs --follow hadoop
```
The following message indicates that the hadoop is ready :
```
Starting resourcemanager
Starting nodemanagers
```
After that, please press Ctrl + C to exit docker logs, and visit hadoop web UI.
| Service Name   |   URL                   |
|----------------|-------------------------|
|NameNode        | http://localhost:9870⁠   |
|ResourceManager | http://localhost:8088⁠   |
|JobHistory      | http://localhost:19888⁠  |

To stop and remove the container, use these commands.
```
docker stop hadoop
docker rm hadoop
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).