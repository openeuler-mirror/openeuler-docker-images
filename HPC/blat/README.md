# Quick reference
- The official blat docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# blat | openEuler
blat is the cluster parallel version of BLAT (BLAST-Like Alignment Tool), a fast sequence search and alignment tool designed for genome comparisons. blat supports MPI and multi-thread hybrid parallel computing mode, enabling efficient large-scale genome sequence alignment tasks in cluster environments. blat provides:
- MPI-based distributed parallel computing across cluster nodes.
- Multi-thread hybrid parallel mode for improved throughput on single nodes.
- High-speed sequence mapping and alignment inherited from BLAT.
- Support for various input formats including FASTA and PSL.
Learn more at [blat](https://github.com/icebert/pblat-cluster/).

# Supported tags and respective Dockerfile links
The tag of each blat docker image is consist of the version of blat and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[1.1-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/blat/1.1/24.03-lts-sp4/Dockerfile) | blat 1.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.1-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/blat/1.1/24.03-lts-sp3/Dockerfile) | blat 1.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the blat docker image from DockerHub:
```docker pull openeuler/blat:{Tag}```
- Run the Docker container to launch the blat environment.
```docker run -it openeuler/blat:{Tag}```
- Verify the installation inside the container:
```blat -version```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
