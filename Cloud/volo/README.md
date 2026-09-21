# Quick reference

- The official Volo docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Volo | openEuler
Current Volo docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Volo is a **high-performance** and **strong-extensibility** Rust RPC framework that helps developers build microservices.

The `volo-cli` command line tool provides the ability to generate default project layout and manage the idls used. This image provides the `volo` command line tool.

Learn more on [CloudWeGo](https://www.cloudwego.io/).

# Supported tags and respective Dockerfile links
The tag of each `volo` docker image is consist of the version of `volo` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[0.12.2-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/volo/0.12.2/24.03-lts-sp4/Dockerfile) | Volo 0.12.2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/volo` image from docker

	```bash
	docker pull openeuler/volo:{Tag}
	```

- Check the installed volo version

	```bash
	docker run --rm openeuler/volo:{Tag} volo --version
	```

- Initialize a Volo project

	Place `idl/volo_example.thrift` in the current directory and run:

	```bash
	docker run --rm -v "$(pwd)":/workspace -w /workspace openeuler/volo:{Tag} \
	    volo init volo-example idl/volo_example.thrift
	```

	The generated project is written to the current directory.

- Start a long-running container for exploration

	```bash
	docker run -d --name my-volo openeuler/volo:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-volo
	```

- To get an interactive shell

	```bash
	docker exec -it my-volo bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
