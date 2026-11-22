# Quick reference

- The official libfuse docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# fuse | openEuler
Current fuse docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

FUSE (Filesystem in Userspace) is an interface for userspace programs to export a filesystem to the Linux kernel. The FUSE project consists of two components: the fuse kernel module (maintained in the regular kernel repositories) and the libfuse userspace library (maintained in this repository). libfuse provides the reference implementation for communicating with the FUSE kernel module.

This image ships the libfuse3 shared library, its development headers, the `fusermount3` and `mount.fuse3` helper programs, and the `fuse.conf` configuration file, all built from the official upstream source.

Learn more about libfuse, please visit [https://github.com/libfuse/libfuse](https://github.com/libfuse/libfuse).

# Supported tags and respective Dockerfile links
The tag of each `fuse` docker image is consist of the version of `fuse` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[3.16.2-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Storage/fuse/3.16.2/24.03-lts-sp4/Dockerfile) | libfuse 3.16.2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/fuse` image from docker

	```bash
	docker pull openeuler/fuse:{Tag}
	```

- Run the default command to show the installed libfuse version

	```bash
	docker run --rm openeuler/fuse:{Tag}
	```

	This prints the version of the bundled `fusermount3` helper, for example `fusermount3 version: 3.16.2`.

- Run with an interactive shell

	You can also start the container with an interactive shell to inspect the installed library, headers and tools.

	```bash
	docker run -it --rm openeuler/fuse:{Tag} bash
	```

- Keep a container running and attach to it

	Start a container in the background and use `docker logs` and `docker exec` to interact with it.

	```bash
	docker run -d --name my-fuse openeuler/fuse:{Tag} sleep infinity
	docker logs my-fuse
	docker exec -it my-fuse bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).