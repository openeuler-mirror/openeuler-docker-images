# Quick reference

- The official Glibc docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Glibc | openEuler
Current Glibc docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The GNU C Library project provides the core libraries for the GNU system and GNU/Linux systems, as well as many other 
systems that use Linux as the kernel. These libraries provide critical APIs including ISO C11, POSIX.1-2008, BSD, 
OS-specific APIs and more. These APIs include such foundational facilities as open, read, write, malloc, printf, 
getaddrinfo, dlopen, pthread_create, crypt, login, exit and more.

Learn more about Glibc on [Glibc Website](https://sourceware.org/glibc/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `glibc` docker image is consist of the version of `glibc` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.41-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/glibc/2.41/24.03-lts-sp1/Dockerfile)| glibc 2.41 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/glibc` image from docker

	```bash
	docker pull openeuler/glibc:{Tag}
	```

- To run and enter the glibc container with an interactive shell:

	```bash
	docker run -it --rm openeuler/glibc:{Tag} bash
	```
 
- Write a test program
    Here is an example:
    ```bash
	#include <stdio.h>
    #include <gnu/libc-version.h>
    
    int main() {
        printf("Hello, Glibc 2.41!\n");
        printf("Current Glibc version: %s\n", gnu_get_libc_version());
        return 0;
    }
	```
    You'll need to hava GCC installed first to compile this program.
    ```
    dnf install -y gcc
    ```
  
- Compile the program against the new glibc version
    
    Create a simple C program (e.g., test.c) to verify Glibc functionality. The glibc is installed at `/usr/local/glibc`, specify the compiler options with the glibc directory.

    ```bash
	 gcc test.c -o test_program \
     -I/usr/local/glibc/include \
     -Wl,--rpath=/usr/local/glibc/lib \
     -Wl,--dynamic-linker=/usr/local/glibc/lib/ld-linux-aarch64.so.1
	```
    This compilation command targets the aarch64 platform, you need to modify the dynamic linker path to match the target platform.
    
    After successful compilation, execute the binary to verify the output message:
    ```
    ./test_program
    ```
    
- Key Parameter Description:
    
    |    Parameter   |  Function  |
    |----------|-------------|
    | -I/usr/local/glibc/include | Specifies the header file path of the new Glibc version. |
    | -Wl,--rpath=/usr/local/glibc/lib | Priorities loading libraries from this path during runtime. |
    | -Wl,--dynamic-linker=/usr/local/glibc/lib/ld-linux-aarch64.so.1 | Specifies the new version dynamic linker. |

 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).