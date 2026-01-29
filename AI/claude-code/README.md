# Quick reference

- The official Claude-Code docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Supported tags and respective Dockerfile links
The tag of each `claude-code` docker image is consist of the complete software stack version. The details are as follows
|    Tag   |  Currently  |     |
|----------|-------------|------------------|
|[2.1.20-oe2403ltssp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/claude-code/2.1.20/24.03-lts-sp3/Dockerfile)| Claude-Code:latest on openEuler 24.03-LTS-SP3 |

# Recommend local models
* gpt-oss:20b
* qwen3-coder:latest


# Quick Start
In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/claude-code` image from docker
```bash
docker pull openeuler/claude-code:{Tag}
```

- Launch an interactive container
```bash
docker run -it --name my-claude openeuler/claude-code:{Tag} 
```

| Option | Description |
|--|--|
| `--name my-claude` | Names the container `my-claude`. |
| `-it` | Starts the container in interactive mode with a terminal (bash). |
| `openeuler/claude-code:{Tag}` | Specifies the Docker image to run, replace `{Tag}` with the specific version or tag of the `openeuler/claude-code` image you want to use. |

- Run Claude Code with **qwen3-coder:latest** 

```bash
ollama pull qwen3-coder:latest
claude --model qwen3-coder:latest
```

- Invoke Claude with **gpt-oss:20b** 

```bash
ollama pull gpt-oss:20b
claude --model gpt-oss:20b
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).