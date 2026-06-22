# Quick reference

- The official E2B docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# E2B | openEuler
Current E2B images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

E2B is an open-source infrastructure for AI code execution sandboxes. It provides secure, isolated cloud environments where AI agents can safely run code, execute scripts, and interact with the filesystem. E2B is widely used in AI Coding Agent, data analysis, and code interpreter scenarios. This image contains the `e2b` Python SDK, enabling programmatic creation and management of sandbox instances.

Read more on [E2B Website](https://e2b.dev/).

# Supported tags and respective dockerfile links
The tag of each `e2b` docker image is consist of the version of `e2b` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [2.29.4-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/e2b/2.29.4/24.03-lts-sp3/Dockerfile) | E2B Python SDK 2.29.4 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/e2b` image from docker

	```
	docker pull openeuler/e2b:{Tag}
	```

- Start an interactive Python session

    ```
    docker run -it --rm openeuler/e2b:{Tag} python3
    ```

- Verify the e2b SDK installation

    ```
    docker run --rm openeuler/e2b:{Tag} python3 -c "import e2b; print(e2b.__version__)"
    ```

- Run a script with the e2b SDK

    ```
    docker run --rm -v $(pwd):/workspace openeuler/e2b:{Tag} python3 /workspace/your_script.py
    ```
    The `openeuler/e2b` image is used to verify the integration between the upstream E2B Python SDK version and openEuler.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
