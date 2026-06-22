# Quick reference
- The official wgcna docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# wgcna | openEuler
wgcna is an R package for performing weighted gene co-expression network analysis (WGCNA) in high dimensional transcriptomics data such as single-cell RNA-seq or spatial transcriptomics. wgcna is highly modular and can construct context-specific co-expression networks across cellular and spatial hierarchies. wgcna identifies modules of highly co-expressed genes and provides context for these modules via statistical testing and biological knowledge sources. wgcna provides:
- Co-expression network construction in single-cell and spatial transcriptomics data.
- Module identification and statistical enrichment testing.
- Transcription factor regulatory network analysis.
- Integration with Seurat objects for seamless single-cell analysis workflows.
- Biological knowledge source integration for module interpretation.
Learn more at [wgcna](https://github.com/smorabit/hdWGCNA/).

# Supported tags and respective Dockerfile links
The tag of each wgcna docker image is consist of the version of wgcna and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[0.4.09-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/wgcna/0.4.09/24.03-lts-sp3/Dockerfile) | wgcna 0.4.09 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the wgcna docker image from DockerHub:
```docker pull openeuler/wgcna:{Tag}```
- Run the Docker container to launch the wgcna environment.
```docker run -it openeuler/wgcna:{Tag}```
- Verify the installation inside the container:
```R -e "library(wgcna); packageVersion('wgcna')"```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).