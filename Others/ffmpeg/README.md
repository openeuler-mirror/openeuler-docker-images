# Quick reference

- The official FFmpeg docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# FFmpeg | openEuler

Current FFmpeg docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

FFmpeg is a collection of libraries and tools to process multimedia content such as audio, video, subtitles and related metadata.

Learn more on [FFmpeg](https://ffmpeg.org/).

# Supported tags and respective Dockerfile links

The tag of each `ffmpeg` docker image is consist of the version of `ffmpeg` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[9.1-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/ffmpeg/9.1/24.03-lts-sp4/Dockerfile) | ffmpeg 9.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/ffmpeg` image from docker

	```bash
	docker pull openeuler/ffmpeg:{Tag}
	```

- Display the FFmpeg version

	```bash
	docker run --rm openeuler/ffmpeg:{Tag} ffmpeg -version
	```

- Convert a media file

	Place an input media file such as `input.mp4` in the current directory. The converted output is written as `output.avi` in the same directory.

	```bash
	docker run --rm -v "$PWD":/workspace openeuler/ffmpeg:{Tag} \
	    ffmpeg -i input.mp4 output.avi
	```

- Start a long-running container for exploration

	```bash
	docker run -d --name my-ffmpeg openeuler/ffmpeg:{Tag} sleep infinity
	```

- View the container logs

	```bash
	docker logs -f my-ffmpeg
	```

- To get an interactive shell

	```bash
	docker exec -it my-ffmpeg bash
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
