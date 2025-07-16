# Quick reference

- The official Bcache docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Bcache | openEuler
Current bcache docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Bcache is a patch for the Linux kernel to use SSDs to cache other block devices. For more information, see http://bcache.evilpiepirate.org. Documentation for the run time interface is included in the kernel tree, in Documentation/bcache.txt.

# Supported tags and respective Dockerfile links
The tag of each `bcache` docker image is consist of the version of `bcache` and the version of basic image. The details are as follows

| Tag                                                                                                                     | Currently                         | Architectures |
|-------------------------------------------------------------------------------------------------------------------------|-----------------------------------|---------------|
| [1.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/bcache/1.1/24.03-lts/Dockerfile) | Bcache 1.1 on openEuler 24.03-LTS | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/bcache` image from docker

	```bash
	docker pull openeuler/bcache:{Tag}
	```

- Start a bcache instance

    ```
    docker run -it --rm openeuler/bcache:{Tag}
    ```
    The `openeuler/bcache` image is used to verify the integration between the upstream bcache version and openEuler.
        
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).