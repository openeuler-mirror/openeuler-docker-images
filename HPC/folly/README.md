# Quick reference

- The official Folly docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Folly | openEuler
Folly is an open-source C++ library developed and used at Facebook, providing a wide collection of reusable, high-performance components that supplement the C++ standard library and Boost.

Learn more on [Folly](https://github.com/facebook/folly).

# Supported tags and respective Dockerfile links
The tag of each `folly` docker image is consist of the version of `folly` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[2026.10.12.00-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/folly/2026.10.12.00/24.03-lts-sp4/Dockerfile)| Folly 2026.10.12.00 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/folly` image from docker

	```bash
	docker pull openeuler/folly:{Tag}
	```

- Start a container and open a shell

	```bash
	docker run -it --rm openeuler/folly:{Tag} bash
	```

- Compile and run a program against the installed Folly

	Folly is installed under `/usr/local`, so a program using it can be built with:

	```bash
	g++ -std=c++20 example.cpp -o example -lfolly -lglog -lgflags -lfmt -lpthread
	./example
	```

- Check the installed Folly headers and library

	```bash
	ls /usr/local/include/folly
	ls /usr/local/lib*/libfolly*
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
