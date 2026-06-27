# Quick reference

- The official cmaq docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# cmaq | openEuler
US EPA Community Multiscale Air Quality Model (CMAQ) is an active open-source development project of the U.S. EPA's Office of Research and Development that consists of a suite of programs for conducting air quality model simulations. CMAQ combines current knowledge in atmospheric science and air quality modeling with multi-processor computing techniques in an open-source framework to deliver fast, technically sound estimates of ozone, particulates, toxics, and acid deposition.

Learn more on [EPA CMAQ Website](https://www.epa.gov/cmaq).

# Supported tags and respective Dockerfile links
The tag of each cmaq docker image is consist of the version of cmaq and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[5.5.2Oct2024-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/cmaq/5.5.2Oct2024/24.03-lts-sp3/Dockerfile) | cmaq 5.5.2Oct2024 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[5.5-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/cmaq/5.5/24.03-lts-sp3/Dockerfile) | cmaq 5.5 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
To start an interactive session with the CMAQ environment:

```
docker run -it --rm openeuler/cmaq:{Tag} bash
```

The CMAQ source code is located at `/opt/cmaq`. To compile a specific CCTM configuration (e.g., using the CB6r5 mechanism with aerosol module):

```
cd /opt/cmaq/CCTM/scripts
./bldit_cctm.csh gcc cb6r5_ae7_aq
```

To run a CMAQ simulation after compilation, mount your input data directory and execute the CCTM binary:

```
docker run --rm \
  -v /path/to/input/data:/data \
  openeuler/cmaq:{Tag} \
  mpirun -np 4 /opt/cmaq/CCTM/scripts/BLD_CCTM_v55_gcc_cb6r5_ae7_aq/CCTM_v55.cmaq
```


# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).