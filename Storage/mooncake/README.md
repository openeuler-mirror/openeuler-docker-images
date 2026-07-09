# Quick reference

- The official Mooncake docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# Mooncake | openEuler
Current Mooncake docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Mooncake is a high-performance transfer engine for distributed AI inference workloads, developed by KVCache.AI. It provides a RDMA/TCP-based data plane for efficient KV cache transfer between disaggregated prefill and decode instances in large language model (LLM) serving systems. Mooncake is designed for distributed storage and high-speed data movement in cloud-native AI infrastructure.

Learn more about Mooncake on [GitHub](https://github.com/kvcache-ai/Mooncake)⁠.

# Supported tags and respective Dockerfile links
The tag of each `mooncake` docker image is consist of the version of `mooncake` and the version of basic image. The details are as follows

| Tag                                                                                                                                                       | Currently                                              | Architectures |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|---------------|
|[0.3.11.post1-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Storage/mooncake/0.3.11.post1/24.03-lts-sp4/Dockerfile) | Mooncake 0.3.11.post1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[0.3.11.post1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Storage/mooncake/0.3.11.post1/24.03-lts-sp3/Dockerfile) | Mooncake 0.3.11.post1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/mooncake` image from docker

	```bash
	docker pull openeuler/mooncake:{Tag}
	```

- Run the transfer engine benchmark (sender side)

    ```bash
    docker run --rm --network host openeuler/mooncake:{Tag} \
        transfer_engine_bench --mode=initiator \
        --metadata_server=<metadata-ip>:2379 \
        --local_server_name=<local-ip>:12345
    ```

- Run the transfer engine benchmark (receiver side)

    ```bash
    docker run --rm --network host openeuler/mooncake:{Tag} \
        transfer_engine_bench --mode=target \
        --metadata_server=<metadata-ip>:2379 \
        --local_server_name=<local-ip>:12346
    ```

- Validate the transfer engine

    ```bash
    docker run --rm --network host openeuler/mooncake:{Tag} \
        transfer_engine_validator --metadata_server=<metadata-ip>:2379
    ```

- View available tools

    | Tool                                   | Description                                          |
    |----------------------------------------|------------------------------------------------------|
    | `transfer_engine_bench`                | Benchmark the transfer engine throughput and latency |
    | `transfer_engine_validator`            | Validate transfer correctness between two nodes      |
    | `transfer_engine_bench_with_notify`    | Benchmark with notification-based completion         |

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
