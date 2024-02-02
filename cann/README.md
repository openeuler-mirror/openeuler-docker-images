# cann

# Quick reference

- The official cann docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/cann:$TAG" --platform linux/arm64 ./$TAG --push
```

We are using `buildx` in here to generate ARM64 images on different host, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image
Please run container with this image on Ascend platform of ARM64.
```shell
docker run --device $DEVICE --device /dev/davinci_manager --device /dev/devmm_svm --device /dev/hisi_hdc -v /usr/local/dcmi:/usr/local/dcmi -v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi -v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ -v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info -it openeuler/cann:$TAG
```

# Supported tags and respective Dockerfile links

- cann7.0.RC1.alpha002-oe2203sp2

## Operating System
Linux/Unix, ARM64 architecture.
