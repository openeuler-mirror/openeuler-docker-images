# Quick reference

- The official openEuler docker image of Spring Cloud Vault.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Spring Cloud Vault | openEuler

Current Spring Cloud Vault docker images are built on [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Spring Cloud Vault provides HashiCorp Vault integration for Spring Boot applications: it reads secrets from Vault at bootstrap time and exposes them through the Spring Environment with property-source abstractions.

The image bundles the upstream release-train stack on openEuler: the starter is resolved by the official `spring-cloud-dependencies` BOM (release train 2026.0.x, which pins spring-cloud-vault 5.1.0 on Spring Boot 4.2.0). The container entrypoint is a thin Spring Boot launcher that wraps the BOM-managed upstream starter; no upstream code is modified or recompiled.

Vault integration is **disabled** in the image default so the container can start standalone. Enable it through the mounted `/app/config/application.yml` (or environment variables) when a Vault server is available.

Learn more on [Spring](https://spring.io/projects/spring-cloud-vault).

# Supported tags and respective Dockerfile links

The tag of each `spring-cloud-vault` docker image consists of the version of Spring Cloud Vault and the version of the base image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[5.1.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/spring-cloud-vault/5.1.0/24.03-lts-sp4/Dockerfile) | Spring Cloud Vault 5.1.0 (train 2026.0.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/spring-cloud-vault` image from docker

	```bash
	docker pull openeuler/spring-cloud-vault:{Tag}
	```

- Check the image version

	```bash
	docker run --rm openeuler/spring-cloud-vault:{Tag} cat /app/IMAGE_VERSION
	```

- Verify the container is healthy (integration disabled by default)

	```bash
	docker run -d --name my-vault-client -p 8080:8080 \
	    openeuler/spring-cloud-vault:{Tag}
	curl http://127.0.0.1:8080/actuator/health
	```

- Read secrets from a Vault server

	Mount a configuration file that enables the integration, for example:

	```yaml
	spring:
	  cloud:
	    vault:
	      enabled: true
	      uri: http://vault-server:8200
	      authentication: TOKEN
	      token: <your-token>
	```

	```bash
	docker run -d --name my-vault-client -p 8080:8080 \
	    -v "$(pwd)/application.yml:/app/config/application.yml" \
	    openeuler/spring-cloud-vault:{Tag}
	```

	For application-embedded usage, add `spring-cloud-starter-vault-config` to your own Maven build instead:

	```xml
	<dependency>
	    <groupId>org.springframework.cloud</groupId>
	    <artifactId>spring-cloud-starter-vault-config</artifactId>
	</dependency>
	```

- Known behavior notes

	- The git-style environment variable mapping applies to Vault properties too: `spring.cloud.vault.<property>` with hyphens must be written camelCase in env vars (e.g. `SPRING_CLOUD_VAULT_URI` for `spring.cloud.vault.uri`).

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
