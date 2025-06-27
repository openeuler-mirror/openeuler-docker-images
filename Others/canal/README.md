
# Quick reference

- The official canal docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# canal | openEuler
Current canal images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Canal is an open-source project developed by Alibaba for real-time data synchronization. It is designed to capture and parse MySQL binlog (binary logs), allowing downstream systems to consume change data in near real-time.

# Supported tags and respective Dockerfile links
The tag of each canal docker image is consist of the version of canal and the version of basic image. The details are as follows

| Tags                                                                                                                               | Currently                                 |  Architectures|
|------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|--|
| [1.1.8-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/canal/1.1.8/24.03-lts-sp1/Dockerfile) | canal 1.1.8 on openEuler 24.03-LTS-SP1 |  amd64, arm64 |

# Usage
- Add canal client dependency

  Add the following dependency to your `pom.xml` to include the `Canal Java Client`.
  ```
  <dependency>
    <groupId>com.alibaba.otter</groupId>
    <artifactId>canal.client</artifactId>
    <version>1.1.0</version>
  </dependency>
  ```
    
- Create a standard maven project
  
  You can create a standard Maven project using the Maven Archetype Plugin.

  **For older Maven versions:**
  ```
  mvn archetype:create -DgroupId=com.alibaba.otter -DartifactId=canal.sample
  ```
  **For Maven 3.0.5 and above(recommended):**
  ```
  mvn archetype:generate -DgroupId=com.alibaba.otter -DartifactId=canal.sample
  ```
  This generates a basic Maven project structure.

- Write the `ClientSample` class
  Here is a basic example of a Java client connecting to a Canal server:
  ```
  package com.alibaba.otter;

  import com.alibaba.otter.canal.client.CanalConnector;
  import com.alibaba.otter.canal.client.CanalConnectors;
  import com.alibaba.otter.canal.protocol.Message;
  
  import java.net.InetSocketAddress;
  
  public class ClientSample {
      public static void main(String[] args) {
          CanalConnector connector = CanalConnectors.newSingleConnector(
              new InetSocketAddress("127.0.0.1", 11111),
              "example",
              "",
              ""
          );
          try {
              connector.connect();
              connector.subscribe(".*\\..*");
              connector.rollback();
              while (true) {
                  Message message = connector.getWithoutAck(100);
                  long batchId = message.getId();
                  int size = message.getEntries().size();
                  if (batchId != -1 && size > 0) {
                      System.out.printf("Received batchId: %d, entry size: %d%n", batchId, size);
                  }
                  connector.ack(batchId);
              }
          } finally {
              connector.disconnect();
          }
      }
  }
  ```
  
  **Notes:**
  * Ensure the `Canal Server` is running and correctly configured (refer to the [QuickStart](https://github.com/alibaba/canal/wiki/QuickStart)).
  * The above code connects to `127.0.0.1:11111`, which is the default TCP port for the Canal Server.
  * `subscribe(".*\\..*")` means subscribe to all tables in all databases.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).