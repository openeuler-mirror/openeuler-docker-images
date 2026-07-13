# Quick reference

- The official sonic-cpp docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# sonic-cpp | openEuler
Sonic-Cpp is a fast JSON serializing & deserializing library, accelerated by SIMD. It provides complete APIs for JSON value manipulation, fast JSON serializing and parsing, and supports parse ondemand.


# Supported tags and respective Dockerfile links
The tag of each sonic-cpp docker image is consist of the version of sonic-cpp and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.0.2-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/sonic-cpp/1.0.2/24.03-lts-sp4/Dockerfile) | sonic-cpp 1.0.2 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[1.0.2-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/sonic-cpp/1.0.2/24.03-lts-sp3/Dockerfile) | sonic-cpp 1.0.2 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
```
docker pull openeuler/sonic-cpp:{Tag}
docker run --rm -v $(pwd):/workspace openeuler/sonic-cpp:{Tag} g++ -I/usr/local/include -march=haswell --std=c++11 -O3 /workspace/example.cpp -o /workspace/example
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
