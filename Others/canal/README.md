
# Quick reference

- The official canal docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# canal | openEuler
Current canal images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Canal is an open-source project developed by Alibaba for real-time data synchronization. It is designed to capture and parse MySQL binlog (binary logs), allowing downstream systems to consume change data in near real-time.

# Supported tags and respective Dockerfile links
The tag of each canal docker image is consist of the version of canal and the version of basic image. The details are as follows

| Tags                                                                                                                           | Currently                              | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [1.1.8-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/canal/1.1.8/24.03-lts-sp1/Dockerfile) | canal 1.1.8 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [1.1.8-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/canal/1.1.8/24.03-lts-sp2/Dockerfile) | canal 1.1.8 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage

- Preparation

  For a self-hosted MySQL, you need to enable binlog and configure the binlog format as `ROW`. The `my.cnf` should be configured as follows:
  ```
  [mysqld]
  log-bin=mysql-bin        # Enable binlog
  binlog-format=ROW        # Set binlog format to ROW
  server_id=1              # Server ID required for MySQL replication; do not conflict with Canal's slaveId
  ```
  **Note:** For Alibaba Cloud RDS for MySQL, binlog is enabled by default, and the account already has the necessary binlog dump permissions. In this case, you can skip these steps.

  You also need to grant permissions to the Canal user, so it can connect as a MySQL slave. If the account already exists, you can directly use `GRANT`:
  ``` 
  CREATE USER 'canal' IDENTIFIED BY 'canal';
  GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'canal'@'%';
  -- GRANT ALL PRIVILEGES ON *.* TO 'canal'@'%';
  FLUSH PRIVILEGES;
  ```
    
- Startup
  
	```
	docker run -d --name my-canal -p 30306:3306 openeuler/canal:{Tag}
	```
	After the instance `my-canal` is started, you can view its running logs using `docker logs`.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).