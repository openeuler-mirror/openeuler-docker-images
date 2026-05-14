# Quick reference

- The official auron docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# auron | openEuler
The Auron accelerator for big data engines (e.g., Spark, Flink) leverages native vectorized execution to accelerate query processing. It combines the power of the Apache DataFusion library and the scale of the distributed computing framework.

Auron takes a fully optimized physical plan from a distributed computing framework, mapping it into DataFusion's execution plan, and performs native plan computation.

- **Native execution**: Implemented in Rust, eliminating JVM overhead and enabling predictable performance.
- **Vectorized computation**: Built on Apache Arrow's columnar format, fully leveraging SIMD instructions for batch processing.
- **Pluggable architecture**: Seamlessly integrates with Apache Spark while designed for future extensibility to other engines.
- **Production-hardened optimizations**: Multi-level memory management, compacted shuffle formats, and adaptive execution strategies developed through large-scale deployment.

# Supported tags and respective Dockerfile links
The tag of each auron docker image is consist of the version of auron and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[7.0.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/auron/7.0.0/24.03-lts-sp3/Dockerfile) | auron 7.0.0 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
To use Auron with Apache Spark:

1. Copy the Auron JAR from the image to your Spark classpath:
```
docker run --rm openeuler/auron:7.0.0-oe2403sp3 cat /opt/auron/auron-spark_2.12-release-linux-x86_64-7.0.0-incubating.jar > $SPARK_HOME/jars/auron-spark.jar
```

2. Add the following configurations to `$SPARK_HOME/conf/spark-defaults.conf`:
```properties
spark.auron.enable true
spark.sql.extensions org.apache.spark.sql.auron.AuronSparkSessionExtension
spark.shuffle.manager org.apache.spark.sql.execution.auron.shuffle.AuronShuffleManager
spark.memory.offHeap.enabled false

spark.executor.memory 4g
spark.executor.memoryOverhead 4096
```

3. Submit a query with spark-sql:
```
spark-sql -f query.sql
```

Learn more on [Apache Auron official site](https://auron.apache.org/).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).