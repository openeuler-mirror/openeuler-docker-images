# Quick reference

- The official Apache Traffic Server docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Apache Traffic Server | openEuler
Current Apache Traffic Server docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Traffic Server is a high-performance building block for cloud services. It's more than just a caching proxy server; it also has support for plugins to build large scale web applications.

Learn more on [Apache Traffic Server Website](https://docs.trafficserver.apache.org/en/latest/index.html)⁠.

# Supported tags and respective Dockerfile links
The tag of each `traffic-server` docker image is consist of the version of `traffic-server` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[10.0.5-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/traffic-server/10.0.5/24.03-lts-sp1/Dockerfile)| Apache Traffic Server 10.0.5 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
This guide shows how to run the `Apcache Traffic Server(ATS)` as a simple local proxy in a single-node setup, forwarding traffic to a Nginx container running on the same host.

- Pull the `openeuler/traffic-server` image from docker‘

    You can select the corresponding `{Tag}` based your need.
	```bash
	docker pull openeuler/traffic-server:{Tag}
	```

- Run a backend Nginx container

    Start a Nginx container listening on port `8080`:
    ```
    docker run -d --name nginx -p 8080:8080 openeuler/nginx:latest
    ```

- Configuration the forwarding rule
    
    Edit the default [remap.config](https://github.com/apache/trafficserver/blob/10.0.5/configs/remap.config.default). Add the following line:.
    ```
    # remap.config
    map http://localhost/ http://127.0.0.1:8080/
    ```
    
    **Notes:**
    * This tells ATS to forward requests for `http://localhost/` to the Nginx backend running on `127.0.0.1:8080`.
    * Make sure the port `8080` matches the port you exposed for your Nginx container.
    * You can adjust the backend address in `remap.config` according to your actual backend service.

- Run the Traffic Server container

    Start the Traffic Server container and mount your `remap.config` to overwrite the default inside the container:
    ```
    docker run -d \
      --name traffic-server \
      -p 8081:8080 \
      -v $(pwd)/remap.config:/usr/local/trafficserver/etc/trafficserver/remap.config \
      my-traffic-server-image
    ```
    **Optional:**
    * If you need to customize Traffic Server's default behavior, you can modify the [default records.yaml](https://github.com/apache/trafficserver/blob/10.0.5/configs/records.yaml.default.in) and mount it in the same way:
      ```
      -v $(pwd)/records.yaml:/usr/local/trafficserver/etc/trafficserver/records.yaml
      ```
    * This will overwrite the default config inside the container with your customized version.
    
    **Tip:**
    * The container's internal port is defined by `proxy.config.http.server_port` in `records.yaml`(default is usually `8080`).
    * The `-p 8081:8080` maps your host port `8081` to Traffic Server's internal `8080` port.
    
- Verify the forwarding

    Test the forwarding by sending a request to your Traffic Server container:
    ```
    curl -v -H "Host: localhost" http://127.0.0.1:8081/
    ```
    You should see the response coming from the backend Nginx server through Traffic Server.
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).