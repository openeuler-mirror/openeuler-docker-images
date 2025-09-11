# Quick reference

- The official Next.js docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Next.js | openEuler
Current Next.js docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Next.js is a React framework for building full-stack web applications. You use React Components to build user interfaces, and Next.js for additional features and optimizations.

Learn more on [Next.js Website](https://nextjs.org/docs)⁠.

# Supported tags and respective Dockerfile links
The tag of each `next` docker image is consist of the version of `next` and the version of basic image. The details are as follows

|    Tag   | Currently                                 |   Architectures  |
|----------|-------------------------------------------|------------------|
|[15.5.3-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/next/15.5.3/24.03-lts-sp2/Dockerfile) | next 15.5.3 on openEuler 24.03-LTS-SP2 | amd64, arm64 |
|[15.5.2-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/next/15.5.2/24.03-lts-sp1/Dockerfile) | next 15.5.2 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[15.3.4-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/next/15.3.4/24.03-lts-sp1/Dockerfile)| Next.js 15.3.4 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/next` image from docker

	```bash
	docker pull openeuler/next:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use next.
    ```
    docker run -it --rm openeuler/next:{Tag} bash
    ```

- Create a Next.js Project
    
    Run the following command to set up a new Next.js app:
    ```
    npx create-next-app@lateste
    ```
    This will:
    * Prompt you to name your project (or use the default my-app)
    * Install all required dependencies
    * Set up a basic Next.js project structure
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).