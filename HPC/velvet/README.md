# Quick reference
- The official Velvet docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# Velvet | openEuler
Velvet is a de novo short read assembler using de Bruijn graphs, as published in: D.R. Zerbino and E. Birney. 2008. Velvet: algorithms for de novo short read assembly using de Bruijn graphs. Genome Research, 18: 821-829. Velvet provides:
- De novo assembly of short reads into contigs using de Bruijn graph construction and simplification.
- Support for multiple hash lengths (k-values) for optimized assembly.
- Handling of paired-end and long reads for scaffold improvement.
- Columbus mode for reference-guided assembly.
- Support for color-space reads from SOLiD sequencers.
- Two core commands: velveth (hash construction) and velvetg (graph assembly).
Learn more at [Velvet](https://github.com/dzerbino/velvet).
# Supported tags and respective Dockerfile links
The tag of each Velvet docker image is consist of the version of Velvet and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[1.2.10-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/velvet/1.2.10/24.03-lts-sp3/Dockerfile) | Velvet 1.2.10 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
2. Obtain the Velvet docker image (choose one):
- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/velvet:1.2.10-oe2403sp3```
- Or build the image locally from source
  - ```docker build -t openeuler/velvet:1.2.10-oe2403sp3 1.2.10/24.03-lts-sp3/```
3. Run the Docker container to launch the Velvet environment.
- ```docker run -it openeuler/velvet:1.2.10-oe2403sp3```
4. Verify the installation inside the container:
- ```which velveth && which velvetg```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).