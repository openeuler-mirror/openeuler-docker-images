# Quick reference
- The official NOVOPlasty docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# NOVOPlasty | openEuler
NOVOPlasty is a de novo assembler and heteroplasmy/variance caller for short circular genomes, as published in: N. Dierckxsens, P. Mardulyn and G. Smits. 2016. NOVOPlasty: De novo assembly of organelle genomes from whole genome data. Nucleic Acids Research, doi: 10.1093/nar/gkw955. NOVOPlasty provides:
- De novo assembly of mitochondrial and chloroplast genomes from whole genome sequencing data.
- Seed-based extension strategy for organelle genome reconstruction.
- Heteroplasmy and variance detection with allele frequency and depth metrics.
- Batch assembly mode with configurable output paths.
- Local hash storage for accelerated repeated runs on the same dataset.
- Support for Illumina paired-end reads (fastq/fasta, gz/bz2 compressed).
Learn more at [NOVOPlasty](https://github.com/ndierckx/NOVOPlasty).

# Supported tags and respective Dockerfile links
The tag of each NOVOPlasty docker image is consist of the version of NOVOPlasty and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[4.3.5-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/NOVOPlasty/4.3.5/24.03-lts-sp4/Dockerfile) | NOVOPlasty 4.3.5 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[4.3.5-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/NOVOPlasty/4.3.5/24.03-lts-sp3/Dockerfile) | NOVOPlasty 4.3.5 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
-Obtain the NOVOPlasty docker image from DockerHub:
```docker pull openeuler/NOVOPlasty:{Tag}```
- Run the Docker container to launch the NOVOPlasty environment.
```docker run -it openeuler/NOVOPlasty:{Tag}```
- Verify the installation inside the container:
```which NOVOPlasty.pl && which filter_reads.pl```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
