# Quick reference

- The official FIO docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# FIO | openEuler
Current FIO docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

FIO was originally written to save me the hassle of writing special test case programs when I wanted to test a specific workload, either for performance reasons or to find/reproduce a bug. The process of writing such a test app can be tiresome, especially if you have to do it often. Hence I needed a tool that would be able to simulate a given I/O workload without resorting to writing a tailored test case again and again.

# Supported tags and respective Dockerfile links
The tag of each `fio` docker image is consist of the version of `fio` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[3.40-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/fio/3.40/24.03-lts-sp1/Dockerfile)| FIO 3.40 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Run with an interactive shell

    To perform a simple disk I/O benchmark using FIO inside a Docker container:
    ```
    docker run -it --rm --privileged openeuler/fio:{Tag} bash
    ```

- Basic random read test 
    
    Run this minimal FIO test inside the container:
    ```
    fio --name=quick_test \
    --rw=randread \       # Random read pattern
    --size=100M \         # Test file size (reduced to 100MB)
    --bs=4k \             # 4KB block size
    --numjobs=1 \         # Single thread (simplified test)
    --runtime=10s \       # Test duration (reduced to 10 seconds)
    --filename=/data/testfile \  # Test file location
    --ioengine=libaio \   # Asynchronous I/O engine
    --group_reporting     # Consolidated output
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).