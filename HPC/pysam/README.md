# Quick reference

- The official pysam docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).

# pysam | openEuler
Pysam is a python module for reading, manipulating and writing genomic data sets.

Pysam is a wrapper of the [htslib](https://www.htslib.org/) C-API and provides facilities to read and write SAM/BAM/VCF/BCF/BED/GFF/GTF/FASTA/FASTQ files as well as access to the command line functionality of the [samtools](https://www.htslib.org/doc/1.23/samtools.html) and [bcftools](https://www.htslib.org/doc/1.23/bcftools.html) packages. The module supports compression and random access through indexing.

This module provides a low-level wrapper around the htslib C-API as using cython and a high-level, pythonic API for convenient access to the data within genomic file formats.

The current version wraps htslib-1.23.1, samtools-1.23.1, and bcftools-1.23.1.

Learn more on [pysam: htslib interface for python](https://pysam.readthedocs.io/en/v0.24.0/).

# Supported tags and respective Dockerfile links
The tag of each pysam docker image is consist of the version of pysam and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[0.24.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/pysam/0.24.0/24.03-lts-sp4/Dockerfile) | pysam 0.24.0 on openEuler 24.03-lts-sp4 | amd64, arm64 |

# Usage
To pull the pysam image from the Docker Hub:

	```
	docker pull openeuler/pysam:{Tag}
	```

To run the pysam container with an interactive shell:

	```
	docker run -it --rm openeuler/pysam:{Tag} bash
	```

Check the installed pysam version:

	```
	docker run -it --rm openeuler/pysam:{Tag} python3 -c "import pysam; print(pysam.__version__)"
	```

A minimal example showing how to read a SAM/BAM file with pysam:

	```python
	import pysam

	samfile = pysam.AlignmentFile("example.bam", "rb")
	for read in samfile.fetch():
	    print(read.query_name)
	samfile.close()
	```

Run the script from a mounted directory:

	```
	docker run -it --rm -v $(pwd):/data -w /data openeuler/pysam:{Tag} python3 test_pysam.py
	```

Inspect the logs of a running pysam container:

	```
	docker logs <container-name>
	```

Execute a command inside a running pysam container:

	```
	docker exec -it <container-name> bash
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
