# Quick reference
- The official AutoDock Vina docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# AutoDock Vina | openEuler
AutoDock Vina is one of the fastest and most widely used open-source docking engines. It is a turnkey computational docking program based on a simple scoring function and rapid gradient-optimization conformational search. AutoDock Vina provides:
- AutoDock4.2 and Vina scoring functions.
- Support for simultaneous docking of multiple ligands and batch mode for virtual screening.
- Support for macrocycle molecules.
- Hydrated docking protocol.
- Can write and load external AutoDock maps.
- Python bindings for Python 3 (Linux and Mac).
Learn more at [AutoDock Vina](https://autodock-vina.readthedocs.io/en/latest/).

# Supported tags and respective Dockerfile links
The tag of each AutoDock Vina docker image is consist of the version of AutoDock Vina and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[1.2.7-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/autodock-vina/1.2.7/24.03-lts-sp3/Dockerfile) | AutoDock Vina 1.2.7 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the AutoDock Vina docker image:
```docker pull openeuler/autodock-vina:{Tag}```
- Run the Docker container to launch the AutoDock Vina environment.
```docker run -it openeuler/autodock-vina:{Tag}```
- Verify the installation inside the container:
```vina --version```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).