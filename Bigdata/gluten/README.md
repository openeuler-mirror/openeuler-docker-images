# Quick reference

- The official Gluten artifact docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Apache Gluten | openEuler
Gluten is a native acceleration plugin for Apache Spark and Flink that provides performance acceleration by producing Java JARs and native libraries (for example, Velox). Learn more at https://github.com/apache/gluten.

# Supported tags and respective Dockerfile links
The tag of each gluten docker image is consist of the version of gluten and the version of basic image. The details are as follows
| Tags | Currently | Architectures |
|--|--|--|
|[1.6.0-24.03-lts-sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Bigdata/gluten/1.6.0/24.03-lts-sp3/Dockerfile)| gluten 1.6.0 on openEuler 24.03-lts-sp3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements. Build artifacts are placed under `/opt/gluten/dist` inside the image:

- JARs: `/opt/gluten/dist/jars`
- native libs: `/opt/gluten/dist/lib`

Pull the image:
```bash
docker pull openeuler/gluten:{Tag}
```

List artifacts inside image:
```bash
docker run --rm openeuler/gluten:{Tag} bash -c "find /opt/gluten/dist -type f -maxdepth 3 -print"
```

Extract artifacts to host:
```bash
docker create --name tmp openeuler/gluten:{Tag}
docker cp tmp:/opt/gluten/dist ./gluten-dist
docker rm -v tmp
```

# Question and answering
If you have any questions or want to use special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).

