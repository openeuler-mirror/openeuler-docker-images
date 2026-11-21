# Quick reference

- The official StratoVirt docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# StratoVirt | openEuler
Current StratoVirt images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

StratoVirt is an enterprise-level virtualization platform for cloud data centers in the computing industry. It implements a set of architecture that supports three scenarios: virtual machines, containers, and serverless computing. StratoVirt has competitive advantages in light weight and low noise, software and hardware coordination, and Rust language-level security.

Read more on [StratoVirt](https://gitcode.com/openeuler/stratovirt).

# Supported tags and respective Dockerfile links
The tag of each `stratovirt` docker image is consist of the version of `stratovirt` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[2.4.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/stratovirt/2.4.0/24.03-lts-sp4/Dockerfile) | Stratovirt 2.4.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/stratovirt` image from docker

	```
	docker pull openeuler/stratovirt:{Tag}
	```

- Check the installed stratovirt version

	```
	docker run --rm openeuler/stratovirt:{Tag} stratovirt -version
	```

- Run a microVM with StratoVirt

	Prepare a PE or bzImage format Linux kernel and an EXT4 raw format rootfs image, then run:

	```
	docker run --rm --privileged -v /path/to/images:/images openeuler/stratovirt:{Tag} \
	    stratovirt \
	    -machine microvm \
	    -kernel /images/kernel \
	    -append "console=ttyS0 root=/dev/vda reboot=k panic=1" \
	    -drive file=/images/rootfs,id=rootfs,readonly=off \
	    -device virtio-blk-device,drive=rootfs,id=rootfs \
	    -qmp unix:/tmp/qmp.socket,server,nowait \
	    -serial stdio
	```

- Start a long-running container for exploration

	```
	docker run -d --name my-stratovirt openeuler/stratovirt:{Tag} sleep infinity
	```

- View the container logs

	```
	docker logs -f my-stratovirt
	```

- To get an interactive shell

	```
	docker exec -it my-stratovirt bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).