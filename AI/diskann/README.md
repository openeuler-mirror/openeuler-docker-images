# Quick reference

- The official diskann docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# diskann | openEuler
DiskANN is a suite of scalable, accurate and cost-effective approximate nearest neighbor search algorithms for large-scale vector search that support real-time changes and simple filters. This code is based on ideas from Microsoft's DiskANN.


# Supported tags and respective Dockerfile links
The tag of each diskann docker image is consist of the version of diskann and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.52.0-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/diskann/0.52.0/24.03-lts-sp4/Dockerfile) | diskann 0.52.0 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[0.52.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/diskann/0.52.0/24.03-lts-sp3/Dockerfile) | diskann 0.52.0 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
This image provides the DiskANN command-line tools for building, searching, and benchmarking approximate nearest neighbor indexes.

## Running DiskANN benchmark

```shell
docker run openeuler/diskann:{Tag} diskann-benchmark --help
```

## Available tools

The following CLI tools are included in the image:

- `diskann-benchmark` — Main benchmark and search tool
- `compute_groundtruth` — Compute ground truth for accuracy evaluation
- `compute_multivec_groundtruth` — Compute ground truth for multi-vector datasets
- `gen_associated_data_from_range` — Generate associated data from a range
- `generate_minmax` — Generate minmax quantization tables
- `generate_pq` — Generate product quantization tables
- `generate_synthetic_labels` — Generate synthetic label data
- `random_data_generator` — Generate random vector datasets
- `relative_contrast` — Compute relative contrast of a dataset
- `subsample_bin` — Subsample a binary vector file

## Running a specific tool

```shell
docker run openeuler/diskann:{Tag} <tool-name> --help
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
