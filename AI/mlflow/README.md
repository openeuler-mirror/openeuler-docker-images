# Quick reference

- The official MLflow docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# MLflow | openEuler
Current MLflow docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

MLflow, at its core, provides a suite of tools aimed at simplifying the ML workflow. It is tailored to assist ML practitioners throughout the various stages of ML development and deployment. Despite its expansive offerings, MLflow’s functionalities are rooted in several foundational components:

- [Tracking](https://mlflow.org/docs/latest/tracking.html#tracking): MLflow Tracking provides both an API and UI dedicated to the logging of parameters, code versions, metrics, and artifacts during the ML process. This centralized repository captures details such as parameters, metrics, artifacts, data, and environment configurations, giving teams insight into their models’ evolution over time. Whether working in standalone scripts, notebooks, or other environments, Tracking facilitates the logging of results either to local files or a server, making it easier to compare multiple runs across different users.

- [Model Registry](https://mlflow.org/docs/latest/model-registry.html#registry): A systematic approach to model management, the Model Registry assists in handling different versions of models, discerning their current state, and ensuring smooth productionization. It offers a centralized model store, APIs, and UI to collaboratively manage an MLflow Model’s full lifecycle, including model lineage, versioning, aliasing, tagging, and annotations.

- [MLflow Deployments for LLMs](https://mlflow.org/docs/latest/llms/deployments/index.html#deployments): This server, equipped with a set of standardized APIs, streamlines access to both SaaS and OSS LLM models. It serves as a unified interface, bolstering security through authenticated access, and offers a common set of APIs for prominent LLMs.

- [Evaluate](https://mlflow.org/docs/latest/models.html#model-evaluation): Designed for in-depth model analysis, this set of tools facilitates objective model comparison, be it traditional ML algorithms or cutting-edge LLMs.

- [Prompt Engineering UI](https://mlflow.org/docs/latest/llms/prompt-engineering/index.html#prompt-engineering): A dedicated environment for prompt engineering, this UI-centric component provides a space for prompt experimentation, refinement, evaluation, testing, and deployment.

- [Recipes](https://mlflow.org/docs/latest/recipes.html#recipes): Serving as a guide for structuring ML projects, Recipes, while offering recommendations, are focused on ensuring functional end results optimized for real-world deployment scenarios.

- [Projects](https://mlflow.org/docs/latest/projects.html#projects): MLflow Projects standardize the packaging of ML code, workflows, and artifacts, akin to an executable. Each project, be it a directory with code or a Git repository, employs a descriptor or convention to define its dependencies and execution method.

Learn more on [MLflow website](https://mlflow.org/docs/latest/introduction/index.html).

# Supported tags and respective Dockerfile links
The tag of each mlflow docker image is consist of the version of mlflow and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[3.3.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/3.3.1/24.03-lts-sp1/Dockerfile) | mlflow 3.3.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |
|[2.11.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.11.1/22.03-lts-sp3/Dockerfile)| MLflow 2.11.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.13.1-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.13.1/22.03-lts-sp1/Dockerfile)| MLflow 2.13.1 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[2.13.1-oe2203sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.13.1/22.03-lts-sp2/Dockerfile)| MLflow 2.13.1 on openEuler 22.03-LTS-SP2 | amd64, arm64 |
|[2.13.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.13.1/22.03-lts-sp3/Dockerfile)| MLflow 2.13.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.13.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.13.1/24.03-lts/Dockerfile)| MLflow 2.13.1 on openEuler 24.03-LTS | amd64, arm64 |
|[2.16.2-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.16.2/22.03-lts-sp3/Dockerfile)| MLflow 2.16.2 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.17.0rc0-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.17.0rc0/22.03-lts-sp3/Dockerfile)| MLflow 2.17.0rc0 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.17.1-oe2003sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.17.1/20.03-lts-sp4/Dockerfile)| MLflow 2.17.1 on openEuler 20.03-LTS-SP4 | amd64, arm64 |
|[2.17.1-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.17.1/22.03-lts-sp1/Dockerfile)| MLflow 2.17.1 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[2.17.1-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.17.1/22.03-lts-sp3/Dockerfile)| MLflow 2.17.1 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.17.1-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.17.1/22.03-lts-sp4/Dockerfile)| MLflow 2.17.1 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[2.17.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.17.1/24.03-lts/Dockerfile)| MLflow 2.17.1 on openEuler 24.03-LTS | amd64, arm64 |
|[2.17.2-oe2203sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.17.2/22.03-lts-sp1/Dockerfile)| MLflow 2.17.2 on openEuler 22.03-LTS-SP1 | amd64, arm64 |
|[2.17.2-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.17.2/22.03-lts-sp3/Dockerfile)| MLflow 2.17.2 on openEuler 22.03-LTS-SP3 | amd64, arm64 |
|[2.17.2-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.17.2/22.03-lts-sp4/Dockerfile)| MLflow 2.17.2 on openEuler 22.03-LTS-SP4 | amd64, arm64 |
|[2.17.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/mlflow/2.17.2/24.03-lts/Dockerfile)| MLflow 2.17.2 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Pull the `openeuler/mlflow` image from docker

	```bash
	docker pull openeuler/mlflow:{Tag}
	```
    
- Start a mlflow instance

	```bash
	docker run -d --name my-mlflow -p 5000:5000 openeuler/mlflow:{Tag}
	```
	After the instance `my-mlflow` is started, access the mlflow service through `http://localhost:5000`.

- View container running logs

	```bash
	docker logs -f my-mlflow
	```
	
- To get an interactive shell

	```bash
	docker exec -it my-mlflow /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).