# Quick reference

- The official PWDFT docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# PWDFT | openEuler
Current PWDFT docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

PWDFT (Plane-Wave Density Functional Theory) is an autonomous plane-wave DFT engine for exascale materials discovery, developed for NWChemEx electronic structure software. It implements first-principles methods based on density functional theory to describe electronic structure properties of materials.

Learn more on [PWDFT](https://github.com/ebylaska/PWDFT).

# Supported tags and respective Dockerfile links
The tag of each `PWDFT` docker image is consist of the version of `PWDFT` and the version of basic image. The details are as follows
| Tags | Currently | Architectures |
|--|--|--|
|[1.0.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/pwdft/1.0.0/24.03-lts-sp3/Dockerfile)| PWDFT 1.0.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

Pull the image (example):

```bash
docker pull openeuler/pwdft:1.0.0-oe2403sp3
```

Run PWDFT container:

```bash
docker run -it --rm openeuler/pwdft:1.0.0-oe2403sp3 pwdft --help
```

Run a DFT calculation (example):

```bash
docker run -it --rm -v /path/to/input:/data openeuler/pwdft:1.0.0-oe2403sp4 pwdft /data/input.nw
docker run -it --rm -v /path/to/input:/data openeuler/pwdft:1.0.0-oe2403sp3 pwdft /data/input.nw
```

# Question and answering
If you have any questions or want to use special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
