# Quick reference

- The official KOBAS docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# KOBAS | openEuler

KOBAS (KEGG Orthology Based Annotation System) is a web server for gene set annotation enrichment analysis using KEGG pathways and other high-throughput biological data.

Learn more on [KOBAS home page](http://kobas.cbi.pku.edu.cn).

# Supported tags and respective Dockerfile links

The tag of each `kobas` docker image is consist of the version of `kobas` and the version of basic image. The details are as follows

| Tag                                                                                                            | Currently                          | Architectures |
|----------------------------------------------------------------------------------------------------------------|------------------------------------|---------------|
| [3.0.3-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/kobas/3.0.3/24.03-lts-sp4/Dockerfile) | KOBAS 3.0.3 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
| [3.0.3-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/kobas/3.0.3/24.03-lts-sp3/Dockerfile) | KOBAS 3.0.3 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/kobas` image from docker

	```bash
	docker pull openeuler/kobas:{Tag}
	```

- Start a KOBAS instance

	```bash
	docker run -it --rm openeuler/kobas:{Tag} bash
	```

- Run a simple example

	```bash
	# Show the annotation help inside the container
	kobas-annotate -h
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).