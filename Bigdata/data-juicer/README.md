# Quick reference

- The official data-juicer docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# data-juicer | openEuler
Current data-juicer docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Data-Juicer (DJ) transforms raw data chaos into AI-ready intelligence. It treats data processing as *composable infrastructure*—providing modular building blocks to clean, synthesize, and analyze data across the entire AI lifecycle, unlocking latent value in every byte.

Whether you're deduplicating web-scale pre-training corpora, curating agent interaction traces, or preparing domain-specific RAG indices, DJ scales seamlessly from your laptop to thousand-node clusters—no glue code required.

Learn more on [Data-Juicer: The Data Operating System for the Foundation Model Era](https://datajuicer.github.io/data-juicer/).


# Supported tags and respective Dockerfile links
The tag of each data-juicer docker image is consist of the version of data-juicer and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.5.1-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/data-juicer/1.5.1/24.03-lts-sp3/Dockerfile) | data-juicer 1.5.1 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
Start a container and run a data processing pipeline:

```
docker run -it --rm openeuler/data-juicer:1.5.1-oe2403sp3 bash
```

Inside the container, use the CLI tools:

```
# Run a data processing pipeline
dj-process --config demos/process_simple/process.yaml

# Analyze a dataset
dj-analyze --config demos/analyze/analyze.yaml
```

Use in a Dockerfile:

```
FROM openeuler/data-juicer:1.5.1-oe2403sp3
COPY my-pipeline.yaml /home/datajuicer/
CMD ["dj-process", "--config", "/home/datajuicer/my-pipeline.yaml"]
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
