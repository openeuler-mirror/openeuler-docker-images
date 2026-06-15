# Quick reference

- The official celeborn docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# celeborn | openEuler
Celeborn is dedicated to improving the efficiency and elasticity of
different map-reduce engines and provides an elastic, high-efficient 
management service for intermediate data including shuffle data, spilled data, result data, etc. Currently, Celeborn is focusing on shuffle data.

Learn more on [Apache Celeborn™](https://celeborn.apache.org/docs/latest/)

# Supported tags and respective Dockerfile links
The tag of each celeborn docker image is consist of the version of celeborn and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.6.3-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Bigdata/celeborn/0.6.3/24.03-lts-sp3/Dockerfile) | celeborn 0.6.3 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
```
docker pull openeuler/celeborn:{Tag}

docker run -d \
  --name celeborn-master \
  -p 9097:9097 -p 9098:9098 \
  openeuler/celeborn:{Tag} \
  /opt/celeborn/sbin/start-master.sh

docker run -d \
  --name celeborn-worker \
  -p 9096:9096 \
  openeuler/celeborn:{Tag} \
  /opt/celeborn/sbin/start-worker.sh celeborn://<master-ip>:9097
```


# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
