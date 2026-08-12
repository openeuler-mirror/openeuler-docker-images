# Quick reference

- The official SURVIVOR docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# survivor | openEuler

SURVIVOR is a tool set for simulating/evaluating SVs, merging and comparing SVs within and among samples, and includes various methods to reformat or summarize SVs.

Learn more on [SURVIVOR](https://github.com/fritzsedlazeck/SURVIVOR).

# Supported tags and respective Dockerfile links

The tag of each `survivor` docker image is consist of the version of `survivor` and the version of basic image. The details are as follows

| Tags | Currently | Architectures |
|------|-----------|---------------|
| [1.0.6-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/survivor/1.0.6/24.03-lts-sp4/Dockerfile) | SURVIVOR 1.0.6 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

Here, users can select the corresponding `{Tag}` by requirements.

- Pull the `openeuler/survivor` image from docker

	```bash
	docker pull openeuler/survivor:{Tag}
	```

- Start an interactive survivor instance

	```bash
	docker run -it --name my-survivor openeuler/survivor:{Tag}
	```

- Merge and compare SVs across VCF files. First collect all VCF files to merge in a file, then use `SURVIVOR merge` with a maximum allowed distance of 1kb and a minimum support of 2 callers that must agree on the type and strand of the SV

	```bash
	ls *.vcf > /data/vcf_files.txt
	docker run --rm -v /path/to/data:/data openeuler/survivor:{Tag} SURVIVOR merge /data/vcf_files.txt 1000 2 1 1 0 30 /data/merged.vcf
	```

- Check the logs of the running container

	```bash
	docker logs -f my-survivor
	```

- Execute a SURVIVOR command in the running container

	```bash
	docker exec -it my-survivor SURVIVOR
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
