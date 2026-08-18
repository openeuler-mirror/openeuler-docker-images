# Quick reference

- The official moose docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# moose | openEuler
Current moose docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

moose provides Taskflow, a general-purpose task-parallel programming system in C++. Taskflow helps you quickly write high-performance task-parallel programs with high programming productivity. It is faster, more expressive, fewer lines of code, and easier for drop-in integration than many existing task programming libraries.

Learn more on [Taskflow: A General-purpose Task-parallel Programming System](https://taskflow.github.io/).

# Supported tags and respective Dockerfile links
The tag of each `moose` docker image is consist of the version of `moose` and the version of basic image. The details are as follows

| Tag                                                                                                                        | Currently                             | Architectures |
|----------------------------------------------------------------------------------------------------------------------------|---------------------------------------|---------------|
| [4.1.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/moose/4.1.0/24.03-lts-sp4/Dockerfile) | moose 4.1.0 on openEuler 24.03-LTS-SP4 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/moose` image from docker

	```bash
	docker pull openeuler/moose:{Tag}
	```

- Start a moose container and compile a Taskflow program

	```bash
	docker run -it --name my-moose -v $(pwd):/workspace -w /workspace openeuler/moose:{Tag} bash
	```

	Write the following `simple.cpp`:

	```cpp
	#include <taskflow/taskflow.hpp>  // Taskflow is header-only

	int main(){

	  tf::Executor executor;
	  tf::Taskflow taskflow;

	  auto [A, B, C, D] = taskflow.emplace(  // create four tasks
	    [] () { std::cout << "TaskA\n"; },
	    [] () { std::cout << "TaskB\n"; },
	    [] () { std::cout << "TaskC\n"; },
	    [] () { std::cout << "TaskD\n"; }
	  );

	  A.precede(B, C);  // A runs before B and C
	  D.succeed(B, C);  // D runs after  B and C

	  executor.run(taskflow).wait();

	  return 0;
	}
	```

	Compile and run the program inside the container:

	```bash
	g++ -std=c++20 simple.cpp -I/usr/local/include -O2 -pthread -o simple
	./simple
	```

- View container running logs

	```bash
	docker logs -f my-moose
	```

- To get an interactive shell

	```bash
	docker exec -it my-moose /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
