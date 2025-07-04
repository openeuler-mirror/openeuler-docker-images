# Quick reference

- The official PyTorch docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# PyTorch | openEuler
Current ONNX docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Open Neural Network Exchange (ONNX) is an open ecosystem that empowers AI developers to choose the right tools as their project evolves. ONNX provides an open source format for AI models, both deep learning and traditional ML. It defines an extensible computation graph model, as well as definitions of built-in operators and standard data types. Currently we focus on the capabilities needed for inferencing (scoring).

Learn more about on [ONNX Website](https://onnx.ai/).

# Supported tags and respective Dockerfile links
The tag of each `ONNX` docker image is consist of the complete software stack version. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.18.0-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/onnx/1.18.0/24.03-lts/Dockerfile)| ONNX 1.18.0 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.

2. Obtain the ONNX ecosystem docker image. There are two ways to do this:

- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/onnx```

- Clone the [source repository](https://gitee.com/openeuler/openeuler-docker-images)⁠. Navigate to the `AI/onnx` folder and build the image locally with the following command.
  -  ```docker build . -t openeuler/onnx```

3. Run the Docker container to launch the ONNX developer image.

- ```docker run -it openeuler/onnx```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
