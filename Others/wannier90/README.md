# Quick reference

- The official wannier90 docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# wannier90 | openEuler
The home of maximally-localised Wannier functions (MLWFs) and Wannier90, the computer program that calculates them. The Maximally-Localised Generalised Wannier Functions Code.

Learn more on [Wannier90](https://www.wannier.org).

# Supported tags and respective Dockerfile links
The tag of each wannier90 docker image is consist of the version of wannier90 and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[4.0.2-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/wannier90/4.0.2/24.03-lts-sp4/Dockerfile) | wannier90 4.0.2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/wannier90` image from docker

	```bash
	docker pull openeuler/wannier90:{Tag}
	```

- Start a wannier90 container instance, running the program on a `<seedname>.win` file in the current directory

	```bash
	docker run --name wannier90 --rm -v $PWD:/workspace openeuler/wannier90:{Tag} wannier90.x <seedname>
	```

- View container running logs

	```bash
	docker logs wannier90
	```

- To get an interactive shell

	```bash
	docker exec -it wannier90 /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
