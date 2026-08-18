# Quick reference

- The official Taskflow docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# Taskflow | openEuler
Current Taskflow docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Taskflow helps you quickly write high-performance task-parallel programs with high programming productivity.
It is faster, more expressive, fewer lines of code, and easier for drop-in integration
than many existing task programming libraries.

Taskflow is header-only and there is no struggle with installation.

Learn more about Taskflow on [Taskflow: A General-purpose Task-parallel Programming System](https://taskflow.github.io/taskflow/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `taskflow` docker image is consist of the version of `taskflow` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[4.1.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/taskflow/4.1.0/24.03-lts-sp4/Dockerfile) | taskflow 4.1.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/taskflow` image from docker

	```bash
	docker pull openeuler/taskflow:{Tag}
	```

- Run a Taskflow program

    Create a file named `simple.cpp` with the following content:

	```cpp
	#include <taskflow/taskflow.hpp>

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

- Compile the program inside the container

	```bash
	docker run --rm -v $(pwd):/workspace openeuler/taskflow:{Tag} g++ -std=c++20 -O2 -pthread /workspace/simple.cpp -o /workspace/simple
	```

- Run the compiled program

	```bash
	docker run --rm -v $(pwd):/workspace openeuler/taskflow:{Tag} /workspace/simple
	```

- Check the container logs

	```bash
	docker run --rm --name taskflow-test openeuler/taskflow:{Tag} /workspace/simple
	docker logs taskflow-test
	```

- Open an interactive shell

	```bash
	docker run -it --rm -v $(pwd):/workspace openeuler/taskflow:{Tag} bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
