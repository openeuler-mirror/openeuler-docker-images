# Quick reference

- The official GlusterFS docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# GlusterFS | openEuler
Current GlusterFS docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

GlusterFS is a scalable network filesystem suitable for data-intensive tasks such as cloud storage and media streaming. GlusterFS is free and open source software and can utilize common off-the-shelf hardware.

Learn more on [GlusterFS Documentation](https://docs.gluster.org/en/latest/).

# Supported tags and respective Dockerfile links
The tag of each `glusterfs` docker image is consist of the version of `glusterfs` and the version of basic image. The details are as follows

| Tag                                                                                                                               | Currently                                 | Architectures |
|-----------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------|
| [11.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/glusterfs/11.1/24.03-lts-sp1/Dockerfile) | GlusterFS 11.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/glusterfs` image from docker

	```bash
	docker pull openeuler/glusterfs:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use glusterfs.
    ```
    docker run -it --rm openeuler/glusterfs:{Tag} bash
    ```

- Start the GlusterFS management daemon

    ```
    glusterd
    ```
    This start the `glusterd` service, which manages your cluster state.

- Create a brick directory and a mount point

    ClusterFS requires a physical directory to store data (called a brick) and a local directory where you will mount the volume.
    ```
    mkdir -p /bricks/brick1 /mnt/glusterfs
    ```
  
- Get your container's real IP address
   
    Using `localhost` or `127.0.0.1` does not work for volume creation -- use the actual IP.
    ```
    dnf install -y hostname
    export NODE_IP=$(hostname -i | awk '{print $1}')
    echo "Node IP: ${NODE_IP}"
    ```
  
- Create the ClusterFS volume

    Use the actual IP and  the brick path.
    The `force` flag allows you to create a single-node volume.
    ```
    gluster volume create testvol ${NODE_IP}:/bricks/brick1 force
    ```
  
- Start the volume

    ```
    gluster volume start testvol
    ```
  
- Mount the volume 

    Use `mount -t glusterfs`.
    **Note:** You must run the container in `--privileged` mode (or with `--cap-add SYS_ADMIN`) so the kernel allows FUSE mounts.
    ```
    mount -t glusterfs ${NODE_IP}:/testvol /mnt/glusterfs
    ```
  
- Verify

    Write a file into your mounted GlusterFS volume and list its contents.
    ```
    echo "test file" > /mnt/glusterfs/test.txt
    ls -l /mnt/glusterfs
    ```
    You should see `text.txt` inside your mounted volume.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).