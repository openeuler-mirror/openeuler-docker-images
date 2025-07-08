# Quick reference

- The official FastDFS docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# FastDFS | openEuler
Current FastDFS docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

FastDFS is an open source high performance distributed file system (DFS). It's major functions include: file storing, file syncing and file accessing, and design for high capacity and load balance.

# Supported tags and respective Dockerfile links
The tag of each `fastdfs` docker image is consist of the version of `fastdfs` and the version of basic image. The details are as follows

| Tag                                                                                                                                 | Currently                                 | Architectures |
|-------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------|
| [6.12.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/fastdfs/6.12.3/24.03-lts-sp1/Dockerfile) | FastDFS 6.12.3 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/fastdfs` image from docker

	```
	docker pull openeuler/fastdfs:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use fastdfs.
    ```
    docker run -it --rm openeuler/fastdfs:{Tag} bash
    ```

- Start Tracker Server

    ```
    fdfs_trackerd /etc/fdfs/tracker.conf start
    ```
    Verify tracker os running:
    ```
    ps aux | grep fdfs_trackerd
    ```

- Start Storage Server

    Modify the `tracker_server` in the configuration file `/etc/fdfs/storage.conf` to the local container IP.
    ```
    fdfs_storaged /etc/fdfs/storage.conf start
    ```
    Verify storage is running:
    ```
    ps aux | grep fdfs_storaged
    ```
  
- Monitor Cluster Status
   
    Modify the `tracker_sercer` in the configuration file `/etc/fdfs/client.conf` to the local container IP.
    ```
    fdfs_monitor /etc/fdfs/client.conf
    ```
    Expected output should show:
    ```
    Storage 1:
        id = 172.17.0.2
        ip_addr = 172.17.0.2  ACTIVE
    ```
  
- Test File Upload

    Use the actual IP and  the brick path.
    The `force` flag allows you to create a single-node volume.
    ```
    # Create test file
    echo "Hello FastDFS" > test.txt
  
    # Upload file
    fdfs_test /etc/fdfs/client.conf upload test.txt
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).