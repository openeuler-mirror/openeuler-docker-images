# Quick reference

- The official openEuler docker image of Spring Cloud Config Server.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Spring Cloud Config Server | openEuler

Current Spring Cloud Config Server docker images are built on [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Spring Cloud Config Server provides centralized external configuration for distributed systems: it serves configuration from git repositories, local (native) directories or vault, supports encryption/decryption of property values and hot refresh for connected clients.

The image runs the upstream release-train stack on openEuler: config-server is resolved by the official `spring-cloud-dependencies` BOM (release train 2025.1.x, which pins config-server 5.0.6 on Spring Boot 4.0.9). The container entrypoint is a thin Spring Boot launcher that wraps the BOM-managed upstream artifact; no upstream code is modified or recompiled.

Learn more on [Spring](https://spring.io/projects/spring-cloud-config).

# Supported tags and respective Dockerfile links

The tag of each `spring-cloud-config` docker image consists of the version of Spring Cloud Config Server and the version of the base image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[5.0.6-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/spring-cloud-config/5.0.6/24.03-lts-sp4/Dockerfile) | Spring Cloud Config Server 5.0.6 (train 2025.1.4) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/spring-cloud-config` image from docker

	```bash
	docker pull openeuler/spring-cloud-config:{Tag}
	```

- Check the image version

	```bash
	docker run --rm openeuler/spring-cloud-config:{Tag} cat /app/IMAGE_VERSION
	```

- Serve configuration from a git repository

	```bash
	docker run -d --name my-config-server -p 8888:8888 \
	    -e SPRING_CLOUD_CONFIG_SERVER_GIT_URI=https://github.com/myorg/my-config-repo \
	    openeuler/spring-cloud-config:{Tag}
	```

	Fetch the configuration of application `myapp` with profile `prod`:

	```bash
	curl http://127.0.0.1:8888/myapp/prod
	```

- Serve configuration from a local directory (native profile)

	```bash
	docker run -d --name my-config-server -p 8888:8888 \
	    -e SPRING_PROFILES_ACTIVE=native \
	    -e SPRING_CLOUD_CONFIG_SERVER_NATIVE_SEARCHLOCATIONS=file:/config-repo \
	    -v "$(pwd)/config-repo:/config-repo:ro" \
	    openeuler/spring-cloud-config:{Tag}
	```

- Encrypt a property value (requires a symmetric key)

	```bash
	docker run -d --name my-config-server -p 8888:8888 \
	    -e ENCRYPT_KEY=my-symmetric-key \
	    openeuler/spring-cloud-config:{Tag}

	curl --data-binary 'my-secret' -H 'Content-Type: text/plain' \
	    http://127.0.0.1:8888/encrypt
	```

- Verify the server is healthy

	```bash
	curl http://127.0.0.1:8888/actuator/health
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
