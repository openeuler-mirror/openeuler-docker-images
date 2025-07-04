# Quick reference

- The official Envoy docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Envoy | openEuler
Current Envoy images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Envoy is hosted by the Cloud Native Computing Foundation (CNCF). If you are a company that wants to help shape the evolution of technologies that are container-packaged, dynamically-scheduled and microservices-oriented, consider joining the CNCF. For details about who's involved and how Envoy plays a role.

Read more on [CNCF announcemen](https://www.cncf.io/blog/2017/09/13/cncf-hosts-envoy/).

# Supported tags and respective dockerfile links
The tag of each `envoy` docker image is consist of the version of `envoy` and the version of basic image. The details are as follows

| Tag                                                                                                                             | Currently                               | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------|---------------|
| [1.34.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Cloud/envoy/1.34.1/24.03-lts-sp1/Dockerfile) | Envoy 1.34.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/envoy` image from docker

	```
	docker pull openeuler/envoy:{Tag}
	```

- Run with an interactive shell

    You can start the container with an interactive shell to use envoy.
    ```
    docker run -it --rm openeuler/envoy:{Tag} bash
    ```
  
- Envoy Proxy - Basic Usage Guide
   
    **Configuration File (envoy.yaml)**
    Refer to the  [demonstration configuration file](https://github.com/envoyproxy/envoy/blob/main/configs/envoy-demo.yaml) in the Envoy codebase for a working example.
    ```
    static_resources:
      listeners:
      - name: listener_0
        address:
          socket_address:
            address: 0.0.0.0
            port_value: 10000
        filter_chains:
        - filters:
          - name: envoy.filters.network.http_connection_manager
            typed_config:
              "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
              stat_prefix: ingress_http
              route_config:
                name: local_route
                virtual_hosts:
                - name: backend
                  domains: ["*"]
                  routes:
                  - match:
                      prefix: "/"
                    route:
                      cluster: some_service
              http_filters:
              - name: envoy.filters.http.router
                typed_config:
                  "@type": type.googleapis.com/envoy.extensions.filters.http.router.v3.Router
    
      clusters:
      - name: some_service
        connect_timeout: 0.25s
        type: LOGICAL_DNS
        lb_policy: ROUND_ROBIN
        load_assignment:
          cluster_name: some_service
          endpoints:
          - lb_endpoints:
            - endpoint:
              address:
                socket_address:
                  address: 127.0.0.1
                  port_value: 8080
    ```
  
    **Command Syntax**
    ```
    ./envoy -c ./envoy.yaml [options]
    ```
    This command launches the Envoy proxy with the specified configuration file.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).