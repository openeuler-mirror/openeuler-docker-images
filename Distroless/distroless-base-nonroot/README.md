# Quick reference

- The official distroless-base-nonroot docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# distroless-base-nonroot | distroless-base
This image is based on the `distroless-base` image, with an added non-root user.  
It allows you to run applications as a non-root user by default for improved security.

The key differences compared to `distroless-base` are as follows:

1. **Minimal `/etc/passwd` file with the dedicated non-root user**:
   - `nonroot` user (custom unprivileged user for running applications)

2. **Minimal `/etc/group` file with the dedicated non-root group**:
   - `nonroot` group (custom unprivileged group)

# Supported tags and respective Dockerfile links
The tag of each `distroless-base-nonroot` docker image is consist of the version of `glibc` and version of openEuler. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.38-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-base/2.38/24.03-lts/Distrofile)| Glibc 4.1.4 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
Based on the usage of the [distroless-base](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-base/README.md), you can specify a non-root user in your image if needed.
```
# Dockerfile

FROM openeuler/openeuler:24.03-lts AS build-env
COPY . /app
WORKDIR /app
RUN yum install -y gcc g++
RUN cc hello.c -o hello

FROM openeuler/distroless-base-nonroot:2.38-oe2403lts
COPY --from=build-env /app /app
WORKDIR /app
USER nonroot
CMD ["./hello"]
```

# Custom user example
In addition to the fixed `nonroot` user, you can also create custom users and groups just like the distroless-base-nonroot image does.

In the following `Dockerfile`, you can replace `USERNAME`, `UID`, `GROUP`, and `GID` with your desired values:
```
FROM openeuler/openeuler:24.03-lts AS build-env

RUN dnf install -y shadow-utils && \
    groupadd -g <GID> <GROUP> && \
    useradd -u <UID> -g <GID> -s /sbin/nologin <USERNAME>

# Build app
RUN ...

FROM openeuler/distroless-{base/cc/python/...}:{TAG}
COPY --from=build-env /etc/passwd /etc/passwd
COPY --from=build-env /etc/group /etc/group

# Copy your app from the builder stage
COPY --from=build-env /app /app

WORKDIR /app
USER <USERNAME>
CMD ["./app"]
```

**Remark:**

* The `/etc/passwd` and `/etc/group` files are required because distroless images do not include traditional user/group management tools.
* Make sure the `UID` and `GID` you assign are unprivileged and do not conflict with existing system users or groups.
* The `--chown` flag ensures that file ownership is correctly set in the final image during the copy process.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).