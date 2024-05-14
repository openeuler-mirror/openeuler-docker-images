# Mlflow

# Quick reference

- The official mlflow docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/mlflow:$TAG" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:

Specify a port in your host so that you can access the Web UI at 127.0.0.1:{YOUR_PORT}.
```shell
docker run -it --name mlflow -p {YOUR_PORT}:5000 openeuler/mlflow:{TAG}
```

If you want to store the data permanently, add the parameter "-v" and specify a directory in your host.
```shell
docker run -it --name mlflow -p {YOUR_PORT}:5000 -v {DIR_IN_YOUR_HOST}:/mlflow openeuler/mlflow:{TAG}
```
Please make sure the DIR_IN_YOUR_HOST is writable. Maybe you should run the commands below before the ```docker run -v```.
```shell
mkdir {DIR_IN_YOUR_HOST}
chmod 777 {DIR_IN_YOUR_HOST}
```

# Supported tags and respective Dockerfile links

- 2.11.1-oe2203sp3: mlflow v2.11.1, openEuler 22.03-LTS-SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
