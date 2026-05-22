# Quick reference

- The official libwebp docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# libwebp | openEuler
Current libwebp docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

WebP codec is a library to encode and decode images in WebP format. This package contains the library that can be used in other programs to add WebP support, as well as the command line tools 'cwebp' and 'dwebp' to compress and decompress images respectively.

Learn more about libwebp on [WebP](https://developers.google.com/speed/webp).

# Supported tags and respective Dockerfile links
The tag of each `libwebp` docker image is consist of the version of `libwebp` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.6.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/libwebp/1.6.0/24.03-lts-sp3/Dockerfile) | libwebp 1.6.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage

- Pull the `openeuler/libwebp` image from docker

	```bash
	docker pull openeuler/libwebp:{Tag}
	```

- Encode an image to WebP format using cwebp:

	```bash
	docker run --rm -v $(pwd):/work openeuler/libwebp:{Tag} cwebp -q 80 /work/input.png -o /work/output.webp
	```

- Decode a WebP image to PNG format using dwebp:

	```bash
	docker run --rm -v $(pwd):/work openeuler/libwebp:{Tag} dwebp /work/input.webp -o /work/output.png
	```

- View WebP file information:

	```bash
	docker run --rm -v $(pwd):/work openeuler/libwebp:{Tag} webpinfo /work/input.webp
	```

- Create animated WebP from image sequence:

	```bash
	docker run --rm -v $(pwd):/work openeuler/libwebp:{Tag} img2webp /work/frame1.png /work/frame2.png -o /work/output.webp
	```

- Convert animated GIF to WebP:

	```bash
	docker run --rm -v $(pwd):/work openeuler/libwebp:{Tag} gif2webp /work/input.gif -o /work/output.webp
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
