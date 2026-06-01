# Quick reference

- The official ESPResSo docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# ESPResSo | openEuler
ESPResSo is a highly versatile software package for performing and analyzing scientific Molecular Dynamics many-particle simulations of "coarse-grained" bead-spring models as they are used in soft-matter research in physics, chemistry and molecular biology. It can be used to simulate systems as for example polymers, liquid crystals, colloids, ferrofluids and biological systems such as DNA and lipid membranes.

# Supported tags and respective Dockerfile links
The tag of each `espresso` docker image is consist of the version of `espresso` and the version of basic image. The details are as follows

| Tag                                                                                                                        | Currently                                 | Architectures |
|----------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------|
| [5.0.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/espresso/5.0.0/24.03-lts-sp3/Dockerfile) | ESPResSo 5.0.0 on openEuler 24.03-LTS-SP3 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/espresso` image from docker

	```bash
	docker pull openeuler/espresso:{Tag}
	```

- Start a espresso instance

	```bash
	docker run -it --rm openeuler/espresso:{Tag}
	```

- Running Python Scripts

	ESPResSo is controlled via Python scripts. You can run simulation scripts as follows:

	```bash
	docker run -it --rm -v /path/to/your/script.py:/script.py openeuler/espresso:{Tag} ./pypresso /script.py
	```

- Running in Parallel (MPI)

	For parallel simulations with MPI, use the following command:

	```bash
	docker run -it --rm openeuler/espresso:{Tag} mpirun --allow-run-as-root -np 4 ./pypresso script.py
	```

	Where `4` is the number of CPU cores to be used.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).