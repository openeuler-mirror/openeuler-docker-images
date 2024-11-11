# Quick reference

- The official Spark docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Spark | openEuler
Current Spark docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Spark is a multi-language engine for executing data engineering, data science, and machine learning on single-node machines or clusters. It provides high-level APIs in Scala, Java, Python, and R, and an optimized engine that supports general computation graphs for data analysis. It also supports a rich set of higher-level tools including Spark SQL for SQL and DataFrames, pandas API on Spark for pandas workloads, MLlib for machine learning, GraphX for graph processing, and Structured Streaming for stream processing.

Learn more on [Spark website](https://spark.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each spark docker image is consist of the version of spark and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3.3.1-22.03-lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/spark/3.3.1/22.03-lts/Dockerfile)| spark 3.3.1 on openEuler 22.03-LTS | amd64, arm64 |
|[3.3.2-22.03-lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/spark/3.3.2/22.03-lts/Dockerfile)| spark 3.3.2 on openEuler 22.03-LTS | amd64, arm64 |
|[3.4.0-22.03-lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/spark/3.4.0/22.03-lts/Dockerfile)| spark 3.4.0 on openEuler 22.03-LTS | amd64, arm64 |
|[3.5.1-24.03-lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/spark/3.5.1/24.03-lts/Dockerfile)| spark 3.5.1 on openEuler 24.03-LTS | amd64, arm64 |
|[3.5.3-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/spark/3.5.3/20.03-lts-sp4/Dockerfile)| spark 3.5.3 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[3.5.3-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/spark/3.5.3/22.03-lts-sp1/Dockerfile)| spark 3.5.3 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[3.5.3-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/spark/3.5.3/22.03-lts-sp3/Dockerfile)| spark 3.5.3 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[3.5.3-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/spark/3.5.3/22.03-lts-sp4/Dockerfile)| spark 3.5.3 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[3.5.3-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/spark/3.5.3/24.03-lts/Dockerfile)| spark 3.5.3 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Online Documentation

	You can find the latest Spark documentation, including a programming guide, on the [project web page](https://spark.apache.org/documentation.html). This README file only contains basic setup instructions.

- Pull the `openeuler/spark` image from docker

	```bash
	docker pull openeuler/spark:{Tag}
	```

- Interactive Scala Shell

	The easiest way to start using Spark is through the Scala shell:
	```bash
	docker run -it --name spark openeuler/spark:{Tag} /opt/spark/bin/spark-shell
	```
	Try the following command, which should return 1,000,000,000:
	
	```bash
	scala> spark.range(1000 * 1000 * 1000).count()
	```

- Interactive Python Shell

	The easiest way to start using PySpark is through the Python shell:
	```bash
	docker run -it --name spark openeuler/spark:{Tag} /opt/spark/bin/pyspark
	```
	And run the following command, which should also return 1,000,000,000:

	```bash
	>>> spark.range(1000 * 1000 * 1000).count()
	```

- Running Spark on Kubernetes

    [https://spark.apache.org/docs/latest/running-on-kubernetes.html⁠](https://spark.apache.org/docs/latest/running-on-kubernetes.html).

- Configuration and environment variables

    See more in [https://github.com/apache/spark-docker/blob/master/OVERVIEW.md#environment-variable](https://github.com/apache/spark-docker/blob/master/OVERVIEW.md#environment-variable).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).