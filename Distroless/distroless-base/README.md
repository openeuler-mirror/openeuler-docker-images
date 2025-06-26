# Quick reference

- The official distroless-base docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# distroless-base | openEuler
This image contains a minimal Linux, glibc-based system. It is intended for use directly by "mostly-statically compiled" languages like Go, Rust or D.

Statically compiled applications (Go) that do not require libc can use the `openeuler/distroless-static` image, which contains:
- ca-certificates
- tzdata

Most other applications (and Go apps that require libc/cgo) should start with `openeuler/distroless-base`, which contains all of the packages in `openeuler/distroless-static`, and
- glibc
- openssl_libs

# Supported tags and respective Dockerfile links
The tag of each `distroless-base` docker image is consist of the version of `glibc` and version of openEuler. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.38-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-base/2.38/24.03-lts/Distrofile)| Glibc 4.1.4 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
Users are expected to include their compiled application and set the correct cmd in their image. For [example](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-base/example)
```
# Dockerfile

FROM openeuler/openeuler:latest AS build-env
COPY . /app
WORKDIR /app
RUN yum install -y gcc g++
RUN cc hello.c -o hello

FROM openeuler/distroless-base:2.38-oe2403lts
COPY --from=build-env /app /app
WORKDIR /app
CMD ["./hello"]
```

# Run Applications as a Non-Root User
For implementation details, refer to the [distroless-base-nonroot documentation](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-base-nonroot/README.md).
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).