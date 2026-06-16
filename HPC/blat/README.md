# Quick reference
- The official pblat docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# pblat | openEuler
pblat is the cluster parallel version of BLAT (BLAST-Like Alignment Tool), a fast sequence search and alignment tool designed for genome comparisons. pblat supports MPI and multi-thread hybrid parallel computing mode, enabling efficient large-scale genome sequence alignment tasks in cluster environments. pblat provides:
- MPI-based distributed parallel computing across cluster nodes.
- Multi-thread hybrid parallel mode for improved throughput on single nodes.
- High-speed sequence mapping and alignment inherited from BLAT.
- Support for various input formats including FASTA and PSL.
Learn more at [pblat](http://icebert.github.io/pblat-cluster/).

# Supported tags and respective Dockerfile links
The tag of each pblat docker image is consist of the version of pblat and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[1.1-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/pblat/1.1/24.03-lts-sp3/Dockerfile) | pblat 1.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the pblat docker image from DockerHub:
```docker pull openeuler/pblat:{Tag}```
- Run the Docker container to launch the pblat environment.
```docker run -it openeuler/pblat:{Tag}```
- Verify the installation inside the container:
```pblat -version```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).