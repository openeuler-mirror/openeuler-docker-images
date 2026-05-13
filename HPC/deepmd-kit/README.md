# Quick reference

- The official DeePMD-kit docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# DeePMD-kit | openEuler
DeePMD-kit is an open-source package for deep learning based molecular simulation. It provides a framework for deep potential molecular dynamics (DPMD) and deep potential range correction (DPRc). Learn more at https://github.com/deepmodeling/deepmd-kit.

# Supported tags and respective Dockerfile links
The tag of each DeePMD-kit docker image is consist of the version of DeePMD-kit and the version of basic image. The details are as follows
| Tags | Currently | Architectures |
|--|--|--|
|[3.1.3-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/deepmd-kit/3.1.3/24.03-lts-sp3/Dockerfile)| DeePMD-kit 3.1.3 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

Pull the image (example):

```bash
docker pull openeuler/deepmd-kit:3.1.3-oe2403sp3
```

Run DeePMD-kit container:

```bash
docker run -it --rm openeuler/deepmd-kit:3.1.3-oe2403sp2 dp --version
```

Train a model (example):

```bash
docker run -it --rm -v /path/to/data:/data openeuler/deepmd-kit:3.1.3-oe2403sp2 dp train /data/input.json
```

## Using with LAMMPS
DeePMD-kit can be used with LAMMPS for molecular dynamics simulations. Example workflow:

1. Train a deep potential model
2. Freeze the model
3. Use the model in LAMMPS with the `pair_style deepmd` command

# Question and answering
If you have any questions or want to use special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).