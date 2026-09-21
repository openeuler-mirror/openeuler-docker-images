# Quick reference

- The official Hertz docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Hertz | openEuler
Current Hertz docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Hertz [həːts] is a high-usability, high-performance and high-extensibility Golang HTTP framework that helps developers build microservices.

`hz` is the official code generation tool for the Hertz HTTP framework. It parses IDL (Interface Definition Language) files — Thrift or Protobuf — and generates a complete, scaffolded Hertz project including handlers, routers, models, and client code.

Learn more on [CloudWeGo](https://www.cloudwego.io/).

# Supported tags and respective Dockerfile links
The tag of each `hertz` docker image is consist of the version of `hertz` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[0.10.6-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/hertz/0.10.6/24.03-lts-sp4/Dockerfile) | Hertz 0.10.6 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/hertz` image from docker

	```bash
	docker pull openeuler/hertz:{Tag}
	```

- Check the installed hz version

	```bash
	docker run --rm openeuler/hertz:{Tag} hz --version
	```

- Generate a new Hertz project from a Thrift IDL

	Place `api.thrift` in the current directory and run:

	```bash
	docker run --rm -v "$(pwd)":/workspace openeuler/hertz:{Tag} \
	    hz new --idl api.thrift --module github.com/example/myservice
	```

	The scaffolded project is written to the current directory.

- Update an existing project after IDL changes

	```bash
	docker run --rm -v "$(pwd)":/workspace openeuler/hertz:{Tag} \
	    hz update --idl api.thrift
	```

- Generate model code only

	```bash
	docker run --rm -v "$(pwd)":/workspace openeuler/hertz:{Tag} \
	    hz model --idl api.thrift
	```

- Generate Hertz HTTP client code

	```bash
	docker run --rm -v "$(pwd)":/workspace openeuler/hertz:{Tag} \
	    hz client --idl api.thrift --base_domain localhost:8888
	```

- Start a long-running container for exploration

	```bash
	docker run -d --name my-hertz openeuler/hertz:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-hertz
	```

- To get an interactive shell

	```bash
	docker exec -it my-hertz bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
