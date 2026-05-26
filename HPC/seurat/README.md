# Quick reference
- The official Seurat docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# Seurat | openEuler
Seurat is an R toolkit for single-cell genomics, developed and maintained by the [Satija Lab](https://satijalab.org/) at NYGC. Seurat provides a complete analysis pipeline for single-cell RNA sequencing data, including quality control, normalization, feature selection, dimensionality reduction, clustering, and differential expression analysis. Seurat v5 introduces new functionality for:
- Spatial transcriptomics analysis (Visium, SlideSeq, Xenium, Vizgen).
- Multimodal data integration and analysis.
- Scalable single-cell analysis with sketch-based and BPCells-backed methods.
- Pseudobulk expression analysis and cross-modality integration.
- Improved clustering (Leiden) and UMAP (umap2) algorithms.
Learn more at [Seurat](https://github.com/satijalab/seurat).
# Supported tags and respective Dockerfile links
The tag of each Seurat docker image is consist of the version of Seurat and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[5.5.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/seurat/5.5.0/24.03-lts-sp3/Dockerfile) | Seurat 5.5.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
2. Obtain the Seurat docker image (choose one):
- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/seurat:5.5.0-oe2403sp3```
- Or build the image locally from source
  - ```docker build -t openeuler/seurat:5.5.0-oe2403sp3 5.5.0/24.03-lts-sp3/```
3. Run the Docker container to launch the Seurat environment.
- ```docker run -it openeuler/seurat:5.5.0-oe2403sp3```
4. Verify the installation inside the container:
- ```R -e "library(Seurat); packageVersion('Seurat')"```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler-docker-images).