# Quick reference

- The official openEuler docker image of Spring Cloud Kubernetes.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Spring Cloud Kubernetes | openEuler

Current Spring Cloud Kubernetes docker images are built on [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Spring Cloud Kubernetes provides Kubernetes-native integration for Spring Cloud applications: service discovery backed by Kubernetes endpoints, configuration loaded from ConfigMaps/Secrets and Ribbon-style load balancing between pods.

The image bundles the upstream release-train stack on openEuler: the starter is resolved by the official `spring-cloud-dependencies` BOM (release train 2026.0.x, which pins spring-cloud-kubernetes 5.1.0 on Spring Boot 4.2.0). The container entrypoint is a thin Spring Boot launcher that wraps the BOM-managed upstream starter; no upstream code is modified or recompiled.

Kubernetes integration is **disabled** in the image default so the container can start outside a cluster. Enable it through the mounted `/app/config/application.yml` (or environment variables) when running inside Kubernetes.

Learn more on [Spring](https://spring.io/projects/spring-cloud-kubernetes).

# Supported tags and respective Dockerfile links

The tag of each `spring-cloud-kubernetes` docker image consists of the version of Spring Cloud Kubernetes and the version of the base image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[5.1.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/spring-cloud-kubernetes/5.1.0/24.03-lts-sp4/Dockerfile) | Spring Cloud Kubernetes 5.1.0 (train 2026.0.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/spring-cloud-kubernetes` image from docker

	```bash
	docker pull openeuler/spring-cloud-kubernetes:{Tag}
	```

- Check the image version

	```bash
	docker run --rm openeuler/spring-cloud-kubernetes:{Tag} cat /app/IMAGE_VERSION
	```

- Verify the container is healthy (integration disabled by default)

	```bash
	docker run -d --name my-k8s-client -p 8080:8080 \
	    openeuler/spring-cloud-kubernetes:{Tag}
	curl http://127.0.0.1:8080/actuator/health
	```

- Run inside a Kubernetes cluster

	Mount a configuration file that enables the integration, for example:

	```yaml
	spring:
	  cloud:
	    kubernetes:
	      enabled: true
	```

	```bash
	docker run -d --name my-k8s-client -p 8080:8080 \
	    -v "$(pwd)/application.yml:/app/config/application.yml" \
	    openeuler/spring-cloud-kubernetes:{Tag}
	```

	For application-embedded usage, add `spring-cloud-starter-kubernetes-client` to your own Maven build instead:

	```xml
	<dependency>
	    <groupId>org.springframework.cloud</groupId>
	    <artifactId>spring-cloud-starter-kubernetes-client</artifactId>
	</dependency>
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
