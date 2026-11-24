# Quick reference

- The official openEuler docker image of Spring Cloud Gateway.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Spring Cloud Gateway | openEuler

Current Spring Cloud Gateway docker images are built on [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Spring Cloud Gateway provides an API gateway built on the Spring ecosystem: routing, path rewriting, load balancing, rate limiting and other cross-cutting concerns for microservices.

The image runs the upstream release-train stack on openEuler: gateway components are resolved by the official `spring-cloud-dependencies` BOM (release train 2025.1.x, which pins gateway 5.0.4 on Spring Boot 4.0.9). The container entrypoint is a thin Spring Boot launcher that wraps the BOM-managed upstream starter; no upstream code is modified or recompiled.

Learn more on [Spring](https://spring.io/projects/spring-cloud-gateway).

# Supported tags and respective Dockerfile links

The tag of each `spring-cloud-gateway` docker image consists of the version of Spring Cloud Gateway and the version of the base image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[5.0.4-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/spring-cloud-gateway/5.0.4/24.03-lts-sp4/Dockerfile) | Spring Cloud Gateway 5.0.4 (train 2025.1.4) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/spring-cloud-gateway` image from docker

	```bash
	docker pull openeuler/spring-cloud-gateway:{Tag}
	```

- Check the image version

	```bash
	docker run --rm openeuler/spring-cloud-gateway:{Tag} cat /app/IMAGE_VERSION
	```

- Start the gateway with a custom route configuration

	Write your gateway configuration to `application.yml` in the current directory:

	```yaml
	management:
	  endpoints:
	    web:
	      exposure:
	        include: health,info,gateway
	spring:
	  cloud:
	    gateway:
	      server:
	        webflux:
	          routes:
	            - id: demo
	              uri: http://example.com:8080
	              predicates:
	                - Path=/demo/**
	              filters:
	                - StripPrefix=1
	```

	Then mount it into the container:

	```bash
	docker run -d --name my-gateway -p 8080:8080 \
	    -v "$(pwd)/application.yml:/app/config/application.yml:ro" \
	    openeuler/spring-cloud-gateway:{Tag}
	```

- Verify the gateway is healthy

	```bash
	curl http://127.0.0.1:8080/actuator/health
	```

- Inspect the active routes

	```bash
	curl http://127.0.0.1:8080/actuator/gateway/routes
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
