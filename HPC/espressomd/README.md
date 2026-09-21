# Quick reference

- The official ESPResSo docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# espressomd | openEuler
ESPResSo is a highly versatile software package for performing and analyzing scientific Molecular Dynamics many-particle simulations of "coarse-grained" bead-spring models as they are used in soft-matter research in physics, chemistry and molecular biology. It can be used to simulate systems as for example polymers, liquid crystals, colloids, ferrofluids and biological systems such as DNA and lipid membranes.

Learn more on [ESPResSo » Extensible Simulation Package for the Research on Soft Matter](https://espressomd.org/wordpress/).

# Supported tags and respective Dockerfile links
The tag of each `espressomd` docker image is consist of the version of `espressomd` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[5.0.1-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/espressomd/5.0.1/24.03-lts-sp4/Dockerfile) | ESPResSo 5.0.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/espressomd` image from docker

	```bash
	docker pull openeuler/espressomd:{Tag}
	```

- Start an ESPResSo container

	```bash
	docker run -it --rm --name espressomd openeuler/espressomd:{Tag}
	```

- Run a simulation script

	ESPResSo simulations are controlled via Python scripts. Mount the directory that contains your script and run it with `pypresso`:

	```bash
	docker run -it --rm -v $(pwd):/data -w /data openeuler/espressomd:{Tag} pypresso script.py
	```

- Run in parallel with MPI

	For parallel simulations with MPI, use the following command:

	```bash
	docker run -it --rm openeuler/espressomd:{Tag} mpirun --allow-run-as-root -np 4 pypresso script.py
	```

	Where `4` is the number of CPU cores to be used.

- Inspect the logs of a running espressomd container

	```bash
	docker logs <container-name>
	```

- Execute a command inside a running espressomd container

	```bash
	docker exec -it <container-name> bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
