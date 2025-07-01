# Quick reference

- The official knox docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# knox | openEuler
Current knox docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

The Knox API Gateway is designed as a reverse proxy with consideration for pluggability in the areas of policy enforcement, through providers and the backend services for which it proxies requests.

Learn more on [knox website](http://knox.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each knox docker image is consist of the version of knox and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.0.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/knox/2.0.0/24.03-lts-sp1/Dockerfile)| Apache knox 2.0.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Start a knox instance by following command:
```bash
docker run -it --name knox openeuler/knox:latest
```

The following message indicates that the knox is ready :
```
Starting Gateway succeeded with PID xxx.

```

Users can use `--entrypoint` to change the entrypoint. To get an interactive shell
```bash
docker exec -it knox /bin/bash
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).