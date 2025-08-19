# Quick reference

- The official ONNX Runtime docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# ONNX Runtime | openEuler
Current ONNX Runtime docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

ONNX Runtime is a cross-platform inference and training machine-learning accelerator.
ONNX Runtime inference can enable faster customer experiences and lower costs, supporting models from deep learning frameworks such as PyTorch and TensorFlow/Keras as well as classical machine learning libraries such as scikit-learn, LightGBM, XGBoost, etc. 
ONNX Runtime is compatible with different hardware, drivers, and operating systems, and provides optimal performance by leveraging hardware accelerators where applicable alongside graph optimizations and transforms.

Learn more about on [ONNX Runtime Website](https://www.onnxruntime.ai/).

# Supported tags and respective Dockerfile links
The tag of each `ONNX Runtime` docker image is consist of the complete software stack version. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.22.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/onnxruntime/1.22.1/24.03-lts-sp2/Dockerfile)| ONNX Runtime 1.22.1 on openEuler 24.03-LTS-SP2 | amd64, arm64 |

# Usage
1. Ensure that you have Docker installed, or are using Docker for Linux containers if on Windows.

2. Obtain the ONNX Runtime docker image. There are two ways to do this:

- Pull the pre-built Docker image from DockerHub
  - ```docker pull openeuler/onnxruntime```

- Clone the [source repository](https://gitee.com/openeuler/openeuler-docker-images)⁠. Navigate to the `AI/onnxruntime` folder and build the image locally with the following command.
  -  ```docker build . -t openeuler/onnxruntime```

3. Run the Docker container to launch the ONNX Runtime developer image.

- ```docker run -it openeuler/onnxruntime```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).
