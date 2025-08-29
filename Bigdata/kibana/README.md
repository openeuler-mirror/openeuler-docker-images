# Quick reference

- The official kibana docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# Kibana | openEuler
Current kibana docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Kibana is your window into the Elastic Stack. Specifically, it's a browser-based analytics and search dashboard for Elasticsearch.

Learn more on [kibana website](https://www.elastic.co/products/kibana).

# Supported tags and respective Dockerfile links
The tag of each `kibana` docker image is consist of the version of Kibana and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[9.1.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kibana/9.1.3/24.03-lts-sp1/Dockerfile) | kibana 9.1.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[8.17.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kibana/8.17.3/24.03-lts-sp1/Dockerfile)| Kibana 8.17.3 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

Create a new Docker network for Elasticsearch and Kibana
```
docker network create elastic
```

Start an Elasticsearch container
```
docker run --name es01 --net elastic -p 9200:9200 -it -m 1GB openeuler/elasticsearch:latest
```
Copy the generated elastic password and enrollment token. These credentials are only shown when you start Elasticsearch for the first time. You can regenerate the credentials using the following commands
```
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
```

Start a kibana instance by following command:
```bash
docker run --name kib01 --net elastic -p 5601:5601 openeuler/kibana:latest
```
When Kibana starts, it outputs a unique generated link to the terminal. To access Kibana, open this link in a web browser.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).