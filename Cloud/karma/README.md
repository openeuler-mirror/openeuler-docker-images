# Quick reference

- The official Karma docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# karma | openEuler
Current karma docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Karma is an alert dashboard for Prometheus Alertmanager. Alertmanager UI is useful for browsing alerts and managing silences, but it’s lacking as a dashboard tool - karma aims to fill this gap.

Learn more on [karma website](https://karma-dashboard.io).


# Supported tags and respective Dockerfile links
The tag of each karma docker image is consist of the version of karma and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.120-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/karma/0.120/24.03-lts/Dockerfile)| Karma 0.120 on openEuler 24.03-LTS | amd64, arm64 |


# Usage
- Launch this image locally:

	```bash
	docker run -d --name my-karma -p 8080:8080 openeuler/karma:0.120-oe2403lts
	```
	After the instance `my-karma` is started, access Karma instance at `http://localhost:8080`.

- Parameters:
	| Parameter | Description |
	|--|--|
	| `-p 8080:8080`	 | 	Expose Karma on `localhost:9092`. |

- To debug the container
	```bash
	docker logs -f my-karma
	```
- To get an interactive shell
	```bash
	docker exec -it my-karma /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).