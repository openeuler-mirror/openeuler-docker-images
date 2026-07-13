# Quick reference

- The official prottest3 docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# prottest3 | openEuler
ProtTest 3 is a bioinformatics tool for selecting the best-fit amino acid replacement model for protein sequences. It provides statistical methods to compare different models of protein evolution and select the most appropriate one for phylogenetic analysis.


# Supported tags and respective Dockerfile links
The tag of each prottest3 docker image is consist of the version of prottest3 and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3.4.2-release-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/prottest3/3.4.2-release/24.03-lts-sp4/Dockerfile) | prottest3 3.4.2-release on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[3.4.2-release-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/prottest3/3.4.2-release/24.03-lts-sp3/Dockerfile) | prottest3 3.4.2-release on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
This image provides the ProtTest 3 tool for protein evolutionary model selection.

Run ProtTest 3 with an alignment file in PHYLIP or FASTA format:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/prottest3:{Tag} prottest3 -i alignment_file.phy
```

Run ProtTest 3 with specific options:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/prottest3:{Tag} prottest3 -i alignment_file.phy -o output_file -all-distributions
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
