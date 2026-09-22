# Quick reference

- The official MFEM docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# mfem | openEuler

MFEM is a modular parallel C++ library for finite element methods. Its goal is to enable high-performance scalable finite element discretization research and application development on a wide variety of platforms, ranging from laptops to supercomputers.

Learn more on [MFEM - Finite Element Discretization Library](https://mfem.org).

# Supported tags and respective Dockerfile links

The tag of each `mfem` docker image is consist of the version of `mfem` and the version of basic image. The details are as follows

| Tags | Currently | Architectures |
|------|-----------|---------------|
| [4.1-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/mfem/4.1/24.03-lts-sp4/Dockerfile) | MFEM 4.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

Here, users can select the corresponding `{Tag}` by requirements.

- Pull the `openeuler/mfem` image from docker

	```bash
	docker pull openeuler/mfem:{Tag}
	```

- Start an interactive MFEM instance

	```bash
	docker run -it --name my-mfem openeuler/mfem:{Tag}
	```

- Run the MFEM example 1 with GLVis visualization disabled

	```bash
	docker run --rm openeuler/mfem:{Tag} /usr/local/share/mfem/examples/ex1 -no-vis -m /usr/local/share/mfem/data/star.mesh
	```

- Check the logs of the running container

	```bash
	docker logs -f my-mfem
	```

- Execute an MFEM example in the running container

	```bash
	docker exec -it my-mfem /usr/local/share/mfem/examples/ex1 -no-vis -m /usr/local/share/mfem/data/star.mesh
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
