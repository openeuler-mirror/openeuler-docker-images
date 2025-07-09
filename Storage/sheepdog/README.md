# Quick reference

- The official sheepdog docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# sheepdog | openEuler
Current sheepdog docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Sheepdog is a distributed storage system for QEMU. It provides
highly available block level storage volumes to virtual machines. 
Sheepdog supports advanced volume management features such as snapshot,
cloning, and thin provisioning.

Learn more on [sheepdog Website](https://sheepdog.github.io/sheepdog/).

# Supported tags and respective Dockerfile links
The tag of each `sheepdog` docker image is consist of the version of `sheepdog` and the version of basic image. The details are as follows

| Tag                                                                                                                                | Currently                                 | Architectures |
|------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------|
| [1.0.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/sheepdog/1.0.1/24.03-lts-sp1/Dockerfile) | sheepdog 1.0.1 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/sheepdog` image from docker

	```bash
	docker pull openeuler/sheepdog:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use sheepdog.
    ```
    docker run -it --rm openeuler/sheepdog:{Tag} bash
    ```

- Set up the storage environment

    Create a directory for sheepdog storage
    ```
    mkdir -p /home/storage
    ```

- Start the sheepdog daemon

    The `-c local` flag runs sheepdog in standalone mode(no cluster). 
    ```
    sheep /home/store/ -c local
    ```
  
- Initialize the cluster
   
    The `--copies=2` flag ensures data redundancy by storing two copies.
    ```
    collie cluster format --copies=2
    ```
  
- Create a virtual disk image (VDI)

    Create a 10GB volume named `myvolume`
    ```
    collie vdi create myvolume 10G
    ```
  
- Verify the volume

    List available volumes
    ```
    collie vdi list
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).