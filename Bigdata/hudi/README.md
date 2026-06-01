# Quick reference

- The official hudi docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# hudi | openEuler
Apache Hudi is an open data lakehouse platform, built on a high-performance open table format to ingest, index, store, serve, transform and manage your data across multiple cloud data environments.


Learn more on [Apache Hudi | An Open Source Data Lake Platform | Apache Hudi](https://hudi.apache.org/).

# Supported tags and respective Dockerfile links
The tag of each hudi docker image is consist of the version of hudi and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.1.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Bigdata/hudi/1.1.1/24.03-lts-sp3/Dockerfile) | hudi 1.1.1 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
To launch the Hudi CLI:

```bash
docker run -it openeuler/hudi:{Tag}
```

Once inside the CLI, connect to a Hudi table:

```
connect --path /path/to/hudi/table
```

To start a bash shell instead of the CLI:

```bash
docker run -it --entrypoint /bin/bash openeuler/hudi:{Tag}
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).