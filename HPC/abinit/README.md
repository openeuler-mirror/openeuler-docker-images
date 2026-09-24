# Quick reference

- The official ABINIT docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# ABINIT | openEuler
ABINIT is an atomic-scale simulation software suite.

Learn more on [ABINIT](https://www.abinit.org/).

# Supported tags and respective Dockerfile links
The tag of each `abinit` docker image is consist of the version of `abinit` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[10.8.3-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/abinit/10.8.3/24.03-lts-sp4/Dockerfile)| ABINIT 10.8.3 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/abinit` image from docker

	```bash
	docker pull openeuler/abinit:{Tag}
	```

- Start a container to check the ABINIT version

	```bash
	docker run --rm openeuler/abinit:{Tag} abinit --version
	```

- Run an ABINIT calculation

	ABINIT reads its input from a `.abi` input file. Mount the working directory containing the input file and the pseudopotentials, then run the calculation:

	```bash
	docker run --rm -v $PWD:/workspace -w /workspace openeuler/abinit:{Tag} abinit run.abi
	```

- Run in parallel with MPI

	```bash
	docker run --rm -v $PWD:/workspace -w /workspace openeuler/abinit:{Tag} mpirun -np 4 abinit run.abi
	```

	Where `4` is the number of MPI processes to be used.

- View the logs of a running container

	```bash
	docker logs <container>
	```

- Open an interactive shell inside a running container

	```bash
	docker exec -it <container> bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
