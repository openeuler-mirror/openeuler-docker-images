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

Pull the image (example):

```bash
docker pull openeuler/gluten:1.6.0
```

List artifacts inside image:

```bash
docker run --rm openeuler/gluten:1.6.0 bash -c "find /opt/gluten/dist -type f -maxdepth 3 -print"
```

Extract artifacts to host:

```bash
docker create --name tmp openeuler/gluten:1.6.0
docker cp tmp:/opt/gluten/dist ./gluten-dist
docker rm -v tmp
```

## Using on Spark clusters
Gluten provides acceleration as a plugin for Spark. Typical production usage:

1. Node deployment (distribute artifacts to each node)
   - Copy the JARs into `$SPARK_HOME/jars`.
   - Place native libraries under a directory such as `/opt/gluten/lib` and ensure the runtime sets:

```bash
export LD_LIBRARY_PATH=/opt/gluten/lib:$LD_LIBRARY_PATH
```

2. Specify JARs at job submission (example):

```bash
spark-submit \
  --class <MainClass> \
  --master yarn \
  --deploy-mode cluster \
  --jars /opt/gluten/dist/jars/gluten.jar,/opt/gluten/dist/jars/velox-native.jar \
  --conf spark.driver.extraClassPath=/opt/gluten/dist/jars/gluten.jar \
  --conf spark.executor.extraClassPath=/opt/gluten/dist/jars/gluten.jar \
  --conf spark.gluten.sql.columnar.enable=true \
  your-app.jar
```

## Using on Kubernetes (recommended: initContainer + shared volume)
Use an `initContainer` to copy artifacts from the artifact image into a shared volume. The main application container mounts the volume at `/opt/gluten` and sets `LD_LIBRARY_PATH`. Example fragment:

```yaml
initContainers:
  - name: copy-gluten
    image: openeuler/gluten:1.6.0
    command: ["sh","-c","cp -r /opt/gluten/dist /artifacts && chown -R 1000:1000 /artifacts"]
    volumeMounts:
      - name: artifacts
        mountPath: /artifacts

containers:
  - name: app
    image: openeuler/your-app:latest
    volumeMounts:
      - name: artifacts
        mountPath: /opt/gluten
    env:
      - name: LD_LIBRARY_PATH
        value: /opt/gluten/dist/lib:$LD_LIBRARY_PATH

volumes:
  - name: artifacts
    emptyDir: {}
```

# Question and answering
If you have any questions or want to use special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).

