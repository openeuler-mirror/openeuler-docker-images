# Quick reference

- The official libconfig docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# libconfig | openEuler
Current libconfig docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

C/C++ library for processing structured configuration files.

Learn more on [libconfig | C/C++ Library for Processing Structured Configuration Files](https://hyperrealm.github.io/libconfig/).

# Supported tags and respective Dockerfile links
The tag of each `libconfig` docker image is consist of the version of `libconfig` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.8.2-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/libconfig/1.8.2/24.03-lts-sp4/Dockerfile) | libconfig 1.8.2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/libconfig` image from docker

	```bash
	docker pull openeuler/libconfig:{Tag}
	```

- Run with an interactive shell

	```bash
	docker run -it --rm openeuler/libconfig:{Tag} bash
	```

- Compile and run a C program using libconfig

	Create a file named `example.c` in the current directory:

	```c
	#include <stdio.h>
	#include <libconfig.h>

	int main(void)
	{
	  config_t cfg;
	  const char *name;
	  int port;

	  config_init(&cfg);
	  if(! config_read_string(&cfg, "name = \"libconfig\"; port = 8080;"))
	  {
	    fprintf(stderr, "%s\n", config_error_text(&cfg));
	    config_destroy(&cfg);
	    return 1;
	  }

	  config_lookup_string(&cfg, "name", &name);
	  config_lookup_int(&cfg, "port", &port);
	  printf("%s:%d\n", name, port);

	  config_destroy(&cfg);
	  return 0;
	}
	```

	Compile and run it with pkg-config inside the container:

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/libconfig:{Tag} \
	    sh -c 'gcc $(pkg-config --cflags libconfig) example.c -o example $(pkg-config --libs libconfig) && ./example'
	```

	Expected output:

	```
	libconfig:8080
	```

- Compile and run a C++ program using libconfig

	Create a file named `example.cpp` in the current directory:

	```cpp
	#include <iostream>
	#include <libconfig.h++>

	using namespace libconfig;

	int main()
	{
	  Config cfg;
	  cfg.readString("name = \"libconfig\"; port = 8080;");

	  std::string name = cfg.lookup("name");
	  int port = cfg.lookup("port");
	  std::cout << name << ":" << port << std::endl;
	  return 0;
	}
	```

	Compile and run it with pkg-config inside the container:

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/libconfig:{Tag} \
	    sh -c 'g++ $(pkg-config --cflags libconfig++) example.cpp -o example_cpp $(pkg-config --libs libconfig++) && ./example_cpp'
	```

	Expected output:

	```
	libconfig:8080
	```

- Start a long-running container for exploration

	```bash
	docker run -d --name my-libconfig openeuler/libconfig:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-libconfig
	```

- To get an interactive shell

	```bash
	docker exec -it my-libconfig bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
