# Quick reference

- The official neo4j docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# neo4j | openEuler
Current neo4j docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Neo4j is the world’s leading Graph Database. It is a high performance graph store with all the features expected of a mature and robust database, like a friendly query language and ACID transactions. The programmer works with a flexible network structure of nodes and relationships rather than static tables — yet enjoys all the benefits of enterprise-quality database. For many applications, Neo4j offers orders of magnitude performance benefits compared to relational DBs.

Learn more about neo4j at [http://neo4j.com/](http://neo4j.com/).

# Supported tags and respective Dockerfile links
The tag of each `neo4j` docker image is consist of the version of `neo4j` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[5.26.7-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/neo4j/5.26.7/24.03-lts-sp1/Dockerfile)| Neo4j 5.26.7 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

- Start server instance
	```bash
	docker run -d --name my-neo4j -p 7474:7474 -p 7687:7687 openeuler/neo4j:latest
	```
	which allows you to access neo4j through your browser at `http://localhost:7474`⁠.

	This binds two ports (7474 and 7687) for HTTP and Bolt access to the Neo4j API. A volume is bound to `/data` to allow the database to be persisted outside the container.

	By default, this requires you to login with neo4j/neo4j and change the password. You can, for development purposes, disable authentication by passing `--env=NEO4J_AUTH=none` to docker run.
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).