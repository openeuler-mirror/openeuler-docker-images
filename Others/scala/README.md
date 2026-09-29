# Quick reference

- The official Scala docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Scala | openEuler
Current Scala docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

This is the home of the Scala 2 standard library, compiler, and language spec.

Learn more on [The Scala Programming Language](https://www.scala-lang.org/).

# Supported tags and respective Dockerfile links
The tag of each Scala docker image is consist of the version of Scala and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.13.18-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/scala/2.13.18/24.03-lts-sp4/Dockerfile) | scala 2.13.18 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/scala` image from docker

	```bash
	docker pull openeuler/scala:{Tag}
	```

- Start an interactive Scala shell (REPL) container

	```bash
	docker run -it --name my-scala openeuler/scala:{Tag}
	```

- Compile and run a Scala program

	Create a file named `Hello.scala`:

	```scala
	object Hello {
	  def main(args: Array[String]): Unit = println("Hello, Scala!")
	}
	```

	Then compile and run it with the current directory mounted:

	```bash
	docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp openeuler/scala:{Tag} scalac Hello.scala
	docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp openeuler/scala:{Tag} scala Hello
	```

- View container running logs

	```bash
	docker logs -f my-scala
	```

- To get an interactive shell

	```bash
	docker exec -it my-scala /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
