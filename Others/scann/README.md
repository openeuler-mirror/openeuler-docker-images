# Quick reference

- The official scann docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# scann | openEuler
ScaNN (Scalable Nearest Neighbors) is a method for efficient vector similarity search at scale. This code implements search space pruning and quantization for Maximum Inner Product Search and also supports other distance functions such as Euclidean distance. The implementation is optimized for x86 processors with AVX support. ScaNN achieves state-of-the-art performance on ann-benchmarks.com.


# Supported tags and respective Dockerfile links
The tag of each scann docker image is consist of the version of scann and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.4.2-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/scann/1.4.2/24.03-lts-sp3/Dockerfile) | scann 1.4.2 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
```
docker pull openeuler/scann:{Tag}
docker run --rm openeuler/scann:{Tag} python3 -c "import scann; print('ok')"
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).