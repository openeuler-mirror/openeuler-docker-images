# Quick reference
- The official FVCOM docker image.
- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# FVCOM | openEuler
FVCOM (Finite-Volume Community Ocean Model) is a prognostic, unstructured-grid, finite-volume, free-surface, 3D primitive equation coastal ocean model developed by the joint UMASSD-WHOI research team. FVCOM provides:
- Unstructured triangular-grid finite-volume discretization that naturally fits complex coastlines and variable-resolution meshes.
- A flexible vertical coordinate system (sigma and generalized terrain-following coordinates).
- Parallel computation based on MPI and METIS domain decomposition for large-scale coastal simulations.
- NetCDF4/HDF5 based input/output of model data and results.
- Multiple physical modules: 2D/3D hydrodynamics, biological models, sediment transport, ice, wave-current interaction, data assimilation and Lagrangian particle tracking.
- A SWAVE (SWAN-like) wave module for wave-current coupling.

Learn more at [FVCOM](https://github.com/FVCOM-GitHub/FVCOM).

# Supported tags and respective Dockerfile links
The tag of each FVCOM docker image is consist of the version of FVCOM and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[5.0.1-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/fvcom/5.0.1/24.03-lts-sp4/Dockerfile) | FVCOM 5.0.1 on openEuler 24.03-LTS-SP4 | arm64 |

# Usage
- Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.
- Obtain the FVCOM docker image from DockerHub:
```docker pull openeuler/fvcom:{Tag}```
- Run the Docker container to launch the FVCOM environment.
```docker run -it openeuler/fvcom:{Tag}```
- Verify the installation inside the container:
```which fvcom```
- Build and run a FVCOM case:
```bash
# create a run directory and generate a blank namelist
mkdir run && cd run
fvcom --create_namelist=CASENAME > /dev/null   # generates CASENAME_run.nml
# edit CASENAME_run.nml and prepare all required input files, then run the model
# serial run:
./fvcom --casename=CASENAME
# parallel run:
mpirun -np N ./fvcom --casename=CASENAME
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
