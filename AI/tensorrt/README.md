# Quick reference

- The official TensorRT docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# TensorRT | openEuler
Current TensorRT docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

NVIDIA® TensorRT™ is an SDK for high-performance deep learning inference on NVIDIA GPUs. This repository contains the open source components of TensorRT.

It includes the sources for TensorRT plugins and ONNX parser, as well as sample applications demonstrating usage and capabilities of the TensorRT platform. These open source software components are a subset of the TensorRT General Availability (GA) release with some extensions and bug-fixes.

Learn more on [NVIDIA TensorRT](https://developer.nvidia.com/tensorrt).

# Supported tags and respective Dockerfile links
The tag of each tensorrt docker image is consist of the version of tensorrt and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[10.16-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/tensorrt/10.16/24.03-lts-sp3/Dockerfile) | TensorRT 10.16 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/tensorrt` image from docker

	```bash
	docker pull openeuler/tensorrt:{Tag}
	```

- Start a TensorRT interactive container

	```bash
	docker run -it --gpus all openeuler/tensorrt:{Tag} /bin/bash
	```

- Use `trtexec` to build an optimized engine from an ONNX model

	```bash
	trtexec --onnx=model.onnx --saveEngine=model.engine
	```

- Use TensorRT Python API

	```python
	import tensorrt as trt
	logger = trt.Logger(trt.Logger.WARNING)
	builder = trt.Builder(logger)
	```

- To get an interactive shell

	```bash
	docker exec -it my-tensorrt /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
