# Quick reference

- The official LLVM docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# LLVM | openEuler
Current LLVM docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

LLVM is a general-purpose compiler infrastructure that provides a modular and reusable backend for building modern compilers. 

Learn more about LLVM on [LLVM Website](https://llvm.org/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `llvm` docker image is consist of the version of `llvm` and the version of basic image. The details are as follows

| Tag                                                                                                                             | Currently                              | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
|[21.1.2-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/llvm/21.1.2/24.03-lts-sp2/Dockerfile) | llvm 21.1.2 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[21.1.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/llvm/21.1.1/24.03-lts-sp2/Dockerfile) | llvm 21.1.1 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[21.1.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/llvm/21.1.0/24.03-lts-sp1/Dockerfile) | llvm 21.1.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
| [20.1.6-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/llvm/20.1.6/24.03-lts-sp1/Dockerfile) | LLVM 20.1.6 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/llvm` image from docker

	```bash
	docker pull openeuler/llvm:{Tag}
	```
 
- Run with an interactive shell

    You can start the container with an interactive shell to run your own code using llvm.
    ```
    docker run -it --rm openeuler/llvm:{Tag} bash
    ```
    The `openeuler/llvm` image is used to verify the integration between the upstream LLVM version and openEuler. 
    
- Create simple C source file 

    ```
    cat > /tmp/hello.c <<EOF
    #include <stdio.h>
    void hello() {
      printf("Hello from Clang!\\n");
    }
    EOF
    ```
    
- Compile to object file (.o):
    
    Use `clang` to compile but not link:
    ```
    /usr/local/llvm/bin/clang -c /tmp/hello.c -o /tmp/hello.o
    ```
    The `-c` flag tells `clang` to stop after producing the object file.
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).