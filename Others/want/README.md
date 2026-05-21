# Quick reference

- The official want docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# want | openEuler
WanT is an open-source, GNU General Public License suite of codes that provides an
integrated approach for the study of coherent electronic transport in nanostructures.


# Supported tags and respective Dockerfile links
The tag of each want docker image is consist of the version of want and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.6.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/want/2.6.1/24.03-lts-sp3/Dockerfile) | want 2.6.1 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
You can run any WanT executable directly. For example, to run a Wannier function calculation:

```bash
docker run --rm openeuler/want:{Tag} wannier.x < wannier.in
```

Available executables:
- `wannier.x` - Wannier function calculation
- `disentangle.x` - Disentanglement step
- `bands.x` - Band structure calculation
- `plot.x` - Plot Wannier functions
- `blc2wan.x` - Convert Bloch states to Wannier functions
- `conductor.x` - Quantum transport calculation
- `kgrid.x` - K-point grid generation
- `midpoint.x` - Midpoint calculation

To run with input files from the host:

```bash
docker run --rm -v $(pwd):/workdir -w /workdir openeuler/want:{Tag} wannier.x < wannier.in
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
