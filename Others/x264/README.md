# Quick reference

- The official x264 docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# x264 | openEuler

Current x264 docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

x264 is an H.264/AVC video encoder that provides a command-line encoder and a library for video encoding. This image includes the command-line encoder, shared library, headers, and pkg-config metadata.

Learn more on [x264](https://code.videolan.org/videolan/x264).

# Supported tags and respective Dockerfile links

The tag of each `x264` docker image consists of the version of `x264` and the version of the base image. The details are as follows:

| Tag | Currently | Architectures |
| --- | --- | --- |
| [0480cb05-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/x264/0480cb05/24.03-lts-sp4/Dockerfile) | x264 0480cb05 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/x264` image from docker

    ```bash
    docker pull openeuler/x264:{Tag}
    ```

- Display the encoder version

    ```bash
    docker run --rm openeuler/x264:{Tag} x264 --version
    ```

- Encode a video

    Place an 8-bit I420 raw video named `input.yuv` in the current directory. Adjust the resolution and frame rate to match the input. The encoded video is saved as `output.h264` in the same directory.

    ```bash
    docker run --rm -v "$PWD:/workspace" openeuler/x264:{Tag} \
      x264 --input-res 1920x1080 --fps 30 \
      --preset faster --frames 30 --output output.h264 input.yuv
    ```

- Run a simple encoding test

    Generate ten synthetic I420 frames and encode them:

    ```bash
    docker run --rm openeuler/x264:{Tag} bash -c \
      'dd if=/dev/zero of=/tmp/input.yuv bs=6144 count=10 &&
       x264 --input-res 64x64 --fps 25 --frames 10 \
         --preset ultrafast --threads 1 --output /tmp/output.h264 /tmp/input.yuv &&
       test -s /tmp/output.h264'
    ```

- Open an interactive shell

    ```bash
    docker run -it --rm openeuler/x264:{Tag} bash
    ```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
