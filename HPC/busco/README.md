# Quick reference

- The official busco container image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# busco | openEuler
Current busco docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

BUSCO (Benchmarking Universal Single-Copy Orthologs) provides measures for quantitative assessment of genome assembly, gene set, and transcriptome completeness based on evolutionarily informed expectations of gene content from near-universal single-copy orthologs selected from OrthoDB.

Learn more on [busco website](https://busco.ezlab.org/).


# Supported tags and respective Dockerfile links
The tag of each busco container image is consist of the version of busco and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[5.8.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/busco/5.8.3/24.03-lts-sp1/Dockerfile)| BUSCO 5.8.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |


# Usage
- Pull the `openeuler/busco` image from `hub.docker.com`
	```
	docker pull openeuler/busco:{Tag}
	```
- Start a `busco` instance
	```
	docker run -it --name my-busco openeuler/busco:{Tag}
	```
	Now, you can use BUSCO according to [User Guide](https://busco.ezlab.org/)

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).