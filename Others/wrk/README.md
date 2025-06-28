# Quick reference

- The official wrk docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# wrk | openEuler
Current wrk docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

wrk is a modern HTTP benchmarking tool capable of generating significant load when run on a single multi-core CPU. It combines a multithreaded design with scalable event notification systems such as epoll and kqueue.

# Supported tags and respective Dockerfile links
The tag of each `wrk` docker image is consist of the version of `wrk` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[4.2.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/wrk/4.2.0/24.03-lts-sp1/Dockerfile)| wrk 4.2.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/wrk` image from docker

	```bash
	docker pull openeuler/wrk:{Tag}
	```
 
- Run with an interactive shell

    You can start the container with an interactive shell to use wrk.
    ```
    docker run -it --rm openeuler/wrk:{Tag} bash
    ```

- Start a simple HTTP server

    In the directory containing you `index.html` file, run:
    ```
    nohup python3 -m http.server 8080 &
    ```
    * This command will serve files from the current directory on port `8080`.
    * `nohup` and `&` allow the sever to keep running in the background.

- Run a stress test using `wrk`
    
    Once the server is running, use `wrk` to generate HTTP load:
    ```
    wrk -t12 -c400 -d30s http://127.0.0.1:8080/index.html
    ```
    `Options:`
    * `-t12:` Use 12 threads to generate load.
    * `-c400:` Use 400 open HTTP connections.
    * `-d30s:` Run the test for 30 seconds.
    * `http://127.0.0.1:8080/index.html:` Target URL to test. 

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).