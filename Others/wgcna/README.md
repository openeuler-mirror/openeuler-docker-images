# Quick reference
- The official hdWGCNA docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# hdWGCNA | openEuler
hdWGCNA is an R package for performing weighted gene co-expression network analysis (WGCNA) in high dimensional transcriptomics data such as single-cell RNA-seq or spatial transcriptomics. hdWGCNA is highly modular and can construct context-specific co-expression networks across cellular and spatial hierarchies. hdWGCNA identifies modules of highly co-expressed genes and provides context for these modules via statistical testing and biological knowledge sources. hdWGCNA provides:
- Co-expression network construction in single-cell and spatial transcriptomics data.
- Module identification and statistical enrichment testing.
- Transcription factor regulatory network analysis.
- Integration with Seurat objects for seamless single-cell analysis workflows.
- Biological knowledge source integration for module interpretation.
Learn more at [hdWGCNA](https://smorabit.github.io/hdWGCNA/).

# Supported tags and respective Dockerfile links
The tag of each hdWGCNA docker image is consist of the version of hdWGCNA and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[0.4.09-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/hdwgcna/0.4.09/24.03-lts-sp3/Dockerfile) | hdWGCNA 0.4.09 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the hdWGCNA docker image from DockerHub:
```docker pull openeuler/hdwgcna:{Tag}```
- Run the Docker container to launch the hdWGCNA environment.
```docker run -it openeuler/hdwgcna:{Tag}```
- Verify the installation inside the container:
```R -e "library(hdWGCNA); packageVersion('hdWGCNA')"```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).