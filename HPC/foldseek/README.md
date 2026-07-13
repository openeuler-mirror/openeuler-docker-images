# Quick reference

- The official foldseek docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# foldseek | openEuler
Foldseek enables fast and sensitive comparisons of large protein structure sets, supporting monomer and multimer searches, as well as clustering. It runs on CPU, supports GPU acceleration for faster searches, and optionally allows ultra-fast and sensitive comparisons directly from protein sequence inputs using a language model, bypassing the need for structures.


# Supported tags and respective Dockerfile links
The tag of each foldseek docker image is consist of the version of foldseek and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[10-941cd33-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/foldseek/10-941cd33/24.03-lts-sp4/Dockerfile) | foldseek 10-941cd33 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[10-941cd33-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/foldseek/10-941cd33/24.03-lts-sp3/Dockerfile) | foldseek 10-941cd33 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
To use the foldseek image, run:

```
docker pull openeuler/foldseek:{Tag}
```

Search a query structure against a target database:

```
docker run --rm -v /path/to/data:/data openeuler/foldseek:{Tag} foldseek easy-search /data/query.pdb /data/target_db /data/result tmp
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
