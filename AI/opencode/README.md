# Quick reference

- The official opencode docker image.

- Maintained by: [openEuler infrastructure SIG](https://gitcode.com/openeuler/infrastructure).

- Where to get help: [openEuler infrastructure SIG](https://gitcode.com/openeuler/infrastructure), [openEuler](https://gitee.com/openeuler/community).
# opencode | openEuler
opencode is an open-source AI programming assistant that provides code completion, chat, and other capabilities within the terminal. It supports multiple LLM backends and can be extended with custom tools.


# Supported tags and respective Dockerfile links
The tag of each opencode docker image is consist of the version of opencode and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.1.48-oe2403sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/opencode/1.1.48/24.03-lts-sp4/Dockerfile) | opencode 1.1.48 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[1.1.48-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/opencode/1.1.48/24.03-lts/Dockerfile) | opencode 1.1.48 on openEuler 24.03-lts | amd64, arm64 |


# Usage
This image provides the opencode command-line tool for AI-assisted programming in the terminal.

## Running opencode interactively

```shell
docker run -it --name opencode \
    -v ~/.config/opencode:/root/.config/opencode \
    openeuler/opencode:{Tag}
```

## Viewing help

```shell
docker run --rm openeuler/opencode:{Tag} opencode --help
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
