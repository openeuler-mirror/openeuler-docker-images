# Quick reference

- The official tidb docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# tidb | openEuler
Current tidb docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

TiDB is an open-source, cloud-native, distributed SQL database designed for high availability, horizontal and vertical scalability, strong consistency, and high performance.

For more information about tidb, please visit [https://pingcap.com/](https://pingcap.com/).

# Supported tags and respective Dockerfile links
The tag of each tidb docker image is consist of the version of tidb and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[8.5.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Bigdata/tidb/8.5.1/24.03-lts-sp1/Dockerfile)| Tidb 8.5.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage

- Start a TiDB instance by following command:
    ```bash
    docker run -it --name my-tidb -p 4000:4000 tidb openeuler/tidb:latest
    ```

- Connect TiDB by `mysql` client：
    ```
    ~$ mysql -h 127.0.0.1 -P 4000 -u root  
    ```
    The following message indicates that "my-tidb" is ready:
    ```
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 2097154
    Server version: 8.0.11-TiDB-v8.5.1 TiDB Server (Apache License 2.0) Community Edition, MySQL 8.0 compatible

    Copyright (c) 2000, 2025, Oracle and/or its affiliates.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql>
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).