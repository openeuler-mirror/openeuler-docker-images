# Quick reference

- The official logstash docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# logstash | openEuler
Current logstash docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Logstash is an open source data collection engine with real-time pipelining capabilities. Logstash can dynamically unify data from disparate sources and normalize the data into destinations of your choice.

Collection is accomplished via a number of configurable input plugins including raw socket/packet communication, file tailing and several message bus clients. Once an input plugin has collected data it can be processed by any number of filters which modify and annotate the event data. Finally, events are routed to output plugins which can forward the events to a variety of external programs including Elasticsearch, local files and several message bus implementations.

For more information about Logstash, please visit [www.elastic.co/products/logstash](https://www.elastic.co/products/logstash).

# Supported tags and respective Dockerfile links
The tag of each logstash docker image is consist of the version of logstash and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[8.17.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/logstash/8.17.3/24.03-lts-sp1/Dockerfile)| Logstash 8.17.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Start a logstash instance by following command:
```bash
docker run -it \
    --name logstash \
    -p 9600:9600 \
    -p 5044:5044 \
    openeuler/logstash:latest
```

The following message indicates that the logstash is ready :
```
Starting server on port: 5044

```
To get an interactive shell
```bash
docker exec -it logstash /bin/bash
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).