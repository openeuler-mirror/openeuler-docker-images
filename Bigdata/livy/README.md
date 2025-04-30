# Quick reference

- The official Livy docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Livy | openEuler
Current Livy docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Livy is the blazing-fast, scalable SQL query engine for modern data analytics.

Learn more on [Livy website](https://livydb.io).

# Supported tags and respective Dockerfile links
The tag of each livy docker image is consist of the version of livy and the version of basic image. The details are as follows

| Tags                                                                                                                           | Currently                               |  Architectures|
|--------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------|--|
| [0.8.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/livy/0.8.0/24.03-lts-sp1/Dockerfile) | Livy 0.8.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Pull the `openeuler/livy` image from docker

	```bash
	docker pull openeuler/livy:{Tag}
	```

- Run the container in the background

	```
	docker run -d -p 8998:8998 -v /path/to/livy.conf:/opt/livy/conf/livy.conf --name livy openeuler/livy:{Tag}
	```
   Options description:
   - -p, Specifies the port number (must match `livy.server.port` in `livy.conf`)
   - -v, Specifies the Livy configuration file `livy.conf` 


- Test Submitting a Spark Job

    Try submitting a simple Spark job (e.g., PySpark or Scala code) through Livy to verify full functionality. For example:
    ```
    curl -X POST \
    -H "Content-Type: application/json" \
    -d '{"kind": "spark"}' \
    http://localhost:8998/sessions
    ```
    If a session ID (e.g., {"id":0,...}) is returned, it indicates successful integration between Livy and Spark.


- Check Session Status

    Run the following command to check the real-time status of session 0:
    ```
    curl http://localhost:8998/sessions/0
    ```
    If the response shows "state": "idle", the Spark session is ready for code submission. If it returns "error", check the logs for troubleshooting.


- Start using Livy

    Once the Livy server is running, you can connect to it on port 8998 (this can be changed with the `livy.server.port` config option). 
    Some examples to get started are provided [here](https://livy.incubator.apache.org/examples/), or you can check out the API documentation:
	- [REST API](https://livy.incubator.apache.org/docs/latest/rest-api.html)
	- [Programmatic API](https://livy.incubator.apache.org/docs/latest/programmatic-api.html)
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).