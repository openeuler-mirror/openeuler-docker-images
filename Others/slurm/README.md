# Quick reference
- The official Slurm docker image.
- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Slurm | openEuler
Slurm Workload Manager is a free and open-source cluster resource management and job scheduling system, used by many of the world's supercomputers and computer clusters. It provides three key functions:
- Allocating exclusive and/or non-exclusive access to resources (compute nodes) to users for some duration of time.
- Providing a framework for starting, executing, and monitoring work (normally a parallel job) on the set of allocated nodes.
- Arbitrating conflicting requests for resources by managing a queue of pending work.
Learn more at [Slurm](https://slurm.schedmd.com/).

# Supported tags and respective Dockerfile links
The tag of each Slurm docker image is consist of the version of Slurm and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[25.11.6-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/slurm/25.11.6/24.03-lts-sp3/Dockerfile)| slurm 25.11.6 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the Slurm docker image from DockerHub:
```docker pull openeuler/slurm:{Tag}```
- Run the Docker container to launch the Slurm environment.
```docker run -it openeuler/slurm:{Tag}```
- Verify the installation inside the container:
```slurm --version```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).