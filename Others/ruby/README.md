# Quick reference

- The official Ruby docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Ruby | openEuler
Current Ruby docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Ruby is an interpreted object-oriented programming language often used for web development. It also offers many scripting features to process plain text and serialized files, or manage system tasks. It is simple, straightforward, and extensible.

Learn more on [Ruby Programming Language](https://www.ruby-lang.org/en/).

# Supported tags and respective Dockerfile links
The tag of each Ruby docker image is consist of the version of Ruby and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[4.0.7-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/ruby/4.0.7/24.03-lts-sp4/Dockerfile) | ruby 4.0.7 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/ruby` image from docker

	```bash
	docker pull openeuler/ruby:{Tag}
	```

- Start a Ruby container from the image

	```bash
	docker run -it --name my-ruby openeuler/ruby:{Tag}
	```

- Run a Ruby script inside the container

	```bash
	docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp openeuler/ruby:{Tag} ruby your-daemon-or-script.rb
	```

- View container running logs

	```bash
	docker logs -f my-ruby
	```

- To get an interactive shell

	```bash
	docker exec -it my-ruby /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
