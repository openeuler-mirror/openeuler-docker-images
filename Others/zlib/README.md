# Quick reference

- The official zlib docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# zlib | openEuler
Current zlib docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

zlib is a general purpose data compression library. All the code is thread safe (though see the FAQ for caveats). The data format used by the zlib library is described by RFCs (Request for Comments) 1950 to 1952: RFC 1950 (zlib format), RFC 1951 (deflate format) and RFC 1952 (gzip format).

Learn more on [zlib Home Site](https://zlib.net/).

# Supported tags and respective Dockerfile links
The tag of each `zlib` docker image is consist of the version of `zlib` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.4-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/zlib/1.4/24.03-lts-sp4/Dockerfile) | zlib 1.4 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/zlib` image from docker

	```bash
	docker pull openeuler/zlib:{Tag}
	```

- Check the installed zlib library version

	```bash
	docker run --rm openeuler/zlib:{Tag} pkg-config --modversion zlib
	```

- Show the compiler and linker flags for the zlib library

	```bash
	docker run --rm openeuler/zlib:{Tag} pkg-config --cflags --libs zlib
	```

- Start a long-running container for exploration

	```bash
	docker run -d --name my-zlib openeuler/zlib:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-zlib
	```

- To get an interactive shell

	```bash
	docker exec -it my-zlib bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).