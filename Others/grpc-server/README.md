# Quick reference

- The official Grpc Server docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Grpc Server | openEuler
Current Grpc Server docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

In gRPC, a client application can directly call a method on a server application on a different machine as if it were a local object, making it easier for you to create distributed applications and services. 
As in many RPC systems, gRPC is based around the idea of defining a service, specifying the methods that can be called remotely with their parameters and return types. 
On the server side, the server implements this interface and runs a gRPC server to handle client calls. On the client side, the client has a stub (referred to as just a client in some languages) that provides the same methods as the server.

Learn more about Grpc Server on [Grpc Website](https://grpc.io/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `grpc-server` docker image is consist of the version of `grpc-server` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.72.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/grpc-server/1.72.0/24.03-lts-sp1/Dockerfile)| Grpc Server 1.72.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/grpc-server` image from docker

	```bash
	docker pull openeuler/grpc-server:{Tag}
	```

- Start a grpc-server instance

	```bash
	docker run -d --name my-grpc-server -p 50051:50051 openeuler/grpc-server:{Tag}
	```
    After `my-grpc-server` is started, access the service through `http://localhost:50051`.
    
- View container running logs

	```bash
	docker logs -f my-grpc-server
	```

- To get an interactive shell

	```bash
	docker run -it --rm openeuler/grpc-server:{Tag} bash
	```
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).