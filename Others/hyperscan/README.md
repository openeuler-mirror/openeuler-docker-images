# Quick reference

- The official Hyperscan docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Hyperscan | openEuler
Current Hyperscan docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Hyperscan is a high-performance multiple regex matching library. It follows the regular expression syntax of the commonly-used libpcre library, but is a standalone library with its own C API.

Learn more about Hyperscan on [Hyperscan Website](https://intel.github.io/hyperscan/dev-reference/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `hyperscan` docker image is consist of the version of `hyperscan` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[5.4.2-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/hyperscan/5.4.2/24.03-lts-sp1/Dockerfile)| Hyperscan 5.4.2 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/hyperscan` image from docker

	```bash
	docker pull openeuler/hyperscan:{Tag}
	```

- Run default unit tests:

    By default, if you start the container without specifying a command (such as `bash`), it will automatically run default unit tests.

	```bash
	docker run -it --rm openeuler/hyperscan:{Tag}
	```
 
- Run with an interactive shell

    You can also start the container with an interactive shell to run your own code using Hyperscan.
    ```
    docker run -it --rm openeuler/hyperscan:{Tag} bash
    ```
    
- Example: A minimal Hyperscan program

    Create a file named `test.cpp` with the following content:
    ```
    #include <hs.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    
    // Callback function that is called each time a match is found
    static int eventHandler(unsigned int id, unsigned long long from,
                            unsigned long long to, unsigned int flags, void *ctx) {
        printf("Match for pattern ID %u at offset %llu - %llu\n", id, from, to);
        return 0; // Continue scanning
    }
    
    int main() {
        const char *pattern = "foo.*bar";    // Regular expression pattern
        const char *input = "some foo stuff and then bar finally";
    
        hs_database_t *database;
        hs_compile_error_t *compile_err;
    
        // Compile the regular expression
        if (hs_compile(pattern, HS_FLAG_DOTALL, HS_MODE_BLOCK, NULL, &database, &compile_err) != HS_SUCCESS) {
            fprintf(stderr, "ERROR: Unable to compile pattern \"%s\": %s\n",
                    pattern, compile_err->message);
            hs_free_compile_error(compile_err);
            return -1;
        }
    
        hs_scratch_t *scratch = NULL;
    
        // Allocate scratch space
        if (hs_alloc_scratch(database, &scratch) != HS_SUCCESS) {
            fprintf(stderr, "ERROR: Unable to allocate scratch space.\n");
            hs_free_database(database);
            return -1;
        }
    
        // Scan the input buffer
        if (hs_scan(database, input, strlen(input), 0, scratch, eventHandler, NULL) != HS_SUCCESS) {
            fprintf(stderr, "ERROR: Unable to scan input buffer.\n");
            hs_free_scratch(scratch);
            hs_free_database(database);
            return -1;
        }
    
        // Free resources
        hs_free_scratch(scratch);
        hs_free_database(database);
    
        return 0;
    }
    ```
    
- Compiling the program:
    Use `g++` to compile and link the program with Hyperscan:
    ```
    g++ test.cpp -o test \
     -I/usr/local/include/hs \
     -L/usr/local/lib \
     -lhs
    ```
- Running the program
    ```
    $ ./test
    Match for pattern ID 0 at offset 0 - 27
    ```
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).