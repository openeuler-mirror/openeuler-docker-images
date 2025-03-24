# Calico

# Quick reference
- The Calico images based on openEuler for building Calico based Kubernetes pod netwrok.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build all images and push:
```shell
./build.sh
```

~~We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)~~ buildx is not supported in openEuler for now

2. Deploy:
```shell
kubectl apply -f calico-3.22.0-openEuler-21.09.yaml
```

# Supported tags

- 3.22.0-21.09: calico v3.22.0, openEuler 21.09
- 3.22.0-21.09-amd64: calico v3.22.0, openEuler 21.09 for x86_64
- 3.22.0-21.09-arm64: calico v3.22.0, openEuler 21.09 for aarch64


## Operating System
Linux/Unix, ARM64 or x86-64 architecture.

