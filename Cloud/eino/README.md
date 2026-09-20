# Quick reference

- The official Eino docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Eino | openEuler
Current Eino docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

**Eino['aino]** is an LLM application development framework in Golang. It draws from LangChain, Google ADK, and other open-source frameworks, and is designed to follow Golang conventions. This image bundles the Go toolchain together with the Eino framework source code, so that Eino applications can be built and run inside the container.

Eino provides:
- **Components**: reusable building blocks like `ChatModel`, `Tool`, `Retriever`, and `ChatTemplate`, with official implementations for OpenAI, Ollama, and more.
- **Agent Development Kit (ADK)**: build AI agents with tool use, multi-agent coordination, context management, interrupt/resume for human-in-the-loop, and ready-to-use agent patterns.
- **Composition**: connect components into graphs and workflows that can run standalone or be exposed as tools for agents.
- **Examples**: working code for common patterns and real-world use cases.

Read more on [CloudWeGo](https://www.cloudwego.io/).

# Supported tags and respective Dockerfile links
The tag of each `eino` docker image is consist of the version of `eino` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[0.10.0-alpha.34-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Cloud/eino/0.10.0-alpha.34/24.03-lts-sp4/Dockerfile) | Eino 0.10.0-alpha.34 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/eino` image from docker

	```
	docker pull openeuler/eino:{Tag}
	```

- Start an Eino development container

	```bash
	docker run -dit --name my-eino -v $(pwd):/workspace -w /workspace openeuler/eino:{Tag} bash
	```

- Build and run an Eino application

	```bash
	docker exec -it my-eino go run .
	```

- View container running logs

	```bash
	docker logs -f my-eino
	```

- To get an interactive shell

	```bash
	docker exec -it my-eino /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
