# Quick reference

- The official elasticsearch docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# Elasticsearch | openEuler
Current elasticsearch docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Elasticsearch is a distributed search and analytics engine, scalable data store and vector database optimized for speed and relevance on production-scale workloads. Elasticsearch is the foundation of Elastic’s open Stack platform. Search in near real-time over massive datasets, perform vector searches, integrate with generative AI applications, and much more.

Learn more on [elasticsearch website](https://www.elastic.co/products/elasticsearch).

# Supported tags and respective Dockerfile links
The tag of each elasticsearch docker image is consist of the version of elasticsearch and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[9.1.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/elasticsearch/9.1.3/24.03-lts-sp1/Dockerfile) | elasticsearch 9.1.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[8.17.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/elasticsearch/8.17.3/24.03-lts-sp1/Dockerfile)| Elasticsearch 8.17.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Start a elasticsearch instance by following command:
```bash
docker run -d --name elasticsearch --net {somenetwork} -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" openeuler/elasticsearch:latest
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).