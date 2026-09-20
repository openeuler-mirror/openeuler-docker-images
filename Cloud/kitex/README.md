# Quick reference

- The official Kitex docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Kitex | openEuler
Current Kitex docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Kitex [kaɪt'eks] is a **high-performance** and **strong-extensibility** Go RPC framework that helps developers build microservices.

Kitex has built-in code generation tools that support generating **Thrift**, **Protobuf**, and scaffold code. This image provides the `kitex` command line tool for code generation.

Learn more on [CloudWeGo](https://www.cloudwego.io/).

# Supported tags and respective Dockerfile links
The tag of each `kitex` docker image is consist of the version of `kitex` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[0.14.5-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/kitex/0.14.5/24.03-lts-sp4/Dockerfile) | Kitex 0.14.5 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/kitex` image from docker

	```bash
	docker pull openeuler/kitex:{Tag}
	```

- Check the installed kitex version

	```bash
	docker run --rm openeuler/kitex:{Tag} kitex --version
	```

- Generate code from a Thrift IDL

	Place `example.thrift` in the current directory and run:

	```bash
	docker run --rm -v "$(pwd)":/workspace openeuler/kitex:{Tag} \
	    kitex -module example.com/hello example.thrift
	```

	The generated code is written to the `kitex_gen` directory under the current directory.

- Generate a server scaffold from a Thrift IDL

	```bash
	docker run --rm -v "$(pwd)":/workspace openeuler/kitex:{Tag} \
	    kitex -module example.com/hello -service hello example.thrift
	```

- Start a long-running container for exploration

	```bash
	docker run -d --name my-kitex openeuler/kitex:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-kitex
	```

- To get an interactive shell

	```bash
	docker exec -it my-kitex bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
