# Quick reference

- The official faiss docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# Faiss | openEuler
Faiss is a library for efficient similarity search and clustering of dense vectors. It contains algorithms that search in sets of vectors of any size, up to ones that possibly do not fit in RAM. It also contains supporting code for evaluation and parameter tuning. Faiss is written in C++ with complete wrappers for Python/numpy. Some of the most useful algorithms are implemented on the GPU. It is developed primarily at Meta's Fundamental AI Research group.

Learn more on [Faiss Documentation](https://faiss.ai/).

# Supported tags and respective Dockerfile links
The tag of each faiss docker image is consist of the version of faiss and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.14.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/faiss/1.14.1/24.03-lts-sp3/Dockerfile) | faiss 1.14.1 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/faiss` image from docker

	```bash
	docker pull openeuler/faiss:{Tag}
	```

- Start a faiss container

	```bash
	docker run -it --name my-faiss openeuler/faiss:{Tag}
	```

- Container startup options

	| Option | Description |
	|--|--|
	| `--name my-faiss` | Names the container `my-faiss`. |
	| `-it` | Starts the container in interactive mode with a terminal (bash). |
	| `openeuler/faiss:{Tag}` | Specifies the Docker image to run, replace `{Tag}` with the specific version or tag of the `openeuler/faiss` image you want to use. |

- Verify faiss installation

	```bash
	docker run --rm openeuler/faiss:{Tag} -c "import faiss; print(faiss.__version__)"
	```

- To get an interactive shell

	```bash
	docker exec -it my-faiss /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
