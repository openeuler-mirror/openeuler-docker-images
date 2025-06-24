
# Quick reference

- The official BusyBox docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# BusyBox | openEuler
Current BiSheng BusyBox images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[BusyBox](https://busybox.net/downloads/BusyBox.html) is a multi-call binary. A multi-call binary is an executable program that performs the same job as more than one utility program. That means there is just a single BusyBox binary, but that single binary acts like a large number of utilities. This allows BusyBox to be smaller since all the built-in utility programs (we call them applets) can share code for many common operations.

# Supported tags and respective Dockerfile links
The tag of each BusyBox docker image is consist of the version of BusyBox and the version of basic image. The details are as follows

| Tags                                                                                                                               | Currently                                 |  Architectures|
|------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|--|
| [1.37.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/busybox/1.37.0/24.03-lts-sp1/Dockerfile) | BusyBox 1.37.0 on openEuler 24.03-LTS-SP1 |  amd64, arm64 |

# Usage
  
  You can also invoke BusyBox by issuing a command as an argument on the command line. For example, entering

    busybox ls
    
  will also cause BusyBox to behave as 'ls'.

  Of course, adding '/bin/busybox' into every command would be painful. So most people will invoke BusyBox using links to the BusyBox binary.
  
    ln -s /usr/local/busybox/bin/busybox ls
    ./ls

  will cause BusyBox to behave as 'ls' (if the 'ls' command has been compiled into BusyBox). Generally speaking, you should never need to make all these links yourself, as the BusyBox build system will do this for you when you run the 'make install' command.
  If you invoke BusyBox with no arguments, it will provide you with a list of the applets that have been compiled into your BusyBox binary.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).