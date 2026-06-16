# Quick reference
- The official Meryl docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Meryl | openEuler
Meryl is a free and open-source genomic k-mer counter and sequence utility developed and maintained by the MARBL team. Meryl provides:
- High-performance k-mer counting with multi-threaded support.
- k-mer database construction, query, and filtering.
- Sequence extraction based on k-mer presence or absence.
- Integration with Merqury for reference-free assembly quality assessment.
- OpenMP parallelism for scalable processing.
Learn more at [Meryl](https://github.com/marbl/meryl).

# Supported tags and respective Dockerfile links
The tag of each Meryl docker image is consist of the version of Meryl and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[1.4.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/meryl/1.4.1/24.03-lts-sp3/Dockerfile) | Meryl 1.4.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the Meryl docker image from DockerHub:
```docker pull openeuler/meryl:{Tag}```
- Run the Docker container to launch the Meryl environment.
```docker run -it openeuler/meryl:{Tag}```
- Verify the installation inside the container:
```meryl -version```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).