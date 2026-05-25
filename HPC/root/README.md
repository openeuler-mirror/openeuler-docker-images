# Quick reference

- The official root docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# root | openEuler
ROOT is a unified software package for the storage, processing, and analysis of scientific data: from its acquisition to the final visualization in form of highly customizable, publication-ready plots. It is reliable, performant and well supported, easy to use and obtain, and strives to maximize the quantity and impact of scientific results obtained per unit cost, both of human effort and computing resources.


# Supported tags and respective Dockerfile links
The tag of each root docker image is consist of the version of root and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[6-40-00-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/root/6-40-00/24.03-lts-sp3/Dockerfile) | root 6-40-00 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
In this section, the typical use of the ROOT docker image will be introduced.

Start a ROOT interactive session in batch mode (no graphics):
```bash
docker run -it --rm openeuler/root:{Tag} root -b
```

Run a ROOT macro:
```bash
docker run -it --rm openeuler/root:{Tag} root -b -q 'TMath::Pi()'
```

Start a container shell to use ROOT tools:
```bash
docker run -it --rm openeuler/root:{Tag} bash
```


# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
