# Quick reference

- The official Kyuubi docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Kyuubi | openEuler
Current Kyuubi docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Kyuubi is a distributed and multi-tenant gateway to provide serverless SQL on data warehouses and lakehouses.

Learn more on [Kyuubi website](https://kyuubi.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each kyuubi docker image is consist of the version of kyuubi and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.10.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kyuubi/1.10.0/24.03-lts-sp1/Dockerfile)| kyuubi 1.10.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[1.10.2-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/kyuubi/1.10.2/24.03-lts-sp2/Dockerfile)| kyuubi 1.10.2 on openEuler 24.03-LTS-SP2 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Pull the `openeuler/kyuubi` image from docker

	```bash
	docker pull openeuler/kyuubi:{Tag}
	```

- Run the container in the background

	If container runs successfully, it will store the PID of the server instance into pid/kyuubi-<username>-org.apache.kyuubi.server.KyuubiServer.pid. 
	And you are able to get the JDBC connection URL from the log file - logs/kyuubi-<username>-org.apache.kyuubi.server.KyuubiServer-<hostname>.out.

	```
	docker run -d -p 10009:10009 --name kyuubi openeuler/kyuubi:{Tag}
	```

- Enter the container

    Enter the container and view the log file mentioned above.
    ```
    docker exec -it kyuubi bash
    ```
 
    For example
    ```
    Starting and exposing JDBC connection at: jdbc:kyuubi://localhost:10009/
    ```


- Open Connections

	Replace the host and port with the actual ones you’ve got in the step of server startup for the following JDBC URL. The case below open a session for user named apache.
	```bash
	bin/kyuubi-beeline -u 'jdbc:kyuubi://localhost:10009/' -n apache
	```

- Execute Statements

	After successfully connected with the server, you can run sql queries in the kyuubi-beeline console. For instance,
	```
	> SHOW DATABASES;
	```
 	You will see a wall of operation logs, and a result table in the kyuubi-beeline console.
	```bash
	omitted logs
	+------------+
	| namespace  |
	+------------+
	| default    |
	+------------+
	1 row selected (0.2 seconds)
	```

- Start Engines

	Engines are launched by the server automatically without end users’ attention.
	If you use the same user in the above case to create another connection, the engine will be reused. You may notice that the time cost for connection here is much shorter than the last round.
	If you use a different user to create a new connection, another engine will be started.
	```
	bin/kyuubi-beeline -u 'jdbc:kyuubi://localhost:10009/' -n kentyao
	```

- Close Connections

    Close the session between kyuubi-beeline and Kyuubi server by executing !quit, for example,
	```
	> !quit
	Closing: 0: jdbc:kyuubi://localhost:10009/
	```

- Stop Kyuubi

	Stop Kyuubi which running at the background by performing the following in the $KYUUBI_HOME directory:
	```
	bin/kyuubi stop
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).