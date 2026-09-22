# Quick reference

- The official Perl docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# Perl | openEuler
Current Perl docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Perl is a general-purpose programming language originally developed for text manipulation and now used for a wide range of tasks including system administration, web development, network programming, GUI development, and more.

The language is intended to be practical (easy to use, efficient, complete) rather than beautiful (tiny, elegant, minimal). Its major features are that it's easy to use, supports both procedural and object-oriented (OO) programming, has powerful built-in support for text processing, and has one of the world's most impressive collections of third-party modules.

Learn more on [The Perl Programming Language - www.perl.org](https://www.perl.org/).

# Supported tags and respective Dockerfile links
The tag of each Perl docker image is consist of the version of Perl and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[5.45.2-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/perl/5.45.2/24.03-lts-sp4/Dockerfile) | perl 5.45.2 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/perl` image from docker

	```bash
	docker pull openeuler/perl:{Tag}
	```

- Run a Perl one-liner

	```bash
	docker run --rm openeuler/perl:{Tag} perl -e 'print "Hello, Perl!\n"'
	```

- Run a Perl script

	Create a file named `hello.pl`:

	```perl
	print "Hello, Perl!\n";
	```

	Then run it with the current directory mounted:

	```bash
	docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp openeuler/perl:{Tag} perl hello.pl
	```

- Start an interactive Perl container

	```bash
	docker run -it --name my-perl openeuler/perl:{Tag}
	```

- View container running logs

	```bash
	docker logs -f my-perl
	```

- To get an interactive shell

	```bash
	docker exec -it my-perl /bin/bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
