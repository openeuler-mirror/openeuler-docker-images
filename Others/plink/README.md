# Quick reference
- The official PLINK docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# PLINK | openEuler
PLINK is a free, open-source whole genome association analysis toolset, designed to perform a range of basic, large-scale analyses in a computationally efficient manner. PLINK is a comprehensive update which provides:
- Handling VCF files and dosage data natively.
- Significantly faster performance for basic operations like merging, filtering, and association testing.
- Support for pgen/pvar/psam format for efficient storage of large-scale genomic data.
- Most basic features other than non-concatenating merge are now in place.
Learn more at [PLINK](https://www.cog-genomics.org/plink/2.0/).
# Supported tags and respective Dockerfile links
The tag of each PLINK docker image is consist of the version of PLINK and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[2.0.0-a.7.1-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/plink/2.0.0-a.7.1/24.03-lts-sp3/Dockerfile)| plink2 2.0.0-a.7.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
2. Obtain the PLINK docker image (choose one):
- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/plink:2.0.0-a.7.1-oe2403sp3```
- Or build the image locally from source
  - ```docker build -t openeuler/plink:2.0.0-a.7.1-oe2403sp3 2.0.0-a.7.1/24.03-lts-sp3/```
3. Run the Docker container to launch the PLINK environment.
- ```docker run -it openeuler/plink:2.0.0-a.7.1-oe2403sp3```
4. Verify the installation inside the container:
- ```plink2 --version```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).