# Quick reference

- The official GlassFish docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# GlassFish | openEuler
Current GlassFish docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Eclipse GlassFish is a Jakarta EE compatible implementation sponsored by the Eclipse Foundation.

Learn more about GlassFish on [GlassFish Documentation](https://glassfish.org/documentation.html)⁠.

# Supported tags and respective Dockerfile links
The tag of each `glassfish` docker image is consist of the version of `glassfish` and the version of basic image. The details are as follows

| Tag                                                                                                                                  | Currently                                   | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|---------------|
| [7.0.23-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/glassfish/7.0.23/24.03-lts-sp1/Dockerfile) | GlassFish 7.0.23 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/glassfish` image from docker

	```bash
	docker pull openeuler/glassfish:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use glassfish.
    ```
    docker run -it --rm openeuler/glassfish:{Tag} bash
    ```
  
- Start the GlassFish Server
  
    To start the Eclipse GlassFish server, run the following command:
    ```
    /glassfish/appserver/distributions/web/target/stage/glassfish7/bin/asadmin start-domai
    ```
    Once the server is running, you can access the `Admin Console` at: ` http://localhost:4848`.

- Stop the GlassFish Server
    
    To safely shut down the server, run:
    ```   
    /glassfish/appserver/distributions/web/target/stage/glassfish7/bin/asadmin stop-domain
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).