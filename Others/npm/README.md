# Quick reference

- The official npm docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# npm | openEuler
Current npm docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

npm is the world's largest software registry. Open source developers from every continent use npm to share and borrow packages, and many organizations use npm to manage private development as well.

Learn more about npm on [npm Website](https://docs.npmjs.com/about-npm)⁠.

# Supported tags and respective Dockerfile links
The tag of each `npm` docker image is consist of the version of `npm` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[11.6.2-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/npm/11.6.2/24.03-lts-sp2/Dockerfile) | npm 11.6.2 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[11.4.2-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/npm/11.4.2/24.03-lts-sp1/Dockerfile)| npm 11.4.2 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/npm` image from docker

	```bash
	docker pull openeuler/npm:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use npm.
    ```
    docker run -it --rm openeuler/npm:{Tag} bash
    ```

- Using npm CLI
    
    To install the latest version of a module from the npm registry.
    ```
    npm install <package_name>
    ```
    
    Example:
    ```
    npm install sax
    ```
    Key features:
    * Omitting the version tag (`@latest`) defaults to installing the latest stable version.
    * The command automatically retrieves the package tagged as `latest` in the registry.

>[!WARNING]
>Do not run `npm install` in root directory (`/`). This will cause dependency resolution errors.

- View all available commands:

    Refer to the complete [npm CLI documentation](https://docs.npmjs.com/cli/v11/commands/npm)
    ```
    npm help
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).