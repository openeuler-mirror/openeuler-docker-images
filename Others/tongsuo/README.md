
# Quick reference

- The official Tongsuo docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Tongsuo | openEuler
Current Tongsuo docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Tongsuo (铜锁) is an open-source foundational cryptographic library that provides modern cryptographic algorithms and secure communication protocols. It delivers underlying cryptographic capabilities for storage, networking, key management, privacy computing, and many other business scenarios, enabling confidentiality, integrity, and authentication of data during transmission, usage, and storage, providing privacy and security protection throughout the data lifecycle.

Learn more on [铜锁开源密码库 · 语雀](https://www.yuque.com/tsdoc).

# Supported tags and respective Dockerfile links
The tag of each `Tongsuo` docker image is consist of the version of `Tongsuo` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[8.4.0-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/Tongsuo/8.4.0/24.03-lts-sp4/Dockerfile) | Tongsuo 8.4.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[8.4.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/Tongsuo/8.4.0/24.03-lts-sp3/Dockerfile) | Tongsuo 8.4.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/tongsuo` image from docker

	```bash
	docker pull openeuler/tongsuo:{Tag}
	```

- View Tongsuo version

	```bash
	docker run --rm openeuler/tongsuo:{Tag} tongsuo version
	```

- Run speed benchmark

	```bash
	docker run --rm openeuler/tongsuo:{Tag} tongsuo speed
	```

- Run with an interactive shell

	```bash
	docker run -it --rm openeuler/tongsuo:{Tag} bash
	```

	Inside the container, `tongsuo` can be used as a drop-in replacement for OpenSSL, supporting TLS/SSL connections, certificate management, encryption/decryption, digest computation, etc. For example:

	```bash
	tongsuo help
	tongsuo version
	tongsuo speed sm2
	tongsuo speed sm3
	tongsuo speed sm4
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
