# Quick reference

- The official langgraph docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# langgraph | openEuler
LangGraph is a framework for building stateful, multi-actor applications with LLMs, built on top of LangChain. It enables the creation of agent and multi-agent workflows with cyclic computation, persistence, and human-in-the-loop capabilities.


# Supported tags and respective Dockerfile links
The tag of each langgraph docker image is consist of the version of langgraph and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.2.5-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/langgraph/1.2.5/24.03-lts-sp4/Dockerfile) | langgraph 1.2.5 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[1.2.5-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/langgraph/1.2.5/24.03-lts-sp3/Dockerfile) | langgraph 1.2.5 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
```
docker pull openeuler/langgraph:{Tag}
docker run --rm openeuler/langgraph:{Tag} python3 -c "import langgraph; print(langgraph.__version__)"
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
