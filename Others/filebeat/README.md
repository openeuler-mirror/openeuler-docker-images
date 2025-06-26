# Quick reference

- The official Filebeat docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Filebeat | openEuler
Current Filebeat docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Filebeat is a lightweight shipper for forwarding and centralizing log data. Installed as an agent on your servers, Filebeat monitors the log files or locations that you specify, collects log events, and forwards them either to Elasticsearch or Logstash for indexing.

Learn more about Filebeat on [Filebeat Website](https://www.elastic.co/docs/reference/beats/filebeat/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `filebeat` docker image is consist of the version of `filebeat` and the version of basic image. The details are as follows

|    Tag   | Currently                                 |   Architectures  |
|----------|-------------------------------------------|------------------|
|[9.0.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/filebeat/9.0.1/24.03-lts-sp1/Dockerfile)| Filebeat 9.0.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/filebeat` image from docker

	```bash
	docker pull openeuler/filebeat:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use filebeat.
    ```
    docker run -it --rm openeuler/filebeat:{Tag} bash
    ```
  
- Create the `filebeat.yml` file
  
    Here's a minimal Filebeat test configuration (filebeat.yml) in English for functional testing:
    ```
    filebeat.inputs:
    - type: filestream
        enabled: true
        paths: ["/var/log/log"]

    output.file:
        path: "/tmp/output"
        filename: "logs.json"
    ```
    Learn how to configure Filebeat on [Configure Filebeat](https://www.elastic.co/docs/reference/beats/filebeat/configuring-howto-filebeat).

- Run in Foreground (Debug Mode)

    ```   
    filebeat -e -c filebeat.yml
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).