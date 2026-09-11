# Quick reference

- The official pfordelta docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# pfordelta | openEuler
pfordelta is a C library containing algorithms to compress sorted arrays of integers, forked from the Poly IR Toolkit. It implements the Simple16 and PForDelta integer compression schemes, commonly used for compressing inverted index posting lists.


# Supported tags and respective Dockerfile links
The tag of each pfordelta docker image is consist of the version of pfordelta and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[master-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/pfordelta/master/24.03-lts-sp4/Dockerfile) | pfordelta master on openEuler 24.03-lts-sp4 | amd64, arm64 |


# Usage
Pull the image and run the bundled example executable `howtouse`:
```
docker pull openeuler/pfordelta:{Tag}
docker run --rm openeuler/pfordelta:{Tag} howtouse
```

To explore the source code and headers, launch an interactive shell:
```
docker run -it --rm openeuler/pfordelta:{Tag} /bin/bash
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).