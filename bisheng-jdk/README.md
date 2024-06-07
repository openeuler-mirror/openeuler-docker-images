
# Quick reference

- The official BiSheng JDK docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# BiSheng JDK | openEuler
Current BiSheng JDK docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[BiSheng JDK](https://www.openeuler.org/en/other/projects/bishengjdk/) is a high-performance [OpenJDK](https://en.wikipedia.org/wiki/OpenJDK) distribution for production environments that is developed based on OpenJDK. The BiSheng JDK has been used in a variety of Huawei products, has resolved many problems encountered during service running, and has enhanced ARM architecture. It delivers superior performance in big data scenarios. BiSheng JDK 8 is compatible with the Java SE Specifications, and currently supports the Linux/aarch64 and the Linux/x86_64 platform. As a downstream version of OpenJDK, the BiSheng JDK will continuously contribute to the OpenJDK community.

Key Features:

- Performs optimization based on the ARM architecture and big data scenarios for better performance.
- Updates patches on a quarterly basis for higher security.
- Delivers stable functions after large-scale tests and verification.

# Supported tags and respective Dockerfile links
The tag of each BiSheng JDK docker image is consist of the version of BiSheng JDK and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
| [17.0.10-oe2203sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/bisheng-jdk/17.0.10/22.03-lts-sp3/Dockerfile) | BiSheng JDK 17.0.10 on openEuler 22.03-LTS-SP3 |  amd64, arm64 |

# Quick reference (cont.)
- Where to file issues: [https://gitee.com/openeuler/openeuler-docker-images/issues](https://gitee.com/openeuler/openeuler-docker-images/issues)

- Supported architectures: ([more info](https://gitee.com/openeuler/openeuler-docker-images/tree/master/bisheng-jdk))
	amd64, arm64

- Image updates:
[official-images repo's library/bishengjdk-17 label](https://gitee.com/openeuler/bishengjdk-17/issues)
[official-images repo's library/bishengjdk-17 file](https://gitee.com/openeuler/bishengjdk-17/blob/master/README.en.md)([history](https://gitee.com/openeuler/bishengjdk-17/commits/master))

- Source of this description:
[docs repo's bisheng-jdk/ directory](https://gitee.com/openeuler/openeuler-docker-images/tree/master/bisheng-jdk#bisheng-jdk) ([history](https://gitee.com/openeuler/openeuler-docker-images/commits/master/bisheng-jdk))
# Usage
  
  BiSheng JDK docker images provide a customized Java development and running environment based on OpenJDK, it can be used as follows
  
  - Start a Java instance in your app
  
    The most straightforward way to use this image is to use a Java container as both the build and runtime environment. In your Dockerfile, writing something along the lines of the following will compile and run your project:
    
    ```
    # Dockerfile
    FROM openeuler/bisheng-jdk:{Tag}

    COPY . /usr/src/myapp
    WORKDIR /usr/src/myapp
    RUN javac Main.java
    CMD ["java", "Main"]
    ```
   
    You can then run and build the Docker image:
    ```
    docker build -t my-java-app .
    docker run -it --rm --name my-running-app my-java-app
    ```
        
 - Container test

    Use the following method to verify the JAVA environment installed in the image
    ```
    docker run -it openeuler/bisheng-jdk:{Tag} java --version
    ```
    For example, as the `{Tag}` is `17.0.10-oe2203sp3`, returning the following information proves that the environment is good.
    ```
    openjdk 17.0.10 2024-01-16
    OpenJDK Runtime Environment BiSheng (build 17.0.10+11)
    OpenJDK 64-Bit Server VM BiSheng (build 17.0.10+11, mixed mode, sharing)
    ```

  - Compile your app inside the Docker container

    There may be occasions where it is not appropriate to run your app inside a container. To compile, but not run your app inside the Docker instance, you can write something like:
    ```
    docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp openeuler/bisheng-jdk:{Tag} javac Main.java
    ```
    This will add your current directory as a volume to the container, set the working directory to the volume, and run the command `javac Main.java` which will tell Java to compile the code in `Main.java` and output the Java class file to `Main.class`.


- Make JVM respect CPU and RAM limits
	
	On startup the JVM tries to detect the number of available CPU cores and RAM to adjust its internal parameters (like the number of garbage collector threads to spawn) accordingly. When the container is ran with limited CPU/RAM then the standard system API used by the JVM for probing it will return host-wide values. This can cause excessive CPU usage and memory allocation errors with older versions of the JVM.

	Inside Linux containers, OpenJDK versions 8 and later can correctly detect the container-limited number of CPU cores and available RAM. For all currently supported OpenJDK versions this is turned on by default.

	Inside Windows Server (non-Hyper-V) containers, the limit for the number of available CPU cores doesn't work (it's ignored by Host Compute Service). To set the limit manually the JVM can be started as:
    ```
    start /b /wait /affinity 0x3 path/to/java.exe ...
    ```
	In this example CPU affinity hex mask 0x3 will limit the JVM to 2 CPU cores.

	RAM limit is supported by Windows Server containers, but currently the JVM cannot detect it. To prevent excessive memory allocations, -XX:MaxRAM=... option must be specified with the value that is not bigger than the containers RAM limit.

- Environment variables with periods in their names
	Some shells (notably, [the BusyBox /bin/sh included in Alpine Linux](https://github.com/docker-library/openjdk/issues/135)) do not support environment variables with periods in the names (which are technically not POSIX compliant), and thus strip them instead of passing them through (as Bash does). If your application requires environment variables of this form, either use CMD ["java", ...] directly (no shell), or (install and) use Bash explicitly instead of /bin/sh.
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).