# Quick reference

- The official GATK docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# gatk | openEuler

GATK4 aims to bring together well-established tools from the GATK and Picard codebases under a streamlined framework, and to enable selected tools to be run in a massively parallel way on local clusters or in the cloud using Apache Spark. It also contains many newly developed tools not present in earlier releases of the toolkit.

Learn more on [GATK](https://gatk.broadinstitute.org/).

# Supported tags and respective Dockerfile links

The tag of each `gatk` docker image is consist of the version of `gatk` and the version of basic image. The details are as follows

| Tags | Currently | Architectures |
|------|-----------|---------------|
| [4.7.0.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/gatk/4.7.0.0/24.03-lts-sp4/Dockerfile) | GATK 4.7.0.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

Here, users can select the corresponding `{Tag}` by requirements.

- Pull the `openeuler/gatk` image from docker

	```bash
	docker pull openeuler/gatk:{Tag}
	```

- Start an interactive gatk instance

	```bash
	docker run -it --name my-gatk openeuler/gatk:{Tag}
	```

- Run a GATK tool in the container, for example print the help of `HaplotypeCaller`

	```bash
	docker run --rm -v /path/to/data:/data openeuler/gatk:{Tag} gatk HaplotypeCaller --help
	```

- Check the logs of the running container

	```bash
	docker logs -f my-gatk
	```

- Execute a GATK command in the running container

	```bash
	docker exec -it my-gatk gatk --version
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
