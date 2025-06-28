# Quick reference

- The official WebBench docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# WebBench | openEuler
Current WebBench docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

WebBench is a lightweight and easy-to-use HTTP benchmarking tool designed to measure the performance of web servers. It simulates multiple concurrent clients sending HTTP
request to a target server, allowing users to evaluate throughput, reponse time, and concurrency handing capabilities.

# Supported tags and respective Dockerfile links
The tag of each `webbench` docker image is consist of the version of `webbench` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.5-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/webbench/1.5/24.03-lts-sp1/Dockerfile)| webbench 1.5 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/webbench` image from docker

	```bash
	docker pull openeuler/webbench:{Tag}
	```
 
- Run with an interactive shell

    You can start the container with an interactive shell to use webbench.
    ```
    docker run -it --rm openeuler/webbench:{Tag} bash
    ```

- Start a simple HTTP server

    In the directory containing you `index.html` file, run:
    ```
    nohup python3 -m http.server 8080 &
    ```
    * This command will serve files from the current directory on port `8080`.
    * `nohup` and `&` allow the sever to keep running in the background.

- Test GET request
    
    Once the server is running, use `webbench` to generate HTTP load:
    ```
    webbench -c 100 -t 30 http://127.0.0.1:8080/index.html
    ```
    This means using `100 concurrent clients` to test accessing `http://127.0.0.1:8080/index.html` for `30 seconds`.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).