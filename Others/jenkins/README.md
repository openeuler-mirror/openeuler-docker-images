# Quick reference

- The official Jenkins docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Jenkins | openEuler
Current Jenkins docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.

Learn more about Jenkins on [Jenkins documentation](https://www.jenkins.io/doc/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `jenkins` docker image is consist of the version of `jenkins` and the version of basic image. The details are as follows

| Tag                                                                                                                              | Currently                                | Architectures |
|----------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|---------------|
| [2.502-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/jenkins/2.502/24.03-lts-sp1/Dockerfile) | Jenkins 2.502 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Add jenkins dependency

  Maven: Add the following dependency to your `pom.xml`.
  ```
  <dependency>
      <groupId>org.jenkins-ci</groupId>
      <artifactId>jenkins</artifactId>
      <version>${jenkins.version}</version>
  </dependency>
  ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).