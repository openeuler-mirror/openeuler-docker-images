# Quick reference

- The official zstd docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# zstd | openEuler
Current zstd docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Zstandard (zstd) is a fast lossless compression algorithm, targeting real-time compression scenarios at zlib-level and better compression ratios. It also provides a very fast decoder, and is used as a general-purpose compression library.

Learn more on [Zstandard](https://facebook.github.io/zstd/).

# Supported tags and respective Dockerfile links
The tag of each `zstd` docker image is consist of the version of `zstd` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.5.7-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/zstd/1.5.7/24.03-lts-sp4/Dockerfile) | zstd 1.5.7 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/zstd` image from docker

	```bash
	docker pull openeuler/zstd:{Tag}
	```

- Check the installed zstd version

	```bash
	docker run --rm openeuler/zstd:{Tag} zstd --version
	```

- Compress a file

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/zstd:{Tag} \
	    zstd -f input.txt -o input.txt.zst
	```

- Decompress a file

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/zstd:{Tag} \
	    zstd -d -f input.txt.zst -o input.txt
	```

- Test the integrity of a compressed file

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/zstd:{Tag} \
	    zstd -t input.txt.zst
	```

- Build against `libzstd` from pkg-config

	The image ships `libzstd` with its headers and `libzstd.pc`, so a C program can be built with:

	```bash
	gcc example.c -o example $(pkg-config --cflags --libs libzstd)
	```

- Start a long-running container for exploration

	```bash
	docker run -d --name my-zstd openeuler/zstd:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-zstd
	```

- To get an interactive shell

	```bash
	docker exec -it my-zstd bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
