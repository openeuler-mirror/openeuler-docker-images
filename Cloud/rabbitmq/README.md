# Quick reference

- The official rabbitmq docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# rabbitmq | openEuler
RabbitMQ is a powerful, enterprise grade open source messaging and streaming broker that enables efficient, reliable and versatile communication for applications — perfect for distributed microservices, real-time data, and IoT.


# Supported tags and respective Dockerfile links
The tag of each rabbitmq docker image is consist of the version of rabbitmq and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3.9.10-oe2203lts](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/rabbitmq/3.9.10/22.03-lts/Dockerfile) | rabbitmq 3.9.10 on openEuler 22.03-lts | amd64, arm64 |
|[3.9.10-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/rabbitmq/3.9.10/24.03-lts-sp4/Dockerfile) | rabbitmq 3.9.10 on openEuler 24.03-lts-sp4 | amd64, arm64 |


# Usage
Pull the image and run a RabbitMQ container:

```
docker pull openeuler/rabbitmq:{Tag}
```

```
docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 openeuler/rabbitmq:{Tag}
```

The AMQP 0-9-1 client connections are accepted on port 5672, and the management UI is available on port 15672.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
