# Quick reference

- The official FSL docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# FSL | openEuler
FSL is a comprehensive library of analysis tools for FMRI, MRI and diffusion brain imaging data. It runs on macOS (Intel and Apple Silicon), Linux, and Windows (via the Windows Subsystem for Linux), and is very easy to install. Most of the tools can be run both from the command line and as GUIs ("point-and-click" graphical user interfaces).

Learn more on [FSL - FMRIB Software Library](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/).

# Supported tags and respective Dockerfile links
The tag of each `fsl` docker image is consist of the version of `fsl` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[6.0.7.23-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/fsl/6.0.7.23/24.03-lts-sp4/Dockerfile)| fsl 6.0.7.23 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/fsl` image from docker

	```bash
	docker pull openeuler/fsl:{Tag}
	```

- Start a container to check the FSL version

	```bash
	docker run --rm openeuler/fsl:{Tag} cat /usr/local/fsl/etc/fslversion
	```

- Run an FSL command to verify the installation

	```bash
	docker run --rm openeuler/fsl:{Tag} fslmaths
	```

- Run a brain extraction with BET

	```bash
	docker run --rm -v $PWD:/data -w /data openeuler/fsl:{Tag} bet /data/input.nii.gz /data/brain -m
	```

- View the logs of a running container

	```bash
	docker logs <container>
	```

- Open an interactive shell inside a running container

	```bash
	docker exec -it <container> bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).