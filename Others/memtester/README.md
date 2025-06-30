# Quick reference

- The official memtester docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# memtester | openEuler
Current memtester docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

memtester is an effective userspace tester for stress-testing the memory subsystem.

Learn more on [memtester website](https://linux.die.net/man/8/memtester).

# Supported tags and respective Dockerfile links
The tag of each memtester docker image is consist of the version of memtester and the version of basic image. The details are as follows

| Tags                                                                                                                               | Currently                                  |  Architectures|
|------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------|--|
| [4.7.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/memtester/4.7.1/24.03-lts-sp1/Dockerfile) | memtester 4.7.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}`  based on their requirements.

- Pull the `openeuler/memtester` image from docker

	```
	docker pull openeuler/memtester:{Tag}
	```
 
-  Basic Command Syntax

	```
	 memtester <memory_size> <iterations>
	```
 
 	* memory_size: Amount of RAM to test (e.g., 100M, 1G)
    * iterations: Number of test cycles (default: 1)。

- Example: Test 100MB RAM
   
    Run the following command to test 100MB of memory with 1 full pass:
	```
	memtester 100M 1
	```
    
    Expected Output:
    ```
    ......
    Loop 1/1:
      Stuck Address       : ok         
      Random Value        : ok
      Compare XOR         : ok
      Compare SUB         : ok
      Compare MUL         : ok
      Compare DIV         : ok
      Compare OR          : ok
      Compare AND         : ok
      Sequential Increment: ok
      Solid Bits          : ok         
      Block Sequential    : ok         
      Checkerboard        : ok         
      Bit Spread          : ok         
      Bit Flip            : ok         
      Walking Ones        : ok         
      Walking Zeroes      : ok         
      8-bit Writes        : ok
      16-bit Writes       : ok

    Done.
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).