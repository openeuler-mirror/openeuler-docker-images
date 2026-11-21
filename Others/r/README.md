# Quick reference

- The official R docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# R | openEuler
Current R docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

R is a free software environment for statistical computing and graphics. It compiles and runs on a wide variety of UNIX platforms, Windows and MacOS.

Learn more on [R: The R Project for Statistical Computing](https://www.r-project.org/).

# Supported tags and respective Dockerfile links
The tag of each R docker image is consist of the version of R and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[4.0.5-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/r/4.0.5/24.03-lts-sp4/Dockerfile) | r 4.0.5 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/r` image from docker

	```bash
	docker pull openeuler/r:{Tag}
	```

- Start an interactive R container

	```bash
	docker run -it --name my-r openeuler/r:{Tag}
	```

- Run an R script

	Create a file named `script.R`:

	```r
	print("Hello, R!")
	```

	Then run it with the current directory mounted:

	```bash
	docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp openeuler/r:{Tag} Rscript script.R
	```

- View container running logs

	```bash
	docker logs -f my-r
	```

- To get an interactive shell

	```bash
	docker exec -it my-r /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
