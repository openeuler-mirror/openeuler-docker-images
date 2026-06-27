# Quick reference

- The official Fire-Flyer File System (3FS) docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Fire-Flyer File System (3FS) | openEuler
Current 3FS docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Fire-Flyer File System (3FS) is a high-performance distributed file system designed by DeepSeek to address the challenges of AI training and inference workloads. It leverages modern SSDs and RDMA networks to provide a shared storage layer.

Learn more on [3FS Documentation](https://github.com/deepseek-ai/3fs).

# Supported tags and respective Dockerfile links
The tag of each `3fs` docker image is consist of the version of `3fs` and the version of basic image. The details are as follows

| Tag                                                                                                                      | Currently                                | Architectures |
|--------------------------------------------------------------------------------------------------------------------------|------------------------------------------|---------------|
|[22fca04-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Storage/3fs/22fca04/24.03-lts-sp3/Dockerfile) | 3fs 22fca04 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/3fs` image from docker

	```bash
	docker pull openeuler/3fs:{Tag}
	```

- View available 3fs binaries

	```
	docker run --rm openeuler/3fs:{Tag} ls /opt/3fs/bin/
	```

- Start a 3fs management service (mgmtd)

	```
	docker run -d \
		--name 3fs-mgmtd \
		-p 8000:8000 \
		-v /path/to/config:/opt/3fs/etc \
		-v /path/to/logs:/var/log/3fs \
		openeuler/3fs:{Tag}
	```

- Start a 3fs metadata service

	```
	docker run -d \
		--name 3fs-meta \
		-v /path/to/config:/opt/3fs/etc \
		openeuler/3fs:{Tag} \
		/opt/3fs/bin/meta_main --cfg /opt/3fs/etc/meta_main_launcher.toml
	```

- Start a 3fs storage service

	```
	docker run -d \
		--name 3fs-storage \
		-v /path/to/config:/opt/3fs/etc \
		-v /path/to/data:/opt/3fs/data \
		openeuler/3fs:{Tag} \
		/opt/3fs/bin/storage_main --cfg /opt/3fs/etc/storage_main_launcher.toml
	```

- Check container logs

	```
	docker logs -f 3fs-mgmtd
	```

- Access container shell

	```
	docker exec -it 3fs-mgmtd /bin/bash
	```

The configuration files (`mgmtd_main_launcher.toml`, `meta_main_launcher.toml`, `storage_main_launcher.toml`, `fdb.cluster`) must be prepared and mounted to `/opt/3fs/etc` before starting the services.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
