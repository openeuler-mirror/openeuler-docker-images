# Quick reference

- The official Spring Cloud docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Spring Cloud | openEuler
Current Spring Cloud docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Spring Cloud provides tools for developers to quickly build some of the common patterns in distributed systems (e.g. configuration management, service discovery, circuit breakers, intelligent routing, micro-proxy, control bus, short lived microservices and contract testing). Coordination of distributed systems leads to boiler plate patterns, and using Spring Cloud developers can quickly stand up services and applications that implement those patterns. They will work well in any distributed environment, including the developer’s own laptop, bare metal data centres, and managed platforms such as Cloud Foundry.

Learn more on [Spring Cloud Website](https://spring.io/projects/spring-cloud)⁠.

# Supported tags and respective Dockerfile links
The tag of each `spring-cloud` docker image is consist of the version of `spring-cloud` and the version of basic image. The details are as follows

| Tag                                                                                                                                   | Currently                                     | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|---------------|
| [4.3.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/spring-cloud/4.3.0/24.03-lts-sp1/Dockerfile) | Spring Cloud 4.3.0 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/spring-cloud` image from docker

    ```
    docker pull openeuler/spring-cloud:{Tag}
    ```
    
- Spring Cloud Netflix Eureka Client Starter Example

    When you use:
    ```
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <atifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
    </dependency>
    ```
    this starter pulls in:
    * `spring-cloud-commons`
    * `spring-cloud-netflix-eureka-client`

    The Netflix Eureka Client implements interfaces defined in spring-cloud-commons:

    | Abstraction (`spring-cloud-commons`) | Eureka Implementation (`spring-cloud-netflix-eureka-client`) |
    |--------------------------------------|--------------------------------------------------------------|
    | `DiscoveryClient`                    | `EurekaDiscoveryClient`                                      |
    | `ServiceInstance`                    | `EurekaServiceInstance`                                      |
    | `ServiceRegistry`                    | `EurekaServiceRegistry`                                      |
    | `AutoServiceRegistration`            | `EurekaAutoServiceRegistration`                              |
    | `HealthIndicator`                    | `EurekaHealthIndicator`                                      |


- Example code

    ```
    @SpringBootApplication
    @EnableDiscoveryClient  // enables DiscoveryClient from spring-cloud-commons
    public class MyApp {
      public static void main(String[] args) {
        SpringApplication.run(MyApp.class, args);
      }
    }
    
    @RestController
    public class HelloController {
    
      @Autowired
      private DiscoveryClient discoveryClient; // spring-cloud-commons
    
      @Autowired
      private RestTemplate restTemplate;
    
      @Bean
      @LoadBalanced // spring-cloud-commons
      public RestTemplate restTemplate() {
        return new RestTemplate();
      }
    
      @GetMapping("/call")
      public String callUserService() {
        // Uses EurekaDiscoveryClient under the hood
        List<ServiceInstance> instances = discoveryClient.getInstances("user-service");
        // Uses load balancer + Eureka for client-side discovery
        return restTemplate.getForObject("http://user-service/hello", String.class);
      }
    }
    ```
 
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).