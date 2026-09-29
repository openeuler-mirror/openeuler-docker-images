# Quick reference

- The official JUnit docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# JUnit5 | openEuler
Current JUnit docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

JUnit 6 is the current generation of the JUnit testing framework, which provides a modern foundation for developer-side testing on the JVM. It requires Java 17 and Kotlin 2.1 or above and enables many different styles of testing.

Learn more on [JUnit](https://junit.org/).

# Supported tags and respective Dockerfile links
The tag of each `junit5` docker image is consist of the version of `junit5` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [6.1.3-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/junit5/6.1.3/24.03-lts-sp4/Dockerfile) | JUnit 6.1.3 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/junit5` image from docker

	```bash
	docker pull openeuler/junit5:{Tag}
	```

- Run tests with the JUnit Platform Console Launcher

	```bash
	docker run --rm -v "$PWD":/workspace -w /workspace openeuler/junit5:{Tag} execute --class-path target/test-classes --scan-class-path
	```

- Start a JUnit container

	```bash
	docker run -it --name my-junit --entrypoint /bin/bash openeuler/junit5:{Tag}
	```

- View container running logs

	```bash
	docker logs -f my-junit
	```

- To get an interactive shell

	```bash
	docker exec -it my-junit /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
