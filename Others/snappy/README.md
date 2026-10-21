# Quick reference

- The official snappy docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# snappy | openEuler
Current snappy docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Snappy is a compression/decompression library. It does not aim for maximum compression, or compatibility with any other compression library; instead, it aims for very high speeds and reasonable compression. For instance, compared to the fastest level of zlib, Snappy is an order of magnitude faster for most inputs, but the resulting compressed files are anywhere from 20% to 100% bigger.

Learn more on [Snappy - A fast compressor/decompressor](https://github.com/google/snappy).

# Supported tags and respective Dockerfile links
The tag of each `snappy` docker image is consist of the version of `snappy` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.1.7-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/snappy/1.1.7/24.03-lts-sp4/Dockerfile) | snappy 1.1.7 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/snappy` image from docker

	```bash
	docker pull openeuler/snappy:{Tag}
	```

- Check the installed snappy library version

	```bash
	docker run --rm openeuler/snappy:{Tag} pkg-config --modversion snappy
	```

- Compile a program against the snappy library

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/snappy:{Tag} \
	    g++ -O2 -o myapp myapp.cpp $(pkg-config --cflags --libs snappy)
	```

- Run the snappy unit benchmark inside the container

	```bash
	docker run --rm -it openeuler/snappy:{Tag} bash
	```

- Start a long-running container for exploration

	```bash
	docker run -d --name my-snappy openeuler/snappy:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-snappy
	```

- To get an interactive shell

	```bash
	docker exec -it my-snappy bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
