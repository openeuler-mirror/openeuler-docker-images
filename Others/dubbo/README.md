# Quick reference

- The official Dubbo docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Dotnet Runtime (.NET Runtime) | openEuler
Current Dubbo docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Apache Dubbo is an RPC service development framework designed to address service governance and communication issues in microservice architectures. 
The official implementation provides multi-language SDKs such as Java and Golang. Microservices developed using Dubbo inherently possess the ability to discover and communicate with each other remotely. 
By leveraging Dubbo’s rich service governance features, you can achieve service discovery, load balancing, traffic scheduling, and other service governance requirements. 
Dubbo is designed to be highly extensible, allowing users to easily implement various custom logics for traffic interception and routing.

Learn more about Dubbo on [Dubbo Website](https://cn.dubbo.apache.org/en/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `dubbo` docker image is consist of the version of `dubbo` and the version of basic image. The details are as follows

| Tag                                                                                                                            | Currently                              | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [3.3.4-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dubbo/3.3.4/24.03-lts-sp1/Dockerfile) | Dubbo 3.3.4 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [3.3.5-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/dubbo/3.3.5/24.03-lts-sp2/Dockerfile) | Dubbo 3.3.5 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/dubbo` image from docker

	```bash
	docker pull openeuler/dubbo:{Tag}
	```

- Start a dubbo instance
    Because the registration center is enabled in the configuration file, the Nacos server was started locally for the duboo application to run properly.
    ```bash
    docker run -d -p 50051:50051 --name my-dubbo openeuler/dubbo:{Tag}
    ```
    
- Verify instance status

    You can send an HTTP request to the dubbo application using curl, and if it started successfully you will receive a "Hello Dubbo" reply.
    ```bash
	 curl \
  		--header "Content-Type: application/json" \
  		--data '["Dubbo"]' \
  		http://localhost:50051/org.apache.dubbo.samples.quickstart.dubbo.api.DemoService/sayHello/
    ```
    
- View container running logs

	```bash
	docker logs -f my-dubbo
	```

- To get an interactive shell

	```bash
	docker run -it --entrypoint /bin/bash --name my-dubbo openeuler/dubbo:{Tag}
	```
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).