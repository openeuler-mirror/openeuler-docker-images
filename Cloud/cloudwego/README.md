# Quick reference

- The official CloudWeGo docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# CloudWeGo | openEuler
Current CloudWeGo images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

CloudWeGo is a leading practice for building enterprise-class cloud native architectures from ByteDance. It provides a set of high-performance, strongly extensible microservice frameworks and tools for Go. This image includes the core code generation tools:
- **kitex** — Code generation tool for the Kitex RPC framework
- **hz** — Code generation tool for the Hertz HTTP framework

Read more on [CloudWeGo](https://www.cloudwego.io/).

# Supported tags and respective dockerfile links
The tag of each `cloudwego` docker image is consist of the version of `cloudwego` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[0.16.2-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/cloudwego/0.16.2/24.03-lts-sp3/Dockerfile) | CloudWeGo (kitex 0.16.2 + hz 0.10.5) on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/cloudwego` image from docker

	```
	docker pull openeuler/cloudwego:{Tag}
	```

- Use the kitex code generation tool

    ```
    docker run --rm -v $(pwd):/workspace openeuler/cloudwego:{Tag} \
        kitex -module example.com/myservice path/to/my.thrift
    ```

- Use the hz code generation tool

    ```
    docker run --rm -v $(pwd):/workspace openeuler/cloudwego:{Tag} \
        hz new -module example.com/myproject
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
