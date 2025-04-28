# Quick reference

- The official Tempo docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Tempo | openEuler
Current Tempo docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Grafana Tempo is an open source, easy-to-use and high-scale distributed tracing backend. Tempo is cost-efficient, requiring only object storage to operate, and is deeply integrated with Grafana, Prometheus, and Loki.

Learn more on [Tempo website](https://grafana.com/oss/tempo/).

# Supported tags and respective Dockerfile links
The tag of each `tempo` docker image is consist of the version of `tempo` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[2.5.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/tempo/2.5.0/24.03-lts/Dockerfile)| Grafana Tempo 2.5.0 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/tempo` image from docker

	```bash
	docker pull openeuler/tempo:{Tag}
	```

- Start a tempo instance

	```bash
	docker run -d \
      --name my-tempo \
      -p 3200:3200 -p 14268:14268 -p 9095:9095 -p 4317:4317 -p 4318:4318 -p 9411:9411 \
      openeuler/tempo:{Tag}
	```
	When the instance `my-tempo` is started, access the Tempo API through `http://localhost:3200`.

- Container startup options

	| Option | Description |
	|--------|-------------|
	| -p 3200:3200 | Tempo HTTP API port |
    | -p 9095:9095 | Tempo GRPC API port |
    | -p 14268:14268 | Jaeger thrift format ingestion port |
    | -p 4317:4317	 | OpenTelemetry GRPC ingestion port   |  
    | -p 4318:4318	 | OpenTelemetry HTTP ingestion port |
    | -p 9411:9411	 | Zipkin format ingestion port      |
    | -v /path/to/tempo/config.yml:/etc/tempo/config.yml | start tempo with customed configuration file |

- Check logs

	```bash
	docker logs -f my-tempo
	```

- To get an interactive shell

	```bash
	docker exec -it my-tempo /bin/bash
	```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).