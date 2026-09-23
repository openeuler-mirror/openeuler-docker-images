# Quick reference

- The official PHP docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# PHP | openEuler
Current PHP docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

PHP is a popular general-purpose scripting language that is especially suited to web development. Fast, flexible and pragmatic, PHP powers everything from your blog to the most popular websites in the world.

Learn more on [PHP](https://www.php.net/).

# Supported tags and respective Dockerfile links
The tag of each PHP docker image is consist of the version of PHP and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[8.5.10-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/php/8.5.10/24.03-lts-sp4/Dockerfile) | php 8.5.10 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/php` image from docker

	```bash
	docker pull openeuler/php:{Tag}
	```

- Start a PHP container from the image

	```bash
	docker run -it --name my-php openeuler/php:{Tag}
	```

- Run a PHP script inside the container

	```bash
	docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp openeuler/php:{Tag} php your-script.php
	```

- View container running logs

	```bash
	docker logs -f my-php
	```

- To get an interactive shell

	```bash
	docker exec -it my-php /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
