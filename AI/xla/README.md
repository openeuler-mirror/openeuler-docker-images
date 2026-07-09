# Quick reference

- The official xla docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# xla | openEuler
XLA (Accelerated Linear Algebra) is an open-source machine learning (ML) compiler for GPUs, CPUs, and ML accelerators.

The XLA compiler takes models from popular ML frameworks such as PyTorch, TensorFlow, and JAX, and optimizes them for high-performance execution across different hardware platforms including GPUs, CPUs, and ML accelerators.


# Supported tags and respective Dockerfile links
The tag of each xla docker image is consist of the version of xla and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3b0ff80-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/xla/3b0ff80/24.03-lts-sp4/Dockerfile) | xla 3b0ff80 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[3b0ff80-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/xla/3b0ff80/24.03-lts-sp3/Dockerfile) | xla 3b0ff80 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
This image provides a ready-to-use development environment for the XLA compiler. The XLA source code (commit 3b0ff80) is pre-cloned and pre-configured for CPU backend. Bazel is installed and ready. You just need to run the build.

Start a container and build XLA:

```
docker run -it --name xla-dev openeuler/xla:{Tag}
bazel build --spawn_strategy=sandboxed --test_output=all //xla/...
```

For GPU/CUDA support, run the container with GPU access, reconfigure, then build:

```
docker run -it --gpus all --name xla-dev openeuler/xla:{Tag}
python3 ./configure.py --backend=CUDA
bazel build --spawn_strategy=sandboxed --test_output=all //xla/...
```

To build only specific targets instead of the entire project:

```
bazel build --spawn_strategy=sandboxed //xla:xla_compile
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
