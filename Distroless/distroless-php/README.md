# Quick reference

- The official distroless-php docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# distroless-php | openEuler
This image contains a minimal Linux, php runtime.

PHP is a server-side scripting language designed for web development, but which can also be used as a general-purpose programming language. PHP can be added to straight HTML or it can be used with a variety of templating engines and web frameworks. PHP code is usually processed by an interpreter, which is either implemented as a native module on the web-server or as a common gateway interface (CGI).

# Supported tags and respective Dockerfile links
The tag details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[8.3.19-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-php/8.3.19/24.03-lts/Distrofile)| PHP 8.3.19 on openEuler 24.03-LTS | amd64, arm64 |

# Usage
**Create a Dockerfile in your PHP project**
```
# Dockerfile

FROM openeuler/distroless-php:8.3.19-oe2403lts
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
CMD [ "php", "./your-script.php" ]
```
Then, run the commands to build and run the Docker image:
```
$ docker build -t my-php-app .
$ docker run -it --rm --name my-running-app my-php-app
```

**Run a single PHP script**

For many simple, single file projects, you may find it inconvenient to write a complete Dockerfile. In such cases, you can run a PHP script by using the PHP Docker image directly, for [example](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Distroless/distroless-php/example):
```
$ docker run -it --rm -v $PWD/example:/usr/src/myapp -w /usr/src/myapp openeuler/distroless-php:8.3.19-oe2403lts php test.php
```
The result is
```
测试通过: 2 + 3 = 5
测试通过: -1 + (-1) = -2
测试通过: 整数溢出检测（捕获异常: add(): Return value must be of type int, float returned）
```
	
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).