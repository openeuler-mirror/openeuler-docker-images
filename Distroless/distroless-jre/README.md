# Quick reference

- The official distroless-jre docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# distroless-jre | openEuler
The Distroless JRE image is a minimal Java runtime environment designed to run Java applications in a secure and lightweight containerized environment.
It includes only what is necessary for executing Java programs and does not contain development tools such as `javac`.

Contents:
* Java Virtual Machine(JVM)
* Core Java Class Libraries
* Minimal System Dependencies

# Supported tags and respective Dockerfile links
The tag of each `distroless-jre` docker image is consist of the version of `OpenJDK` and version of openEuler. The details are as follows

| Tag                                                                                                                                             | Currently                                | Architectures |
|-------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|---------------|
| [21.0.2.12-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-jre/21.0.2.12/24.03-lts/Distrofile) | OpenJDK 21.0.2.12 on openEuler 24.03-LTS | amd64, arm64  |

# Usage
1. Starts from the full openEuler image with a JDK installed and compiles the java source file into bytecode. 
2. Copies the compiled `.class` file from the build stage and ets `JAVA_HOME` and adds the JVM `bin` directory to `PATH` for easy execution.
3. For [example](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-jre/example)

```
FROM openeuler/openeuler:latest AS build-env
COPY . /app
WORKDIR /app
RUN yum install -y java-21-openjdk-devel
RUN javac Hello.java

FROM openeuler/distroless-jre:21.0.2.12-oe2403lts
COPY --from=build-env /app /app
WORKDIR /app
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-21.0.2.12-2.oe2403.aarch64
ENV PATH=$JAVA_HOME/bin:$PATH
CMD ["java", "Hello"]
```
# Run Applications as a Non-Root User
For implementation details, refer to the [distroless-base-nonroot documentation](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-base-nonroot/README.md).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).