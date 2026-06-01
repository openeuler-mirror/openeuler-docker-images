# Quick reference
- The official Kalign docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# Kalign | openEuler
Kalign is a fast multiple sequence alignment program developed and maintained by Timo Lassmann. Kalign provides:
- Progressive alignment approach for biological sequences (protein, DNA, RNA).
- Four mode presets (fast, default, recall, accurate) optimized for different precision requirements.
- Built-in thread pool for parallel computation without OpenMP dependency.
- OpenMP multi-threading acceleration as an alternative parallelization option.
- Multiple output formats (FASTA, MSF, Clustal).
- Auto sequence type detection (protein, DNA, RNA, divergent).
- C library interface for integration into other bioinformatics projects.
Learn more at [Kalign](https://github.com/TimoLassmann/kalign).
# Supported tags and respective Dockerfile links
The tag of each Kalign docker image is consist of the version of Kalign and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[3.5.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/kalign/3.5.1/24.03-lts-sp3/Dockerfile) | Kalign 3.5.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
# Usage
1. Ensure that you have Docker installed, or are using Docker for Docker for Linux containers if on Windows.
2. Obtain the Kalign docker image (choose one):
- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/kalign:3.5.1-oe2403sp3```
- Or build the image locally from source
  - ```docker build -t openeuler/kalign:3.5.1-oe2403sp3 3.5.1/24.03-lts-sp3/```
3. Run the Docker container to launch the Kalign environment.
- ```docker run -it openeuler/kalign:3.5.1-oe2403sp3```
4. Verify the installation inside the container:
- ```kalign --version```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).