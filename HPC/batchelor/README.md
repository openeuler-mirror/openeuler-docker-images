# Quick reference

- The official batchelor docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# batchelor | openEuler
Implements a variety of methods for batch correction of single-cell (RNA sequencing) data. This includes methods based on detecting mutually nearest neighbors, as well as several efficient variants of linear regression of the log-expression values. Functions are also provided to perform global rescaling to remove differences in depth between batches, and to perform a principal components analysis that is robust to differences in the numbers of cells across batches.

Learn more on [Bioconductor - batchelor](https://bioconductor.org/packages/batchelor).

# Supported tags and respective Dockerfile links
The tag of each batchelor docker image is consist of the version of batchelor and the version of basic image. The details are as follows:

| Tags | Currently |  Architectures|
|--|--|--|
|[1.28.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/batchelor/1.28.0/24.03-lts-sp4/Dockerfile) | batchelor 1.28.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the batchelor docker image from DockerHub:
	```docker pull openeuler/batchelor:{Tag}```
- Run the Docker container to launch the batchelor R environment.
	```docker run -it openeuler/batchelor:{Tag}```
- View the logs of a running container:
	```docker logs <container>```
- Open an interactive shell inside a running container:
	```docker exec -it <container> bash```
- Verify the installation inside the container:
	```R -e "library(batchelor); packageVersion('batchelor')"```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).