# Quick reference

- The official jemalloc docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# jemalloc | openEuler
Current jemalloc docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

jemalloc is a general purpose malloc(3) implementation that emphasizes fragmentation avoidance and scalable concurrency support.  jemalloc first came into use as the FreeBSD libc allocator in 2005, and since then it has found its way into numerous applications that rely on its predictable behavior.  In 2010 jemalloc development efforts broadened to include developer support features such as heap profiling and extensive monitoring/tuning hooks.  Modern jemalloc releases continue to be integrated back into FreeBSD, and therefore versatility remains critical.  Ongoing development efforts trend toward making jemalloc among the best allocators for a broad range of demanding applications, and eliminating/mitigating weaknesses that have practical repercussions for real world applications.

Learn more on [jemalloc](https://jemalloc.net/).

# Supported tags and respective Dockerfile links
The tag of each `jemalloc` docker image is consist of the version of `jemalloc` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[5.4.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/jemalloc/5.4.0/24.03-lts-sp4/Dockerfile) | jemalloc 5.4.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/jemalloc` image from docker

	```bash
	docker pull openeuler/jemalloc:{Tag}
	```

- Check the installed jemalloc version

	```bash
	docker run --rm openeuler/jemalloc:{Tag} jemalloc-config --version
	```

- Compile and run a program linked against jemalloc

	Create a file named `hello.c` in the current directory:

	```c
	#include <stdlib.h>
	#include <stdio.h>

	int main(void) {
	    void *p = malloc(64);
	    printf("jemalloc malloc returned %p\n", p);
	    free(p);
	    return 0;
	}
	```

	Compile and run it inside the container:

	```bash
	docker run --rm -v "$(pwd)":/work -w /work openeuler/jemalloc:{Tag} \
	    sh -c 'gcc -o hello hello.c -ljemalloc && ./hello'
	```

- Use jemalloc as the allocator of another program via `LD_PRELOAD`

	```bash
	docker run --rm openeuler/jemalloc:{Tag} \
	    sh -c 'LD_PRELOAD=/usr/local/lib/libjemalloc.so.2 ls -l /usr/local/lib'
	```

- Start a long-running container for exploration

	```bash
	docker run -d --name my-jemalloc openeuler/jemalloc:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-jemalloc
	```

- To get an interactive shell

	```bash
	docker exec -it my-jemalloc bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
