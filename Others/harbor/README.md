# Quick reference

- The official Harbor docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Harbor | openEuler
Harbor is an open source trusted cloud native registry project that stores, signs, and scans content. Harbor extends the open source Docker Distribution by adding the functionalities usually required by users such as security, identity and management. Having a registry closer to the build and run environment can improve the image transfer efficiency. Harbor supports replication of images between registries, and also offers advanced security features such as user management, access control and activity auditing.

Harbor is hosted by the [Cloud Native Computing Foundation](https://cncf.io) (CNCF). If you are an organization that wants to help shape the evolution of cloud native technologies, consider joining the CNCF. For details about whose involved and how Harbor plays a role, read the CNCF
[announcement](https://www.cncf.io/blog/2018/07/31/cncf-to-host-harbor-in-the-sandbox/).

Learn more on [Harbor](https://goharbor.io/).

# Supported tags and respective Dockerfile links
The tag of each `harbor` docker image is consist of the version of `harbor` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.15.2-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/harbor/2.15.2/24.03-lts-sp4/Dockerfile)| Harbor 2.15.2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

This image provides the Harbor core service, the main API and authentication service of Harbor. In a complete Harbor deployment the core service works together with PostgreSQL, Redis, the registry, the jobservice and the portal, as described in the official [Harbor Installation and Configuration Guide](https://goharbor.io/docs/2.15.0/install-config/).

- **Pull the image**

	```bash
	docker pull openeuler/harbor:{Tag}
	```

- **Run the harbor core service**

	```bash
	docker run -d --name my-harbor -p 8080:8080 openeuler/harbor:{Tag}
	```

- **Check the logs**

	```bash
	docker logs -f my-harbor
	```

- **Run a command in the container**

	```bash
	docker exec -it my-harbor /bin/sh
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
