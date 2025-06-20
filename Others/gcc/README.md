# Quick reference

- The official GCC docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# GCC | openEuler
Current GCC docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The GNU Compiler Collection includes front ends for C, C++, Objective-C, Fortran, Ada, Go, D, Modula-2, and COBOL 
as well as libraries for these languages (libstdc++,...). GCC was originally written as the compiler for the GNU operating system.

Learn more about GCC on [GCC Website](https://gcc.gnu.org/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `gcc` docker image is consist of the version of `gcc` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[15.1.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/gcc/15.1.0/24.03-lts-sp1/Dockerfile)| GCC 15.1.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/gcc` image from docker

	```bash
	docker pull openeuler/gcc:{Tag}
	```
 
- Run with an interactive shell

    You can start the container with an interactive shell to run your own code using gcc.
    ```
    docker run -it --rm openeuler/gcc:{Tag} bash
    ```
    
- Example: A minimal gcc program

    Create a file named `hello.c` with the following content:
    ```
    // hello.c
    #include <stdio.h>

    int main() {
        printf("Hello from GCC %d.%d.%d\n",
               __GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
        return 0;
    }
    ```
    
- Compile the program:
    Use the new version of `gcc` to compile the program:
    ```
    /usr/local/gcc/bin/gcc hello.c -o hello
    ```
  
- Run the program
    ```
    $ ./hello
    ```
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).