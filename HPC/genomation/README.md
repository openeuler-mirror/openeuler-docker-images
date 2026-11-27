# Quick reference

- The official genomation docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# genomation | openEuler
A package for summary and annotation of genomic intervals. Users can visualize and quantify genomic intervals over pre-defined functional regions, such as promoters, exons, introns, etc. The genomic intervals represent regions with a defined chromosome position, which may be associated with a score, such as aligned reads from HT-seq experiments, TF binding sites, methylation scores, etc. The package can use any tabular genomic feature data as long as it has minimal information on the locations of genomic intervals. In addition, It can use BAM or BigWig files as input.

Learn more on [Bioconductor - genomation](https://bioconductor.org/packages/genomation/).

# Supported tags and respective Dockerfile links
The tag of each genomation docker image is consist of the version of genomation and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.44.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/genomation/1.44.0/24.03-lts-sp4/Dockerfile) | genomation 1.44.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the genomation docker image from DockerHub:
	```docker pull openeuler/genomation:{Tag}```
- Run the Docker container to launch the genomation R environment.
	```docker run -it openeuler/genomation:{Tag}```
- View the logs of a running container:
	```docker logs <container>```
- Open an interactive shell inside a running container:
	```docker exec -it <container> bash```
- Verify the installation inside the container:
	```R -e "library(genomation); packageVersion('genomation')"```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
