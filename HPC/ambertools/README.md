# Quick reference

- The official AmberTools docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# AmberTools | openEuler
Current AmberTools docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

AmberTools consists of several independently developed packages that work well by themselves, and with Amber24. The suite can also be used to carry out complete molecular dynamics simulations, with either explicit water or generalized Born solvent models.

Read more on [AmberTools Website](https://ambermd.org/AmberTools.php).

# Supported tags and respective Dockerfile links
The tag of each `ambertools` docker image is consist of the version of `ambertools` and the version of basic image. The details are as follows

| Tag                                                                                                                            | Currently                                | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|---------------|
| [24.8-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/ambertools/24.8/24.03-lts-sp2/Dockerfile) | AmberTools 24 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/ambertools` image from docker

	```bash
	docker pull openeuler/ambertools:{Tag}
	```

- Start a ambertools instance

    ```
    docker run -it --rm openeuler/ambertools:{Tag}
    ```
  
    When launching `tleap`, the program displays initialization information:
    ```
    -I: Adding /opt/amber24/dat/leap/prep to search path.
    -I: Adding /opt/amber24/dat/leap/lib to search path. 
    -I: Adding /opt/amber24/dat/leap/parm to search path.
    -I: Adding /opt/amber24/dat/leap/cmd to search path.

    Welcome to LEaP!
    (no leaprc in search path)
    >
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).