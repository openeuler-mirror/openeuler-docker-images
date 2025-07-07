# Quick reference

- The official musl docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# musl | openEuler
Current musl docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

musl is an implementation of the C standard library built on top of the Linux system call API, including interfaces defined in the base language standard, POSIX, and widely agreed-upon extensions. musl is lightweight, fast, simple, free, and strives to be correct in the sense of standards-conformance and safety.

Learn more about musl on [musl Website](https://musl.libc.org/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `musl` docker image is consist of the version of `musl` and the version of basic image. The details are as follows

| Tag                                                                                                                           | Currently                             | Architectures |
|-------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|---------------|
| [1.2.5-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/musl/1.2.5/24.03-lts-sp1/Dockerfile) | musl 1.2.5 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/musl` image from docker

	```bash
	docker pull openeuler/musl:{Tag}
	```
 
- Run with an interactive shell

    You can start the container with an interactive shell to run your own code using musl.
    ```
    docker run -it --rm openeuler/musl:{Tag} bash
    ```
    
-  Write a Test Program (test.c)

    Create a file named `test.c` with the following content:
    ```
    #include <stdio.h>
    #include <stdlib.h>
    #include <unistd.h>
    
    int main() {
        printf("Hello, musl! (PID: %d)\n", getpid());
        
        // Test memory allocation (musl's malloc implementation)
        int *arr = malloc(10 * sizeof(int));
        if (!arr) {
            perror("malloc failed");
            return 1;
        }
        free(arr);
    
        // Detect C library
        #ifdef __GLIBC__
            printf("C library: glibc\n");
        #else
            printf("C library: musl\n");
        #endif
    
        return 0;
    }
    ```
    
- Compilation Methods

    Static Compilation
    ```
    musl-gcc -static test.c -o static_app
    ./static_app
    ```
    
    Output:
    ```
    Hello, musl! (PID: 147)
    C library: musl
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).