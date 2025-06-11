# Quick reference

- The official oceanbase docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# oceanbase | openEuler
Current oceanbase docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

OceanBase is an open-source, distributed HTAP database management system.

Learn more on [oceanbase website](https://www.oceanbase.com/).

# Supported tags and respective Dockerfile links
The tag of each oceanbase docker image is consist of the version of oceanbase and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[4.3.5_CE_BP2_HF1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Database/oceanbase/4.3.5_CE_BP2_HF1/24.03-lts-sp1/Dockerfile)| oceanbase 4.3.5_CE_BP2_HF1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
Here, users can select `{Tag}` based on their requirements.

- Pull the `openeuler/oceanbase` image from docker

	```bash
	docker pull openeuler/oceanbase:{Tag}
	```
	
- Start a oceanbase instance

	```bash
	docker run -it --name my-oceanbase -p 2881:2881 openeuler/oceanbase:{Tag} bash
	```
	When `my-oceanbase` started, you can config and run your tasks
    ```
    [root@6559d851ae46 /]# obd --help
        Usage: obd <command> [options]
        Available commands:

        binlog         binlog service tools
        cluster        Deploy and manage a cluster.
        demo           Quickly start
        display-trace  display trace_id log.
        host           Host tools
        license        Register and display license.
        mirror         Manage a component repository for OBD.
        obdiag         Oceanbase Diagnostic Tool
        pwd            Obd cluster password management.
        repo           Manage local repository for OBD.
        test           Run test for a running deployment.
        tool           Tools
        update         Update OBD.
        web            Start obd deploy application as web.
        ...
    ```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).