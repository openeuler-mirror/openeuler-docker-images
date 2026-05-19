# Quick reference

- The official torchvision docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# torchvision | openEuler
The torchvision package consists of popular datasets, model architectures, and common image transformations for computer vision.


# Supported tags and respective Dockerfile links
The tag of each torchvision docker image is consist of the version of torchvision and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.27.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/torchvision/0.27.0/24.03-lts-sp3/Dockerfile) | torchvision 0.27.0 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
- Pull the `openeuler/torchvision` image from docker

    ```bash
    docker pull openeuler/torchvision:0.27.0-oe2403sp3
    ```

- Start a container and run Python

    ```bash
    docker run -it openeuler/torchvision:0.27.0-oe2403sp3 python3
    ```

- Use torchvision in Python

    ```python
    import torch
    import torchvision

    print(torch.__version__)
    print(torchvision.__version__)
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).