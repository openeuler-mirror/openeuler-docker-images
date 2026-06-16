# Quick reference
- The official kb-python docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# kb-python | openEuler
kb-python is a Python wrapper for the kallisto | bustools single-cell RNA-seq pre-processing workflow, developed and maintained by Pachterlab. kb-python provides:
- Transcriptome index building (kb ref) from genome FASTA and GTF annotation files.
- Pseudoalignment and count matrix generation (kb count) for single-cell FASTQ files.
- Gene/transcript read extraction (kb extract) from pseudoalignment results.
- Built-in presets for multiple sequencing technologies (10xv2, 10xv3, Drop-seq, SMART-seq, etc.).
- kallisto and bustools binaries bundled with the package — no separate installation required.
- Source compilation of kallisto and bustools via kb compile for custom builds.
- Prebuilt reference indices available for common model organisms.
- Unified workflow for single-cell RNA-seq quantification and RNA velocity estimation.
Learn more at [kb-python](https://github.com/pachterlab/kb_python).

# Supported tags and respective Dockerfile links
The tag of each kb-python docker image is consist of the version of kb-python and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[0.30.2-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/kb-python/0.30.2/24.03-lts-sp3/Dockerfile) | kb-python 0.30.2 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the kb-python docker image from DockerHub:
```docker pull openeuler/kb-python:{Tag}```
- Run the Docker container to launch the kb-python environment.
```docker run -it openeuler/kb-python:{Tag}```
- Verify the installation inside the container:
```kb info```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).