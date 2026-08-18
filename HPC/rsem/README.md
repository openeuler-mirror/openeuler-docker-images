# Quick reference

- The official rsem docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitcode.com/openeuler/cloudnative), [openEuler](https://gitcode.com/openeuler/community).
# rsem | openEuler
RSEM is a software package for estimating gene and isoform expression levels from RNA-Seq data. The RSEM package provides an user-friendly interface, supports threads for parallel computation of the EM algorithm, single-end and paired-end read data, quality scores, variable-length reads and RSPD estimation. In addition, it provides posterior mean and 95% credibility interval estimates for expression levels. For visualization, It can generate BAM and Wiggle files in both transcript-coordinate and genomic-coordinate. Genomic-coordinate files can be visualized by both UCSC Genome browser and Broad Institute's Integrative Genomics Viewer (IGV). Transcript-coordinate files can be visualized by IGV. RSEM also has its own scripts to generate transcript read depth plots in pdf format. The unique feature of RSEM is, the read depth plots can be stacked, with read depth contributed to unique reads shown in black and contributed to multi-reads shown in red. In addition, models learned from data can also be visualized. Last but not least, RSEM contains a simulator.


# Supported tags and respective Dockerfile links
The tag of each rsem docker image is consist of the version of rsem and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.3.3-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/HPC/rsem/1.3.3/24.03-lts-sp4/Dockerfile) | rsem 1.3.3 on openEuler 24.03-lts-sp4 | amd64, arm64 |


# Usage
This image provides the RSEM software package for estimating gene and isoform expression levels from RNA-Seq data. Mount your data directory and run RSEM as a normal command-line tool.

- Pull the `openeuler/rsem` image from docker

	```bash
	docker pull openeuler/rsem:{Tag}
	```

- Prepare reference sequences for RSEM

	The command below extracts reference transcripts from a genome given its gene annotations in a GTF file and builds Bowtie indices:

	```bash
	docker run -it --rm -v $(pwd):/data -w /data openeuler/rsem:{Tag} rsem-prepare-reference --gtf mm9.gtf --transcript-to-gene-map knownIsoforms.txt --bowtie /data/mm9 /ref/mouse_0
	```

- Calculate expression values

	```bash
	docker run -it --rm -v $(pwd):/data -w /data openeuler/rsem:{Tag} rsem-calculate-expression --phred64-quals --fragment-length-mean 150.0 --fragment-length-sd 35.0 -p 8 --output-genome-bam --calc-ci --ci-memory 1024 /data/mmliver.fq /ref/mouse_0 mmliver_single_quals
	```

- Simulate RNA-Seq data

	```bash
	docker run -it --rm -v $(pwd):/data -w /data openeuler/rsem:{Tag} rsem-simulate-reads /ref/mouse_0 mmliver_single_quals.stat/mmliver_single_quals.model mmliver_single_quals.isoforms.results 0.2 50000000 simulated_reads
	```

- View container running logs

	```bash
	docker logs -f my-rsem
	```

- To get an interactive shell

	```bash
	docker exec -it my-rsem /bin/bash
	```

Learn more on the [RSEM](https://deweylab.github.io/RSEM/).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitcode.com/openeuler/openeuler-docker-images).
