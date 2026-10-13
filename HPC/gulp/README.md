# Quick reference

- The official gulp docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# gulp | openEuler
gulp is a toolkit that helps you automate painful or time-consuming tasks in your development workflow.

Learn more on [gulp.js](https://gulpjs.com/).

# Supported tags and respective Dockerfile links
The tag of each gulp docker image is consist of the version of gulp and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[5.0.1-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/gulp/5.0.1/24.03-lts-sp4/Dockerfile) | gulp 5.0.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
To pull the gulp image from the Docker Hub:

	```
	docker pull openeuler/gulp:{Tag}
	```

To start an interactive shell in the gulp environment:

	```
	docker run -it --rm openeuler/gulp:{Tag} /bin/bash
	```

The image provides Node.js, npm and the gulp CLI. Verify the installation:

	```
	docker run --rm openeuler/gulp:{Tag} gulp --version
	```

Gulp loads the gulp installed in the project being built, so install it as a project dependency in a directory mounted from the host:

	```
	docker run -it --rm -v $(pwd):/workspace -w /workspace openeuler/gulp:{Tag} bash
	npm install --save-dev gulp
	gulp --version
	```

Inspect the logs of a running gulp container:

	```
	docker logs <container-name>
	```

Execute a command inside a running gulp container:

	```
	docker exec -it <container-name> bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
