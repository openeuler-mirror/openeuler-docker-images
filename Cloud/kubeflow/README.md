# Quick reference

- The official Kubeflow docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Kubeflow | openEuler
Current Kubeflow images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Kubeflow is an open-source machine learning platform built on Kubernetes, providing end-to-end workflow management for AI/ML workloads. It is a CNCF graduated project that offers a comprehensive ecosystem including Notebook management, model training, hyperparameter tuning, model serving, and inference. This image includes the core `notebook-controller` and `profile-controller` components from the kubeflow/kubeflow repository.

Read more on [Kubeflow Website](https://www.kubeflow.org/).

# Supported tags and respective dockerfile links
The tag of each `kubeflow` docker image is consist of the version of `kubeflow` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
| [1.10.0-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/kubeflow/1.10.0/24.03-lts-sp4/Dockerfile) | Kubeflow 1.10.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
| [1.10.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/kubeflow/1.10.0/24.03-lts-sp3/Dockerfile) | Kubeflow 1.10.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/kubeflow` image from docker

	```
	docker pull openeuler/kubeflow:{Tag}
	```

- Start the notebook-controller

    ```
    docker run -it --rm openeuler/kubeflow:{Tag} notebook-controller
    ```

- Start the profile-controller

    ```
    docker run -it --rm openeuler/kubeflow:{Tag} profile-controller
    ```

- Run with an interactive shell

    ```
    docker run -it --rm openeuler/kubeflow:{Tag} bash
    ```
    The `openeuler/kubeflow` image is used to verify the integration between the upstream Kubeflow version and openEuler.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
