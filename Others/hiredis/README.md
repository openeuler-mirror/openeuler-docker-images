# Quick reference

- The official Hiredis docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Hiredis | openEuler
Current Hiredis docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Hiredis is a minimalistic C client library for the Redis database.

Learn more about Hiredis on [Hiredis Website](https://redis.io/lpage/hiredis/)⁠.

# Supported tags and respective Dockerfile links
The tag of each `hiredis` docker image is consist of the version of `hiredis` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.3.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/hiredis/1.3.0/24.03-lts-sp1/Dockerfile)| Hiredis 1.3.0 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/hiredis` image from docker

	```bash
	docker pull openeuler/hiredis:{Tag}
	```

- Redis client example with hiredis

    This example demonstrates how to connect to a Redis server and execute basic commands using the Hiredis client library in C.
    The example connects to a Redis server running on `127.0.0.1` at port `6379`, sends a PING command, and prints the response.
  
    Ensure you have Redis installed and running. You can start the Redis server using the following commands:
    ```
    dnf install -y redis
    nohup redis-server /etc/redis.conf --daemonize no > /var/log/redis.log 2>&1 &
    ```
  
- Example: A minimal hiredis program
  
    Create a file named `hiredis.c` with the following content:
    ```
    #include <stdlib.h>
    #include <hiredis/hiredis.h>

    int main() {
        // Connect to Redis (default: 127.0.0.1:6379)
        redisContext *c = redisConnect("127.0.0.1", 6379);
    
        // Check connection status
        if (c == NULL || c->err) {
            printf("Connection failed: %s\n", c ? c->errstr : "Memory allocation failed");
            exit(1);  // Exit with error code
        }
        printf("Redis connection established!\n");

        // Execute PING command
        redisReply *reply = redisCommand(c, "PING");
        printf("PING response: %s\n", reply->str);
    
        // Free reply memory
        freeReplyObject(reply);

        // Close connection
        redisFree(c);
    
        return 0;  // Exit successfully
    }
    ```
    
- Compilation
   
    Compile the `hiredis.c` program using the following command:
    ```
    gcc -o hiredis hiredis.c -lhiredis
    ```

- Execution

    Run the compiled binary using the following command:
    ```
    ./hiredis
    ```
    
- Output
    ```
    Redis connection established!
    PING response: PONG
    ```
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).