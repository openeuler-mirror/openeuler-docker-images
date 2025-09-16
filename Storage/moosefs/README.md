# Quick reference

- The official MooseFS docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# MooseFS | openEuler
Current MooseFS docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

MooseFS is a Petabyte Open Source Network Distributed File System. It is easy to deploy and maintain, highly reliable, fault tolerant, highly performing, easily scalable and POSIX compliant.

Learn more on [moosefs Documentation](https://moosefs.com/support/#documentation).

# Supported tags and respective Dockerfile links
The tag of each `moosefs` docker image is consist of the version of `moosefs` and the version of basic image. The details are as follows

| Tag                                                                                                                                 | Currently                                 | Architectures |
|-------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------|
| [4.57.5-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/moosefs/4.57.5/24.03-lts-sp1/Dockerfile) | MooseFS 4.57.5 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [4.58.0-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Storage/moosefs/4.58.0/24.03-lts-sp2/Dockerfile) | MooseFS 4.58.0 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/moosefs` image from docker

	```bash
	docker pull openeuler/moosefs:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use moosefs.
    ```
    docker run -it --rm openeuler/moosefs:{Tag} bash
    ```

- Create mfsmaster.cfg

    Create mfs configuration directory:
    ```
    mkdir -p /etc/mfs
    ```
  
    Create mfs configuration file `/etc/mfs/mfsmaster.cfg`:
    ```
    DATA_PATH = /var/lib/mfs
    EXPORTS_FILENAME = /etc/mfs/mfsexports.cfg

    WORKING_USER = root
    WORKING_GROUP = root
    ```

- Create mfsexports.cfg

    `/etc/mfs/mfsexports.cfg`:
    ```
    * / rw,alldirs,maproot=0
    ```
  
- Create empty optional files

    For single-node tests, these can be empty. There're used for rack/host mapping and advanced topology placement.
    * `/etc/mfs/mfstopology.cfg`
    * `/etc/mfs/mfsipmap.cfg`
  
- Initialize metadata

    Inside you data path (`/var/lib/mfs`):
    ```
    mkdir -p /var/lib/mfs
    cd /var/lib/mfs
    echo -e "MFSM NEWMETADATA 1\nEMPTY METADATA FILE" > metadata.mfs.empty
    ```
    This creates an empty metadata file, needed for first-time startup.
  
- Start the MooseFS Master

    ```
    /moosefs/mfsmaster/mfsmaster start
    ```
  
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).