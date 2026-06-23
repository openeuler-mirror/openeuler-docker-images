# Quick reference

- The official OpenVeLinux (flamegraph) docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).

# OpenVeLinux | openEuler
Current OpenVeLinux images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

OpenVeLinux is ByteDance's cloud-optimized Linux distribution, featuring a custom kernel fork and related toolchain for cloud-native workloads. This image packages **flamegraph**, a Perl-based flame graph visualization tool from the OpenVeLinux project, used for profiling Linux performance data including perf, SystemTap, and eBPF traces.

Read more on [OpenVeLinux GitHub](https://github.com/openvelinux) and [flamegraph](https://github.com/openvelinux/flamegraph).

# Supported tags and respective dockerfile links
The tag of each `openvelinux` docker image is consist of the version of `openvelinux` and the version of basic image. The details are as follows

| Tag | Currently | Architectures |
|-----|-----------|---------------|
|[1.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Cloud/openvelinux/1.0/24.03-lts-sp3/Dockerfile) | OpenVeLinux flamegraph 1.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/openvelinux` image from docker

	```
	docker pull openeuler/openvelinux:{Tag}
	```

- Generate a flame graph from perf data

    ```
    # Collect perf data on host
    perf record -g -p <pid> -- sleep 30
    perf script | docker run --rm -i openeuler/openvelinux:{Tag} \
        stackcollapse-perf.pl | \
        docker run --rm -i openeuler/openvelinux:{Tag} \
        flamegraph.pl > flamegraph.svg
    ```

- Run interactively

    ```
    docker run -it --rm openeuler/openvelinux:{Tag}
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
