# Quick reference
- The official HH-suite docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# HH-suite | openEuler
HH-suite3 is an open-source software package for sensitive protein sequence searching based on the pairwise alignment of hidden Markov models (HMMs), developed by the Soding lab. HH-suite provides:
- HHblits: Fast iterative HMM search for remote homology detection and deep protein annotation.
- HHsearch: Sensitive HMM-HMM alignment for profile-profile comparison.
- HHPred: Protein structure and function prediction via profile-profile search.
- SIMD acceleration: SSE2/AVX2 on x86_64, NEON on ARM64 for high-performance sequence alignment.
- MPI parallel computation support (self-compiled version only).
- Multi-format input support: FASTA, A3M, HMM, and HHM profiles.
- Extensive database integration: Uniclust30, BFD, Pfam, SCOP, PDB70, and more.
Learn more at [HH-suite](https://github.com/soedinglab/hh-suite).

# Supported tags and respective Dockerfile links
The tag of each HH-suite docker image is consist of the version of HH-suite and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[3.3.0-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/hh-suite/3.3.0/24.03-lts-sp4/Dockerfile) | HH-suite 3.3.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[3.3.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/hh-suite/3.3.0/24.03-lts-sp3/Dockerfile) | HH-suite 3.3.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the HH-suite docker image from DockerHub:
```docker pull openeuler/hh-suite:{Tag}```
- Run the Docker container to launch the HH-suite environment.
```docker run -it openeuler/hh-suite:{Tag}```
- Verify the installation inside the container:
```hhblits -h && hhsearch -h```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
