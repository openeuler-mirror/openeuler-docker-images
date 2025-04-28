# Quick reference

- The official distroless-cc docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# distroless-cc | openEuler
This image contains a minimal Linux, glibc runtime for "mostly-statically compiled" languages like Rust and C/C++.

Specifically, the image contains everything in the `openeuler/distroless-base` image, plus:
- libstdc++

    and its dependency: 
- libgcc

# Supported tags and respective Dockerfile links
The tag of each `distroless-cc` docker image is consist of the version of `libstdc++` and version of openEuler. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[12.3.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-cc/12.3.1/24.03-lts/Distrofile)| libstdc++ and libgcc 12.3.1 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
Users are expected to include their compiled application and set the correct cmd in their image. For [example](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-cc/example)
```
# Dockerfile

FROM openeuler/openeuler:latest AS build-env
COPY . /app
WORKDIR /app
RUN yum install -y gcc g++
RUN g++ hello.cc -o hello

FROM openeuler/distroless-cc:12.3.1-oe2403lts
COPY --from=build-env /app /app
WORKDIR /app
CMD ["./hello"]
```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).