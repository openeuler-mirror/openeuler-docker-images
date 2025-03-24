# Intel® oneAPI Runtime Library

# Quick reference
Intel® oneAPI products will deliver the tools needed to deploy applications and solutions across scalar, vector, matrix, and spatial (SVMS) architectures. Its set of complementary toolkits—a base kit and specialty add-ons—simplify programming and help developers improve efficiency and innovation.

The openEuler oneAPI docker image created on top of openEuler 24.03 LTS release and maintained oneAPI tookit including basekit, runtime, etc.

- Maintained by: [openEuler Intelligence SIG](https://gitee.com/openeuler/community/tree/master/sig/sig-intelligence)

- Where to get help: [openEuler Intelligence SIG](https://gitee.com/openeuler/community/tree/master/sig/sig-intelligence), [openEuler Intel Arch SIG](https://gitee.com/openeuler/community/tree/master/sig/sig-Intel-Arch)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/oneapi-runtime:$TAG" -f oneapi-runtime/2024.2.0/24.03-lts/Dockerfiler .  # oneAPI Runtime library
```

# How to use this image
## Intel® oneAPI Runtime Libraries
Get started running or deploying applications built with oneAPI toolkits.
```shell
image=openeuler/oneapi-runtime:$TAG
docker pull "$image"
docker run --device=/dev/dri -it "$image"
```

# Supported tags and respective Dockerfile links

- 2024.2.0-oe2403lts

## Operating System
Linux/Unix
