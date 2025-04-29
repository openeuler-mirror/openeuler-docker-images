# Quick reference

- The official apache kudu docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# Kudu | openEuler
Current kudu docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Kudu is an open source distributed data storage engine that makes fast analytics on fast and changing data easy.

Learn more on [Kudu website](https://kudu.apache.org/).


# Supported tags and respective Dockerfile links
The tag of each kudu docker image consists of the version of kudu and the version of base image. The details are as follows
| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[1.17.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/kudu/1.17.1/24.03-lts/Dockerfile)| Apache kudu 1.17.1 on openEuler 24.03-LTS | amd64, arm64 |


# Usage
Here, users can select the `{Tag}` by requirements.

- Pull the `openeuler/kudu` image
	```bash
	docker pull openeuler/kudu:{Tag}
	```
- Run kudu container

	You can use the following command to find out how to run it:
	```bash
	docker run --name my-kudu openeuler/kudu:{Tag} help
	```
	You will see something like this
	```
	Supported commands:
   	master     - Start a Kudu Master
   	tserver    - Start a Kudu TServer
   	kudu       - Run the Kudu CLI
   	help       - print useful information and exit

	Other commands can be specified to run shell commands.
	...
	```
	Above shows the supported commands, you can use this container following [kudu documentation](https://kudu.apache.org/docs/quickstart.html).

- View container running logs
	```bash
	docker logs -f my-kudu
	```
- To get an interactive shell
	```bash
	docker exec -it my-kudu /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).