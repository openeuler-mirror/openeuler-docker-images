# Quick reference

- The official milvus docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Milvus | openEuler
Current milvus docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Milvus is a high-performance vector database built for scale. It powers AI applications by efficiently organizing and searching vast amounts of unstructured data, such as text, images, and multi-modal information.

Learn more about milvus at [https://milvus.io/](https://milvus.io/).

# Supported tags and respective Dockerfile links
The tag of each `milvus` docker image is consist of the version of `milvus` and the version of basic image. The details are as follows

| Tag                                                                                                                                 | Currently                                | Architectures |
|-------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------|---------------|
| [2.5.14-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/milvus/2.5.14/24.03-lts-sp2/Dockerfile) | Milvus 2.5.14 on openEuler 24.03-LTS-SP2 | amd64, arm64  |
| [2.6.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/milvus/2.6.0/24.03-lts-sp2/Dockerfile)   | Milvus 2.6.0 on openEuler 24.03-LTS-SP2  | amd64, arm64  |

# Usage

- Step 1: Launch Milvus instance
    ```
    docker run --name euler-milvus -it openeuler/milvus:latest
    ```
- Step 2: Start etcd
	```
    etcd --data-dir=/data/milvus/data/etcd-data/ &
    ```
    The following message indicates that etcd is ready
    ```
    {"level":"info","ts":"2025-07-07T03:01:42.568Z","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d received MsgPreVoteResp from 8e9e05c52164694d at term 1"}
    {"level":"info","ts":"2025-07-07T03:01:42.568Z","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d became candidate at term 2"}
    {"level":"info","ts":"2025-07-07T03:01:42.568Z","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d received MsgVoteResp from 8e9e05c52164694d at term 2"}
    {"level":"info","ts":"2025-07-07T03:01:42.568Z","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"8e9e05c52164694d became leader at term 2"}
    {"level":"info","ts":"2025-07-07T03:01:42.568Z","logger":"raft","caller":"etcdserver/zap_raft.go:77","msg":"raft.node: 8e9e05c52164694d elected leader 8e9e05c52164694d at term 2"}
    {"level":"info","ts":"2025-07-07T03:01:42.568Z","caller":"etcdserver/server.go:2476","msg":"setting up initial cluster version using v2 API","cluster-version":"3.5"}
    {"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"membership/cluster.go:531","msg":"set initial cluster version","cluster-id":"cdf818194e3a8c32","local-member-id":"8e9e05c52164694d","cluster-version":"3.5"}
    {"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"api/capability.go:75","msg":"enabled capabilities for version","cluster-version":"3.5"}
    {"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"etcdserver/server.go:2500","msg":"cluster version is updated","cluster-version":"3.5"}
    {"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"etcdserver/server.go:2027","msg":"published local member to cluster through raft","local-member-id":"8e9e05c52164694d","local-member-attributes":"{Name:default ClientURLs:[http://localhost:2379]}","request-path":"/0/members/8e9e05c52164694d/attributes","cluster-id":"cdf818194e3a8c32","publish-timeout":"7s"}
    {"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"embed/serve.go:98","msg":"ready to serve client requests"}
    {"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"etcdmain/main.go:47","msg":"notifying init daemon"}
    {"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"etcdmain/main.go:53","msg":"successfully notified init daemon"}
    {"level":"info","ts":"2025-07-07T03:01:42.570Z","caller":"embed/serve.go:140","msg":"serving client traffic insecurely; this is strongly discouraged!","address":"127.0.0.1:2379"}
    ```
- Step 3: Start MinIO
    ```
    minio server /data/milvus/data/minio-data/ &
    ```
    The following message indicates that MinIO is ready
    ```
    Copyright: 2015-2025 MinIO, Inc.
    License: GNU AGPLv3 - https://www.gnu.org/licenses/agpl-3.0.html
    Version: RELEASE.2025-06-13T11-33-47Z (go1.24.4 linux/amd64)

    API: http://172.17.0.4:9000  http://127.0.0.1:9000
    RootUser: minioadmin
    RootPass: minioadmin

    WebUI: http://172.17.0.4:41483 http://127.0.0.1:41483
    RootUser: minioadmin
    RootPass: minioadmin

    CLI: https://min.io/docs/minio/linux/reference/minio-mc.html#quickstart
    $ mc alias set 'myminio' 'http://172.17.0.4:9000' 'minioadmin' 'minioadmin'

    Docs: https://docs.min.io
    WARN: Detected default credentials 'minioadmin:minioadmin', we recommend that you change these values with 'MINIO_ROOT_USER' and 'MINIO_ROOT_PASSWORD' environment variables
    ```

- Step 4: Start Milvus Standalone
    ```
    milvus run standalone
    ```
    The following message indicates that Milvus is ready
    ```
    [2025/07/07 07:33:31.307 +00:00] [INFO] [distance/calc_distance_amd64.go:14] ["Hook avx for go simd distance computation"]
    2025/07/07 07:33:31 maxprocs: Leaving GOMAXPROCS=16: CPU quota undefined

        __  _________ _   ____  ______
    /  |/  /  _/ /| | / / / / / __/
    / /|_/ // // /_| |/ / /_/ /\ \
    /_/  /_/___/____/___/\____/___/

    Welcome to use Milvus!
    Version:   2.5.14
    Built:     Mon Jul  7 07:32:02 UTC 2025
    GitCommit: 062fc368a5
    GoVersion: go version go1.24.2 linux/amd64

    TotalMem: 66068840448
    UsedMem: 56733696
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).