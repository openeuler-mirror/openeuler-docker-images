# Quick reference

- The official CloudWeGo docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# CloudWeGo | openEuler
Current CloudWeGo images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

CloudWeGo is a leading practice for building enterprise-class cloud native architectures from ByteDance. It provides a set of high-performance, strongly extensible microservice frameworks and tools for Go and Rust. The `0.16.4-oe2403sp4` image includes:
- **kitex** — Code generation tool for the Kitex RPC framework
- **hz** — Code generation tool for the Hertz HTTP framework
- **volo** — Code generation tool for the Volo Rust RPC framework
- **Eino** — Go library for building AI applications; its source is in `/eino` and Go modules are cached in `/go/pkg/mod`. Eino does not provide a standalone CLI.

The source tags are Kitex v0.16.4, Hertz v0.10.6, Volo `volo-thrift-0.12.2`, and Eino v0.9.22. Their CLI version strings are maintained separately upstream: `kitex --version` reports `v0.16.3`, `hz --version` reports `hz version v0.9.7`, and `volo --version` reports `volo 0.12.1` for these tags.

Read more on [CloudWeGo](https://www.cloudwego.io/).

# Supported tags and respective dockerfile links
The tag of each `cloudwego` docker image is consist of the version of `cloudwego` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[0.16.4-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/cloudwego/0.16.4/24.03-lts-sp4/Dockerfile) | CloudWeGo (Kitex 0.16.4 + Hertz 0.10.6 + Volo 0.12.2 + Eino 0.9.22) on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[0.16.4-grpc-identify-cascade-cancel-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/cloudwego/0.16.4-grpc-identify-cascade-cancel/24.03-lts-sp4/Dockerfile) | cloudwego 0.16.4-grpc-identify-cascade-cancel on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[0.16.2-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/cloudwego/0.16.2/24.03-lts-sp4/Dockerfile) | CloudWeGo (kitex 0.16.2 + hz 0.10.5) on openEuler 24.03-LTS-SP4 | amd64, arm64 |
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

- Check the Volo CLI

    ```
    docker run --rm openeuler/cloudwego:0.16.4-oe2403sp4 volo --version
    ```

- Build the bundled Eino library

    ```
    docker run --rm -w /eino openeuler/cloudwego:0.16.4-oe2403sp4 go build ./...
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
