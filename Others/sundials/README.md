# Quick reference

- The official SUNDIALS docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# SUNDIALS | openEuler
SUNDIALS is a family of software packages providing robust and efficient time
integrators and nonlinear solvers that can easily be incorporated into existing
simulation codes. The library is primarily written in C with interfaces to C++,
[Fortran](https://sundials.readthedocs.io/en/latest/Fortran/index.html), and
[Python](https://sundials.readthedocs.io/en/latest/Python/index.html) (beta
version) and provides support for serial, threaded, distributed, and GPU
accelerated computing. The packages are designed to require minimal information
from the user, allow users to supply their own data structures underneath the
packages, and enable interfacing with user-supplied or third-party algebraic
solvers and preconditioners.

Learn more on [SUNDIALS | Computing](https://computing.llnl.gov/projects/sundials).

For installation directions, see the [getting started](https://sundials.readthedocs.io/en/latest/sundials/index.html#getting-started) section in the online documentation.

# Supported tags and respective Dockerfile links
The tag of each sundials docker image is consist of the version of sundials and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[7.8.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/sundials/7.8.0/24.03-lts-sp4/Dockerfile) | SUNDIALS 7.8.0 on openEuler 24.03-lts-sp4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/sundials` image from docker

	```bash
	docker pull openeuler/sundials:{Tag}
	```

- Start a sundials container

	```bash
	docker run -it --rm --name my-sundials openeuler/sundials:{Tag} /bin/bash
	```

- Run a serial CVODE example to verify the SUNDIALS installation

	```bash
	cd /usr/local/sundials/examples/cvode/serial
	./cvRoberts_dns
	```

- View container running logs

	```bash
	docker logs -f my-sundials
	```

- To get an interactive shell of a running container

	```bash
	docker exec -it my-sundials /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
