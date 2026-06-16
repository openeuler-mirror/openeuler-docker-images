# Quick reference
- The official FASTA docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# FASTA | openEuler
FASTA is a Python toolkit for bioinformatics sequence processing, developed by Lucas Sinclair. FASTA provides:
- FASTA/FASTQ sequence file reading, writing, and parsing with automatic format detection.
- Sequence filtering and transformation for preprocessing genomic data.
- BioPython integration interface for seamless interoperability with established bioinformatics tools.
- Automatic path management via the autopaths library for robust file handling.
- Command-line pipeline operation via the runps library for batch sequence processing.
- Sequence graphical visualization (optional, via numpy and matplotlib) for data exploration.
- Primer parsing (optional, via regex) for PCR and sequencing primer analysis.
- Tqdm progress tracking for long-running sequence operations.
Learn more at [FASTA](https://github.com/xapple/fasta).

# Supported tags and respective Dockerfile links
The tag of each FASTA docker image is consist of the version of FASTA and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[2.3.6-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/fasta/2.3.6/24.03-lts-sp3/Dockerfile) | FASTA 2.3.6 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the FASTA docker image from DockerHub:
```docker pull openeuler/fasta:{Tag}```
- Run the Docker container to launch the FASTA environment.
```docker run -it openeuler/fasta:{Tag}```
- Verify the installation inside the container:
```python3 -c "import fasta; print(fasta.__version__)"```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).