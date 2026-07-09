# Quick reference

- The official vvenc docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# vvenc | openEuler
VVenC, the Fraunhofer Versatile Video Encoder, is a fast and efficient software H.266/VVC encoder implementation with the following main features: Easy to use encoder implementation with five predefined quality/speed presets; Perceptual optimization to improve subjective video quality, based on the XPSNR visual model; Extensive frame-level and task-based parallelization with very good scaling; Frame-level single-pass and two-pass rate control supporting variable bit-rate (VBR) encoding.


# Supported tags and respective Dockerfile links
The tag of each vvenc docker image is consist of the version of vvenc and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.14.0-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/vvenc/1.14.0/24.03-lts-sp4/Dockerfile) | vvenc 1.14.0 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[1.14.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/vvenc/1.14.0/24.03-lts-sp3/Dockerfile) | vvenc 1.14.0 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
```
docker pull openeuler/vvenc:{Tag}
docker run --rm openeuler/vvenc:{Tag} vvencapp --help
docker run --rm -v $(pwd):/data openeuler/vvenc:{Tag} vvencapp -i /data/input.yuv -s 1920x1080 -o /data/output.266
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
