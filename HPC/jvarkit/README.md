# Quick reference

- The official jvarkit docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# jvarkit | openEuler
JVARKIT is a set of Java utilities for Bioinformatics.

Since 2023, most tools (but not all) are now packaged into one application `jvarkit.jar`. Tools that were executed like `java -jar toolname.jar` are now executed as `java -jar jvarkit.jar toolname`. The documentation is not always up to date on this point.

Learn more on [Jvarkit : Java utilities for Bioinformatics](https://jvarkit.readthedocs.io/).

# Supported tags and respective Dockerfile links
The tag of each jvarkit docker image is consist of the version of jvarkit and the version of basic image. The details are as follows:
| Tags | Currently | Architectures |
|------|-----------|---------------|
|[2026.04.30-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/jvarkit/2026.04.30/24.03-lts-sp4/Dockerfile) | jvarkit 2026.04.30 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage
To pull the jvarkit image from the Docker Hub:

	```
	docker pull openeuler/jvarkit:{Tag}
	```

To start an interactive shell in the jvarkit environment:

	```
	docker run -it --rm openeuler/jvarkit:{Tag} /bin/bash
	```

The central `jvarkit.jar` is installed at `/opt/jvarkit/dist/jvarkit.jar`. Run it without arguments or with `--help` to list the available tools and options:

	```
	docker run --rm openeuler/jvarkit:{Tag} java -jar /opt/jvarkit/dist/jvarkit.jar --help
	```

Run a jvarkit tool on files in the current working directory, for example print the first variants of `input.vcf`:

	```
	docker run --rm -v $(pwd):/data -w /data openeuler/jvarkit:{Tag} java -jar /opt/jvarkit/dist/jvarkit.jar vcfhead input.vcf
	```

Inspect the logs of a running jvarkit container:

	```
	docker logs <container-name>
	```

Execute a command inside a running jvarkit container:

	```
	docker exec -it <container-name> bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
