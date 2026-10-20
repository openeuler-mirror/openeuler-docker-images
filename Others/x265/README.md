# Quick reference

- The official x265 docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# x265 | openEuler

Current x265 docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

x265 is an H.265/HEVC video encoder that provides a command-line encoder and a library for video encoding. This image includes the 8-bit encoder, shared and static libraries, headers, and pkg-config metadata.

Learn more on [x265](https://github.com/Multicorewareinc/x265).

# Supported tags and respective Dockerfile links

The tag of each `x265` docker image consists of the version of `x265` and the version of the base image. The details are as follows:

| Tag | Currently | Architectures |
| --- | --- | --- |
| [4.2-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/x265/4.2/24.03-lts-sp4/Dockerfile) | x265 4.2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/x265` image from docker

    ```bash
    docker pull openeuler/x265:{Tag}
    ```

- Display the encoder version

    ```bash
    docker run --rm openeuler/x265:{Tag} x265 --version
    ```

- Encode a video

    Place an 8-bit I420 raw video named `input.yuv` in the current directory. Adjust the resolution and frame rate to match the input. The encoded video is saved as `output.hevc` in the same directory.

    ```bash
    docker run --rm -v "$PWD:/workspace" openeuler/x265:{Tag} \
      x265 --input input.yuv --input-res 1920x1080 --fps 30 \
      --preset faster --frames 30 --output output.hevc
    ```

- Run a simple encoding test

    Generate ten synthetic I420 frames and encode them:

    ```bash
    docker run --rm openeuler/x265:{Tag} bash -c \
      'dd if=/dev/zero of=/tmp/input.yuv bs=6144 count=10 &&
       x265 --input /tmp/input.yuv --input-res 64x64 --fps 25 --frames 10 \
         --preset ultrafast --pools none --output /tmp/output.hevc &&
       test -s /tmp/output.hevc'
    ```

- Open an interactive shell

    ```bash
    docker run -it --rm openeuler/x265:{Tag} bash
    ```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
