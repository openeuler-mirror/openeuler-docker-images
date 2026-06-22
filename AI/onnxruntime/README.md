# Quick reference

- The official ONNX Runtime docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# ONNX Runtime | openEuler
ONNX Runtime is a cross-platform inference and training machine-learning accelerator.
ONNX Runtime inference can enable faster customer experiences and lower costs, supporting models from deep learning frameworks such as PyTorch and TensorFlow/Keras as well as classical machine learning libraries such as scikit-learn, LightGBM, XGBoost, etc. 
ONNX Runtime is compatible with different hardware, drivers, and operating systems, and provides optimal performance by leveraging hardware accelerators where applicable alongside graph optimizations and transforms.

Learn more about on [ONNX Runtime Website](https://www.onnxruntime.ai/).

# Supported tags and respective Dockerfile links
The tag of each `ONNX Runtime` docker image is consist of the complete software stack version. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.22.1-oe2403sp2](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/onnxruntime/1.22.1/24.03-lts-sp2/Dockerfile)| ONNX Runtime 1.22.1 on openEuler 24.03-LTS-SP2 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` and container startup options based on their requirements.

- Pull the `openeuler/onnxruntime` image from docker

	```bash
	docker pull openeuler/onnxruntime:{Tag}
	```

- Start a container

	```bash
	docker run -it --name my-onnxruntime openeuler/onnxruntime:{Tag}
	```

- Container startup options

	| Option | Description |
	|--|--|
	| `--name my-onnxruntime` | Names the container `my-onnxruntime`. |
	| `-it` | Starts the container in interactive mode with a terminal. |
	| `openeuler/onnxruntime:{Tag}` | Specifies the Docker image to run, replace `{Tag}` with the specific version tag. |

- Verify ONNX Runtime installation

	```bash
	docker run --rm openeuler/onnxruntime:{Tag} python3 -c "import onnxruntime; print(onnxruntime.__version__)"
	```

- To get an interactive shell

	```bash
	docker exec -it my-onnxruntime /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
