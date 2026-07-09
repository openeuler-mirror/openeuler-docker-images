# Quick reference

- The official jax docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# jax | openEuler
JAX is a Python library for accelerator-oriented array computation and program transformation, designed for high-performance numerical computing and large-scale machine learning. JAX can automatically differentiate native Python and NumPy functions. It supports reverse-mode differentiation via jax.grad as well as forward-mode differentiation, and the two can be composed arbitrarily to any order. JAX uses XLA to compile and scale NumPy programs on TPUs, GPUs, and other hardware accelerators.


# Supported tags and respective Dockerfile links
The tag of each jax docker image is consist of the version of jax and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.10.1-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/hpc/jax/0.10.1/24.03-lts-sp4/Dockerfile) | jax 0.10.1 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[0.10.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/hpc/jax/0.10.1/24.03-lts-sp3/Dockerfile) | jax 0.10.1 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
To pull the jax image from the Docker Hub:

```
docker pull openeuler/jax:{Tag}
```

To run the jax container:

```
docker run -it --rm openeuler/jax:{Tag} python3 -c "import jax; import jax.numpy as jnp; print(jnp.ones((3, 4)))"
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
