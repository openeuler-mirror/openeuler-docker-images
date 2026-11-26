# Quick reference

- The official trinity docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# trinity | openEuler

Trinity, developed at the Broad Institute and the Hebrew University of Jerusalem, represents a novel method for the efficient and robust de novo reconstruction of transcriptomes from RNA-seq data. Trinity combines three independent software modules: Inchworm, Chrysalis, and Butterfly, applied sequentially to process large volumes of RNA-seq reads.

Learn more on [Trinity](https://github.com/trinityrnaseq/trinityrnaseq/wiki).

# Supported tags and respective Dockerfile links

The tag of each `trinity` docker image is consist of the version of `trinity` and the version of basic image. The details are as follows

| Tags | Currently | Architectures |
|------|-----------|---------------|
| [2.16.3-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/trinity/2.16.3/24.03-lts-sp4/Dockerfile) | Trinity 2.16.3 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

This image provides Trinity, a software package for de novo transcriptome assembly from RNA-Seq data. Mount your data directory and run Trinity as a normal command-line tool.

- Pull the `openeuler/trinity` image from docker

	```bash
	docker pull openeuler/trinity:{Tag}
	```

- Assemble paired-end RNA-Seq reads

	```bash
	docker run -it --rm -v $(pwd):/data -w /data openeuler/trinity:{Tag} Trinity --seqType fq --left reads_1.fq --right reads_2.fq --CPU 6 --max_memory 20G
	```

	The assembled transcripts are written to `trinity_out_dir.Trinity.fasta` alongside the output directory.

- Assemble single-end RNA-Seq reads

	```bash
	docker run -it --rm -v $(pwd):/data -w /data openeuler/trinity:{Tag} Trinity --seqType fq --single reads.fq --CPU 6 --max_memory 20G
	```

- View container running logs

	```bash
	docker logs -f my-trinity
	```

- To get an interactive shell

	```bash
	docker exec -it my-trinity /bin/bash
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
