# Quick reference

- The official cubefs docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# cubefs(cubefs Storage Stack) | openEuler
Current cubefs(cubefs Storage Stack) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

CubeFS ("储宝" in Chinese) is an open-source cloud-native distributed file & object storage system, hosted by the Cloud Native Computing Foundation (CNCF) as a graduated project.

Learn more about cubefs, please visit [https://www.cubefs.io/](https://www.cubefs.io/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `cubefs` docker image is consist of the version of `cubefs` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[3.5.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/cubefs/3.5.0/24.03-lts-sp1/Dockerfile)| Cubefs 3.5.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

Launch the cubefs container
```
docker run -it --name my-cubefs openeuler/cubefs:latest
```
Entering the container, you will see following files
```
[root@4d8f37230d55 /]#
access         cfs-authtool  cfs-client  cfs-preload  fdstore    libcubefs-1.0-SNAPSHOT-jar-with-dependencies.jar  scheduler
blobnode       cfs-bcache    cfs-deploy  cfs-server   libcfs.h   libcubefs-1.0-SNAPSHOT.jar
blobstore-cli  cfs-cli       cfs-fsck    clustermgr   libcfs.so  proxy
```
Please select to run one of the binary files to finish your job.

        
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).