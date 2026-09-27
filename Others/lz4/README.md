# Quick reference

- The official lz4 docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# lz4 | openEuler
Current lz4 docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

LZ4 is lossless compression algorithm, providing compression speed > 500 MB/s per core, scalable with multi-cores CPU. It features an extremely fast decoder, with speed in multiple GB/s per core, typically reaching RAM speed limits on multi-core systems.

Learn more on [LZ4 - Extremely fast compression](https://lz4.github.io/lz4/).

# Supported tags and respective Dockerfile links
The tag of each `lz4` docker image is consist of the version of `lz4` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.10.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/lz4/1.10.0/24.03-lts-sp4/Dockerfile) | lz4 1.10.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/lz4` image from docker

	```bash
	docker pull openeuler/lz4:{Tag}
	```

- Check the installed lz4 version

	```bash
	docker run --rm openeuler/lz4:{Tag} lz4 --version
	```

- Compress a file

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/lz4:{Tag} \
	    lz4 -f input.txt input.txt.lz4
	```

- Decompress a file

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/lz4:{Tag} \
	    lz4 -d -f input.txt.lz4 input.txt
	```

- Test the integrity of a compressed file

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/lz4:{Tag} \
	    lz4 -t input.txt.lz4
	```

- Run the built-in in-memory benchmark on a file

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/lz4:{Tag} \
	    lz4 -b1 input.txt
	```

- Start a long-running container for exploration

	```bash
	docker run -d --name my-lz4 openeuler/lz4:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-lz4
	```

- To get an interactive shell

	```bash
	docker exec -it my-lz4 bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
