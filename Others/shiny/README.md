# Quick reference

- The official shiny docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# shiny | openEuler
Current shiny docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Easily build rich and productive interactive web apps in R — no HTML/CSS/JavaScript required.

Learn more on [Shiny](https://shiny.posit.co/).

# Supported tags and respective Dockerfile links
The tag of each shiny docker image is consist of the version of shiny and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.15.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/shiny/1.15.0/24.03-lts-sp4/Dockerfile) | shiny 1.15.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/shiny` image from docker

	```bash
	docker pull openeuler/shiny:{Tag}
	```

- Start an interactive R container

	```bash
	docker run -it --name my-shiny openeuler/shiny:{Tag}
	```

- Run a Shiny application

	```bash
	docker run -it --rm -p 3838:3838 openeuler/shiny:{Tag} R -e "library(shiny); runExample('06_tabsets', host='0.0.0.0', port=3838)"
	```

- View container running logs

	```bash
	docker logs -f my-shiny
	```

- To get an interactive shell

	```bash
	docker exec -it my-shiny /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
