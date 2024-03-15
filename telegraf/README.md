# Telegraf

# Quick reference

- The official telegraf docker image.

- Maintained by: [openEuler BigData SIG](https://gitee.com/openeuler/bigdata)

- Where to get help: [openEuler BigData SIG](https://gitee.com/openeuler/bigdata), [openEuler](https://gitee.com/openeuler/community)

# Build reference

1. Build images and push:
```shell
docker buildx build -t "openeuler/telegraf:$VERSION" --platform linux/amd64,linux/arm64 . --push
```

We are using `buildx` in here to generate multi-arch images, see more in [Docker Buildx](https://docs.docker.com/buildx/working-with-buildx/)

# How to use this image

config example:
```
[global_tags]
# Environment tags
env = "staging"

[agent]
interval = "10s"
round_interval = true
metric_batch_size = 1000
metric_buffer_limit = 10000
collection_jitter = "0s"
flush_interval = "10s"
flush_jitter = "0s"
precision = ""
debug = false
quiet = false
logfile = ""
hostname = ""
omit_hostname = false

[[inputs.cpu]]
## Whether to report per-cpu stats or just total for all cpus
percpu = true
## Whether to include the time field in the output.
totalcpu = true
## Collect CPU time in different states.
collect_cpu_time = true
## If true, collect raw CPU time metrics.
report_active = true

[[outputs.influxdb]]
urls = ["http://localhost:8086"]
database = "telegraf"
precision = "s"
```

```shell
docker run --name telegraf -d -v /your-path/telegraf.conf:/etc/telegraf/telegraf.conf openeuler/telegraf:{TAG}
```

# Supported tags and respective Dockerfile links

- 1.29.5-22.03-lts-sp3: telegraf v1.29.5, openEuler 22.03-LTS-SP3

## Operating System
Linux/Unix, ARM64 or x86-64 architecture.
