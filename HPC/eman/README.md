# Quick reference

- The official eman container image.
- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).
- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# eman | openEuler
Current eman docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

EMAN2 is a broadly based scientific image processing suite (largely greyscale) with a primary focus on processing data from transmission electron microscopes. EMAN's original purpose was performing single particle reconstructions (3-D volumetric models from 2-D cryo-EM images) at the highest possible resolution, but the suite now also offers support for single particle cryo-ET, and tools useful in many other subdisciplines such as helical reconstruction, 2-D crystallography and whole-cell tomography. EMAN2 is capable of processing large data sets (>100,000 particle) very efficiently.

Learn more on [EMAN2 website](http://eman2.org).

# Supported tags and respective Dockerfile links
The tag of each eman container image is consist of the version of eman and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[2.99.69-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/eman/2.99.69/24.03-lts-sp1/Dockerfile)| EMAN2 2.99.69 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
- Pull the `openeuler/eman` image from `hub.docker.com`
	```
	docker pull openeuler/eman:{Tag}
	```
- Start a `eman2` instance
	```
	docker run -it --name my-eman openeuler/eman:{Tag}
	```
    To use EMAN2, you should activate `eman2` environment first
    ```
    conda activate eman2
    ```

- Run `e2speedtest.py` for testing
    ```
    /usr/local/miniconda/envs/eman2/bin/e2speedtest.py
    ```
    And the result will like
    ```
    This could take a few minutes. Please be patient.
    Initializing
    ....................
    ....................
    ....................
    ....................
    ....................
    ....................
    ....................
    ....................

    Your machines speed factor = 2.6758 +- 0.0200 (0.0086 +- 0.00006 sec)
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).