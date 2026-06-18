# Quick reference

- The official monolith docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# monolith | openEuler
Monolith is a deep learning framework for large scale recommendation modeling. It introduces two important features which are crucial for advanced recommendation system: collisionless embedding tables guarantees unique representation for different id features; real time training captures the latest hotspots and help users to discover new interests rapidly. Monolith is built on the top of TensorFlow and supports batch/real-time training and serving.


# Supported tags and respective Dockerfile links
The tag of each monolith docker image is consist of the version of monolith and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[135c491-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/monolith/135c491/24.03-lts-sp3/Dockerfile) | monolith 135c491 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
```
docker pull openeuler/monolith:{Tag}
docker run -it --rm openeuler/monolith:{Tag} /bin/bash
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).