# Quick reference

- The official tvm docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# Apache TVM | openEuler
Apache TVM is an open machine learning compilation framework, following the following principles:

- Python-first development that enables quick customization of machine learning compiler pipelines.
- Universal deployment to bring models into minimum deployable modules.

Learn more on [Apache TVM](https://tvm.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each tvm docker image is consist of the version of tvm and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.24.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/tvm/0.24.0/24.03-lts-sp3/Dockerfile) | tvm 0.24.0 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
Run the Docker container to launch the TVM developer image.
```docker run -it openeuler/tvm:{Tag}```

Verify the installation inside the container:
```python3 -c "import tvm; print(tvm.__file__)"```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
