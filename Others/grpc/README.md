# Quick reference

- The official gRPC C++ docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# gRPC | openEuler
Current gRPC docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

gRPC is a modern, open source, high performance Remote Procedure Call (RPC) framework that can run in any environment. It efficiently connects services across and within data centers with support for load balancing, tracing, health checking and authentication.

This image builds the gRPC C++ core from the upstream [grpc/grpc](https://github.com/grpc/grpc) release and ships the hello-world `greeter_server` (port 50051) and `greeter_client` for a quick functional check.

# Supported tags and respective Dockerfile links
The tag of each `grpc` docker image is consist of the version of `grpc` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.85.4-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/grpc/1.85.4/24.03-lts-sp4/Dockerfile) | grpc 1.85.4 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/grpc` image from docker

	```bash
	docker pull openeuler/grpc:{Tag}
	```

- Start a gRPC hello-world instance

	```bash
	docker run -d --name my-grpc -p 50051:50051 openeuler/grpc:{Tag}
	```
    After `my-grpc` is started, connect a gRPC client to `localhost:50051` (50051 is the gRPC port, not HTTP).

- Verify the round trip inside the container

	```bash
	docker exec -it my-grpc greeter_client --target=localhost:50051
	```
    Expected output: `Greeter received: Hello world`

- View container running logs

	```bash
	docker logs -f my-grpc
	```

- To get an interactive shell

	```bash
	docker run -it --rm openeuler/grpc:{Tag} bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
