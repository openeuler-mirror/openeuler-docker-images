# Quick reference
- The official InterProScan docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# InterProScan | openEuler
InterProScan is a genome-scale protein function classification tool developed by EBI (European Bioinformatics Institute). InterPro integrates predictive information about proteins' function from a number of partner resources, giving an overview of the families that a protein belongs to and the domains and sites it contains. InterProScan runs the scanning algorithms from the InterPro member databases in an integrated way against novel protein or nucleotide sequences submitted in FASTA format. InterProScan provides:
- Integrated scanning against multiple member databases including Pfam, SMART, ProSite, Gene3D, and more.
- Protein family, domain, and functional site identification from sequence data.
- Support for both protein and nucleotide (CDS) FASTA input formats.
- Multiple output formats including TSV, XML, GFF3, JSON, and HTML.
- Scalable parallel processing for large-scale genome annotation tasks.
Learn more at [InterProScan](https://interproscan-docs.readthedocs.io).

# Supported tags and respective Dockerfile links
The tag of each InterProScan docker image is consist of the version of InterProScan and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[5.77-108.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/interproscan/5.77-108.0/24.03-lts-sp3/Dockerfile) | InterProScan 5.77-108.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the InterProScan docker image from DockerHub:
```docker pull openeuler/interproscan:{Tag}```
- Run the Docker container to launch the InterProScan environment.
```docker run -it openeuler/interproscan:{Tag}```
- Verify the installation inside the container:
```interproscan.sh --version```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).