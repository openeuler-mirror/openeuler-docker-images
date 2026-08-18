# Quick reference

- The official protobuf docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# protobuf | openEuler
Current protobuf docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Protocol Buffers (a.k.a., protobuf) are Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data.

Learn more on [Protocol Buffers Documentation](https://protobuf.dev/).

# Supported tags and respective Dockerfile links
The tag of each `protobuf` docker image is consist of the version of `protobuf` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[36.0-rc2-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/protobuf/36.0-rc2/24.03-lts-sp4/Dockerfile) | protobuf 36.0-rc2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/protobuf` image from docker

	```bash
	docker pull openeuler/protobuf:{Tag}
	```

- Check the installed protoc version

	```bash
	docker run --rm openeuler/protobuf:{Tag} protoc --version
	```

- Compile a `.proto` file

	Create a `person.proto` file in the current directory:

	```proto
	syntax = "proto3";

	message Person {
	  string name = 1;
	  int32 id = 2;
	  string email = 3;
	}
	```

	Generate C++ source code from the proto file with the `protoc` compiler:

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/protobuf:{Tag} \
	    protoc --cpp_out=. person.proto
	```

	The generated files `person.pb.h` and `person.pb.cc` are written to the current directory.

- Start a long-running container for exploration

	```bash
	docker run -d --name my-protobuf openeuler/protobuf:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-protobuf
	```

- To get an interactive shell

	```bash
	docker exec -it my-protobuf bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
