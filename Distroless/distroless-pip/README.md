# Quick reference

- The official distroless-pip docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# distroless-pip | openEuler
This image contains a minimal Linux, pip runtime.

PIP is the package installer for Python. You can use it to install packages from the Python Package Index and other indexes.

# Supported tags and respective Dockerfile links
The tag details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[23.3.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-pip/23.3.1/24.03-lts/Distrofile)| PIP 23.3.1 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
**Create a Dockerfile in your python project**
```
# Dockerfile

FROM openeuler/distroless-pip:23.3.1-oe2403lts
# Need to refresh the CA certificates
RUN update-ca-trust
# example 1
RUN pip install numpy
# example 2
RUN pip install -r requirements.txt
```

# Run Applications as a Non-Root User
For implementation details, refer to the [distroless-base-nonroot documentation](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-base-nonroot/README.md).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).