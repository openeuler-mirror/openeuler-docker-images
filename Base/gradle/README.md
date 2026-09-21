# Quick reference

- The official Gradle docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Gradle | openEuler
Current Gradle docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Gradle is a highly scalable build automation tool designed to handle everything from large, multi-project enterprise builds to quick development tasks across various languages. Gradle's modular, performance-oriented architecture seamlessly integrates with development environments, making it a go-to solution for building, testing, and deploying applications on Java, Kotlin, Scala, Android, Groovy, C++, and Swift.

Learn more on [Gradle by Develocity](https://gradle.org/).

# Supported tags and respective Dockerfile links
The tag of each `gradle` docker image is consist of the version of `gradle` and the version of basic image. The details are as follows

| Tags | Currently | Architectures |
|------|-----------|---------------|
| [9.7.1-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Base/gradle/9.7.1/24.03-lts-sp4/Dockerfile) | Gradle 9.7.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/gradle` image from docker

	```bash
	docker pull openeuler/gradle:{Tag}
	```

- Start an interactive Gradle instance

	```bash
	docker run -it --name my-gradle openeuler/gradle:{Tag}
	```

- Run a Gradle build against the project in the current directory

	```bash
	docker run --rm -v "$PWD":/workspace -w /workspace openeuler/gradle:{Tag} gradle build
	```

- Check the logs of the running container

	```bash
	docker logs -f my-gradle
	```

- Execute a Gradle command in the running container

	```bash
	docker exec -it my-gradle gradle --version
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
