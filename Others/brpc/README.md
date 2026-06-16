# Quick reference
- The official Apache brpc docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Apache brpc | openEuler
Apache brpc is an Industrial-grade RPC framework using C++ Language, which is often used in high performance system such as Search, Storage, Machine learning, Advertisement, Recommendation etc. "brpc" means "better RPC". It provides:
- Building a server that can talk in multiple protocols on the same port, or access all sorts of services.
- Servers can handle requests synchronously or asynchronously.
- Clients can access servers synchronously, asynchronously, or use combo channels to simplify sharded or parallel accesses.
- Debug services via http, and run cpu, heap and contention profilers.
- Extend bRPC with the protocols used in your organization quickly.
Learn more at [Apache brpc](https://brpc.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each brpc docker image is consist of the version of brpc and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[1.16.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/brpc/1.16.0/24.03-lts-sp3/Dockerfile)| brpc 1.16.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the brpc docker image from DockerHub:
```docker pull openeuler/brpc:{Tag}```
- Run the Docker container to launch the brpc developer environment.
```docker run -it openeuler/brpc:{Tag}```
- Verify the installation inside the container:
```ls /brpc/output/include/brpc```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).