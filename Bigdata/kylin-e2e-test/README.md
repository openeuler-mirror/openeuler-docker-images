# Quick reference

- The official kylin docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# kylin-e2e-test | openEuler
Current kylin docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Kylin is a high concurrency, high performance and intelligent OLAP engine that provides low-cost and ultimate data analytics experience.

Learn more on [Welcome to Apache Kylin | Apache Kylin](https://kylin.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each kylin docker image is consist of the version of kylin and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[5.0.3-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kylin-e2e-test/5.0.3/24.03-lts-sp4/Dockerfile) | kylin 5.0.3 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
Deploy a Kylin instance without any pre-deployed hadoop component by following command:

	```bash
	docker pull openeuler/kylin-e2e-test:{Tag}

	docker run -d \
	    --name Kylin \
	    --hostname localhost \
	    -e TZ=UTC \
	    -m 10G \
	    -p 7070:7070 \
	    -p 8088:8088 \
	    -p 9870:9870 \
	    -p 8032:8032 \
	    -p 8042:8042 \
	    -p 2181:2181 \
	    openeuler/kylin-e2e-test:{Tag}

	docker logs --follow Kylin
	```

The following message indicates that the Kylin is ready :

	```
	Kylin service is already available for you to preview.
	```

After that, please press Ctrl + C to exit docker logs, and visit Kylin web UI.
| Service Name |   URL    |
|--------------|----------|
|Kylin         | http://localhost:7070/kylin⁠ |
|Yarn          | http://localhost:8088⁠       |
|HDFS          | http://localhost:9870⁠       |

When you log in Kylin web UI, please remember your username is ADMIN , and password is KYLIN .

To log into the container to configure and restart the Kylin instance, use the following command.

	```
	docker exec -it Kylin /bin/bash
	```

To stop and remove the container, use these commands.

	```
	docker stop Kylin
	docker rm Kylin
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
