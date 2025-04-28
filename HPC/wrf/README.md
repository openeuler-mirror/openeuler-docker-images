# Quick reference

- The official WRF docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# WRF | openEuler
Current WRF docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Weather Research & Forecasting Model (WRF), is a state of the art mesoscale numerical weather prediction system designed for both atmospheric research and operational forecasting applications.

Learn more on [WRF website](https://www.mmm.ucar.edu/models/wrf).

# Supported tags and respective Dockerfile links
The tag of each `wrf` docker image is consist of the version of `wrf` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[4.6.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/wrf/4.6.1/24.03-lts/Dockerfile)| WRF 4.6.1 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
Here, users can select the corresponding `{Tag}` by requirements.

- Pull the `openeuler/wrf` image from docker

	```bash
	docker pull openeuler/wrf:{Tag}
	```

- Start an interactive wrf instance

	```bash
	docker run -ti --name my-wrf openeuler/wrf:{Tag}
	```
	This will give you a bash prompt like this:
	```
	[root@13fb722beaec WRF]$
    ```
	From here, you can begin your work to run the WRF tasks.
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).