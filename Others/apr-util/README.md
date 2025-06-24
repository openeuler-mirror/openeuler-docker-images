# Quick reference

- The official APR-util (Apache Portable Runtime Utilities) docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# APR-util (Apache Portable Runtime Utilities) | openEuler
Current APR-util (Apache Portable Runtime Utilities) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

APR-util (Apache Portable Runtime Utilities) is an extension library for APR (Apache Portable Runtime), providing additional cross-platform utility functions to complement APR's core features.

Learn more about APR-util on [APR-util Website](https://apr.apache.org/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `apr-util` docker image is consist of the version of `apr-util` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.6.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/apr-util/1.6.3/24.03-lts-sp1/Dockerfile)| APR-util 1.6.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/apr-util` image from docker

	```bash
	docker pull openeuler/apr-util:{Tag}
	```
 
- Run with an interactive shell

    You can start the container with an interactive shell to run your own code using APR-util.
    ```
    docker run -it --rm openeuler/apr-util:{Tag} bash
    ```
    
- Example: A minimal APR-util program

    Create a file named `parse.c` with the following content:
    ```
    // parse.c
    #include <apr_general.h>
    #include <apr_uri.h>
    #include <stdio.h>

    int main() {
        apr_initialize();
        apr_pool_t *pool;
        apr_pool_create(&pool, NULL);
    
        apr_uri_t uri;
        const char *url = "http://example.com/path?key=value";
        
        if (apr_uri_parse(pool, url, &uri) == APR_SUCCESS) {
            printf("Host: %s\n", uri.hostname);
        } else {
            printf("Parse failed\n");
        }
    
        apr_pool_destroy(pool);
        apr_terminate();
        return 0;
    }
    ```
    
- Compile the program:
    ```
      gcc parse.c -o parse \
        -I/usr/local/apr/include/apr-1 \
        -I/usr/include/apr-util-1 \
        -L/usr/local/apr/lib \
        -lapr-1 -laprutil-1
    ```
  
- Run the program
    ```
    $ ./parse
    ```
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).