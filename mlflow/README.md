# Mlflow

# Quick reference

- The official mlflow docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push: (you may need to replace "openeuler" with your own repo name.)
```shell
docker buildx build -t "openeuler/mlflow:$TAG" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

2. Run:

Specify a port in your host so that you can access the Web UI at 127.0.0.1:{YOUR_PORT}.
```shell
docker run -it --name mlflow -p {YOUR_PORT}:5000 openeuler/mlflow:{TAG}
```

If you want to store the data permanently, use parameter ```-v``` to specify a volume such as ```mlruns```.
```shell
docker run -it --name mlflow -p {YOUR_PORT}:5000 -v mlruns:/mlflow openeuler/mlflow:{TAG}
```

# Supported tags and respective Dockerfile links

- 2.11.1-oe2203sp3: mlflow v2.11.1, openEuler 22.03-LTS-SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
