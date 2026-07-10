# Quick reference

- The official circos docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# circos | openEuler
Circos is a software package for visualizing data and information. It visualizes data in a circular layout — this makes Circos ideal for exploring relationships between objects or positions.


# Supported tags and respective Dockerfile links
The tag of each circos docker image is consist of the version of circos and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.52-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/circos/0.52/24.03-lts-sp4/Dockerfile) | circos 0.52 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[0.52-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/circos/0.52/24.03-lts-sp3/Dockerfile) | circos 0.52 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
This image provides the Circos visualization environment for creating circular data visualizations.

Run Circos with a configuration file from a mounted directory:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/circos:{Tag} circos -conf your_circos.conf
```

Display Circos version information:

```
docker run -it --rm openeuler/circos:{Tag} circos -help
```

To generate Circos plots, prepare your data files and a configuration file, then mount the directory containing them:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/circos:{Tag} circos -conf circos.conf
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
