# Quick reference

- The official Erlang/OTP docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Erlang | openEuler

Current Erlang/OTP docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Erlang is a programming language and runtime system for building massively scalable soft real-time systems with requirements on high availability.

OTP is a set of Erlang libraries, which consists of the Erlang runtime system, a number of ready-to-use components mainly written in Erlang, and a set of design principles for Erlang programs.

Learn more on [Index - Erlang/OTP](https://www.erlang.org/).

# Supported tags and respective Dockerfile links

The tag of each Erlang docker image is consist of the version of Erlang and the version of basic image. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[29.1-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/erlang/29.1/24.03-lts-sp4/Dockerfile) | erlang 29.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

- Pull the image

	```
	docker pull openeuler/erlang:{Tag}
	```

- Start an Erlang shell

	```
	docker run -it --name my-erlang openeuler/erlang:{Tag}
	```

- Compile and run an Erlang module

	Save the following example as `hello.erl`:

	```erlang
	-module(hello).
	-export([world/0]).

	world() -> io:format("Hello, world\n").
	```

	Then start a container with the current directory mounted and open the Erlang shell:

	```
	docker run -it --rm -v "$PWD":/workspace -w /workspace openeuler/erlang:{Tag}
	```

	Inside the shell, compile and run the module:

	```
	1> c(hello).
	{ok,hello}
	2> hello:world().
	Hello, world
	ok
	```

- View container running logs

	```
	docker logs -f my-erlang
	```

- To get an interactive shell

	```
	docker exec -it my-erlang /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
