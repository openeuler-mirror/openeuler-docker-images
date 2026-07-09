# Quick reference

- The official towhee docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openeuler](https://atomgit.com/openeuler/community).
# towhee | openEuler
Towhee is a cutting-edge framework designed to streamline the processing of unstructured data through the use of Large Language Model (LLM) based pipeline orchestration. It is uniquely positioned to extract invaluable insights from diverse unstructured data types, including lengthy text, images, audio and video files. Leveraging the capabilities of generative AI and the SOTA deep learning models, Towhee is capable of transforming this unprocessed data into specific formats such as text, image, or embeddings. These can then be efficiently loaded into an appropriate storage system like a vector database. Developers can initially build an intuitive data processing pipeline prototype with user friendly Pythonic API, then optimize it for production environments.


# Supported tags and respective Dockerfile links
The tag of each towhee docker image is consist of the version of towhee and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.1.3-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/towhee/1.1.3/24.03-lts-sp4/Dockerfile) | towhee 1.1.3 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[1.1.3-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/towhee/1.1.3/24.03-lts-sp3/Dockerfile) | towhee 1.1.3 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
## Start a towhee instance

To start a towhee container, use the following command:

```bash
docker run -it openeuler/towhee:{Tag}
```

For more information, visit [Towhee documentation](https://towhee.readthedocs.io/en/latest/).
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
