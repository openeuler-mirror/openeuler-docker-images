# Quick reference

- The official cactus docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# cactus | openEuler
Cactus is a reference-free whole-genome alignment program, as well as a pangenome graph construction toolkit. It supports progressive alignment of genomes from different species and Minigraph-Cactus pangenome pipeline for aligning genomes from the same species.


# Supported tags and respective Dockerfile links
The tag of each cactus docker image is consist of the version of cactus and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3.2.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/cactus/3.2.1/24.03-lts-sp3/Dockerfile) | cactus 3.2.1 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
This image provides the Cactus whole-genome alignment and pangenome graph construction toolkit.

Run Progressive Cactus to align genomes from different species:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/cactus:{Tag} cactus jobStore seqFile output.hal
```

Run the Minigraph-Cactus pangenome pipeline:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/cactus:{Tag} cactus-pangenome jobStore seqFile output.gfa
```

Convert HAL to MAF format:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/cactus:{Tag} cactus-hal2maf jobStore input.hal output.maf
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).