# Quick reference

- The official sysbench docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# sysbench | openEuler
Current sysbench docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

sysbench is a scriptable multi-threaded benchmark tool based on LuaJIT. It is most frequently used for database benchmarks, but can also be used to create arbitrarily complex workloads that do not involve a database server.

# Supported tags and respective Dockerfile links
The tag of each `sysbench` docker image is consist of the version of `sysbench` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.0.20-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/sysbench/1.0.20/24.03-lts-sp1/Dockerfile)| sysbench 1.0.20 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/sysbench` image from docker

	```bash
	docker pull openeuler/sysbench:{Tag}
	```
 
- Run with an interactive shell

    You can also start the container with an interactive shell to use sysbench.
    ```
    docker run -it --rm openeuler/sysbench:{Tag} bash
    ```

- CPU Benchmark

    Measure how many arithmetic operations (calculating prime numbers) your CPU can perform under multi-threaded load.
    Example:
    ```
    sysbench cpu --cpu-max-prime=20000 --threads=4 run
    ```
    `Options:`
    * `--cpu-max-prime=20000`: Defines the maximum prime number to calculate. Higher values generate a heavier CPU worload.
    * `--threads=4`: Number of worker threads to use. You can set this according you physical CPU cores.
    * `run`: Execute the test.

- Memory benchmark
    
    Measure your system`s memory bandwidth by continuously reading and writing memory blocks.
    Example:
    ```
    sysbench memory --memory-block-size=1M --memory-total-size=10G run
    ```
    `Options:`
    * `--memory-block-size=1M:` Size of each memory block for read/write operations. Default is 1k.
    * `--memory-total-size=10G:` Total amount of data to transfer. Larger values produce more stable results.
    * `run:` Execute the test.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).