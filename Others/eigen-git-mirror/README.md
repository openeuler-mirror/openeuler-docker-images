# Quick reference

- The official Eigen docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# eigen-git-mirror | openEuler

Current Eigen docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms.

Learn more on [Eigen: A C++ template library for linear algebra](https://eigen.tuxfamily.org/).

# Supported tags and respective Dockerfile links

The tag of each `eigen-git-mirror` docker image is consist of the version of Eigen and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                               | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------|---------------|
| [3.3.7-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/eigen-git-mirror/3.3.7/24.03-lts-sp4/Dockerfile) | Eigen 3.3.7 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/eigen-git-mirror` image from docker

	```bash
	docker pull openeuler/eigen-git-mirror:{Tag}
	```

- Run with an interactive shell

	You can start the container with an interactive shell to compile and run your own code using Eigen.

	```bash
	docker run -it --rm --name my-eigen openeuler/eigen-git-mirror:{Tag} bash
	```

- Sample code

	test.cpp

	```cpp
	#include <iostream>
	#include <Eigen/Dense>

	using Eigen::MatrixXd;

	int main()
	{
	  MatrixXd m(2,2);
	  m(0,0) = 3;
	  m(1,0) = 2.5;
	  m(0,1) = -1;
	  m(1,1) = m(1,0) + m(0,1);
	  std::cout << m << std::endl;
	}
	```

- Compilation instructions

	Compile the program with the include path of the installed Eigen headers:

	```bash
	g++ -I/usr/local/include/eigen3 test.cpp -o test_eigen
	```

- Running the program

	```bash
	./test_eigen
	```

	Expected output:

	```
	  3  -1
	2.5 1.5
	```

- View the container running logs

	```bash
	docker logs -f my-eigen
	```

- To get an interactive shell in the running container

	```bash
	docker exec -it my-eigen /bin/bash
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
