# Quick reference
- The official Jellyfish docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Jellyfish | openEuler
Jellyfish is a tool for fast, memory-efficient counting of k-mers in DNA. A k-mer is a substring of length k, and counting the occurrences of all such substrings is a central step in many analyses of DNA sequence. Jellyfish can count k-mers using an order of magnitude less memory and an order of magnitude faster than other k-mer counting packages by using an efficient encoding of a hash table and by exploiting the "compare-and-swap" CPU instruction to increase parallelism. Jellyfish provides:
- Fast, memory-efficient k-mer counting with an order of magnitude improvement over other tools.
- Multi-threaded parallel counting using lock-free compare-and-swap operations.
- Support for FASTA and multi-FASTA input formats.
- Query and dump commands for k-mer count retrieval and output.
- Bindings to Ruby, Python, and Perl for programmatic access.
Learn more at [Jellyfish](https://github.com/gmarcais/Jellyfish).

# Supported tags and respective Dockerfile links
The tag of each Jellyfish docker image is consist of the version of Jellyfish and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[2.3.1-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/jellyfish/2.3.1/24.03-lts-sp3/Dockerfile) | Jellyfish 2.3.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the Jellyfish docker image from DockerHub:
```docker pull openeuler/jellyfish:{Tag}```
- Run the Docker container to launch the Jellyfish environment.
```docker run -it openeuler/jellyfish:{Tag}```
- Verify the installation inside the container:
```jellyfish --version```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).