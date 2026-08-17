# Quick reference

- The official hdwgcna docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# hdwgcna | openEuler
hdWGCNA is an R package for performing weighted gene co-expression network analysis (WGCNA) in high dimensional transcriptomics data such as single-cell RNA-seq or spatial transcriptomics. hdWGCNA is highly modular and can construct context-specific co-expression networks across cellular and spatial hierarchies. hdWGNCA identifies modules of highly co-expressed genes and provides context for these modules via statistical testing and biological knowledge sources. hdWGCNA uses datasets formatted as Seurat objects. Check out the hdWGCNA in single-cell data tutorial or the hdWGCNA in spatial transcriptomics data tutorial to get started.

New functionality: hdWGCNA is now able to perform Transcription Factor Regulatory Network Analysis. This functionality was introduced in our publication Childs & Morabito et al., Cell Reports (2024).

Learn more on [hdWGCNA • hdWGCNA](https://smorabit.github.io/hdWGCNA/).

# Supported tags and respective Dockerfile links
The tag of each hdwgcna docker image is consist of the version of hdwgcna and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.4.12-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/hdwgcna/0.4.12/24.03-lts-sp4/Dockerfile) | hdwgcna 0.4.12 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the hdwgcna docker image from DockerHub:
	```docker pull openeuler/hdwgcna:{Tag}```
- Run the Docker container to launch the hdwgcna R environment.
	```docker run -it openeuler/hdwgcna:{Tag}```
- View the logs of a running container:
	```docker logs <container>```
- Open an interactive shell inside a running container:
	```docker exec -it <container> bash```
- Verify the installation inside the container:
	```R -e "library(hdWGCNA); packageVersion('hdWGCNA')"```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
