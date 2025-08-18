# Quick reference

- The official Spring Boot docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Spring Boot | openEuler
Current Spring Boot docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Spring Boot is an open-source, opinionated Java framework designed to simplify the development of standalone, production-grade Spring-based applications. It extends the Spring Framework by providing features that streamline and accelerate the development process, particularly for microservices and web application

Learn more on [Spring Boot Website](https://spring.io/projects/spring-boot)⁠.

# Supported tags and respective Dockerfile links
The tag of each `spring-boot` docker image is consist of the version of `spring-boot` and the version of basic image. The details are as follows

| Tag                                                                                                                                  | Currently                                    | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|---------------|
| [3.4.4-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/spring-boot/3.4.4/24.03-lts-sp1/Dockerfile) | Spring Boot 3.4.4 on openEuler 24.03-LTS-SP1 | amd64, arm64  |
| [3.5.4-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/spring-boot/3.5.4/24.03-lts-sp2/Dockerfile) | Spring Boot 3.5.4 on openEuler 24.03-LTS-SP2 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Version}` based on their requirements.

- Add Spring Boot to your project

    **Using Maven:**

    Add the `spring-boot-starter-parent` and a `starter dependency` to your `pom.xml`:
    ```
    <parent>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-parent</artifactId>
      <version>${Version}</version> <!-- Replace with latest -->
    </parent>
    
    <dependencies>
      <!-- Spring Boot Web Starter -->
      <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
      </dependency>
    </dependencies>
    ```
    **Using Gradle:**
    ```
    plugins {
      id 'org.springframework.boot' version '${Version}'
    }
    
    dependencies {
      implementation 'org.springframework.boot:spring-boot-starter-web'
    }
    ```

- Create an Application class

    Create a simple `application` class with a `main` method:
    ```
    package com.example;
  
    import org.spring-boot.*;
    import org.spring-boot.impl.StdSchedulerFactory;
    
    package com.spring.boot;
  
    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.web.bind.annotation.*;
    
    @SpringBootApplication
    @RestController
    public class Application {
    
        @RequestMapping("/")
        public String home() {
            return "Hello World!";
        }
    
        public static void main(String[] args) {
            SpringApplication.run(Application.class, args);
        }
    }
    ``` 

- Run the application

    Run your application from your IDE or with maven:
    ```
    ./mvnw spring-boot:run
    ```
    
    Or with Gradle:
    ```
    ./gradlew bootRun
    ```
    
    Open your website and visit: http://localhost:8080/, you should see:
    ```
    Hello World!
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).