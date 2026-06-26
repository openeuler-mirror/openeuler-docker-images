# Quick reference

- The official tophat docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# tophat | openEuler
TopHat is a fast splice junction mapper for RNA-Seq reads. It aligns RNA-Seq reads to mammalian-sized genomes using the ultra high-throughput short read aligner Bowtie, and then analyzes the mapping results to identify splice junctions between exons.


# Supported tags and respective Dockerfile links
The tag of each tophat docker image is consist of the version of tophat and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.1.2-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/tophat/2.1.2/24.03-lts-sp3/Dockerfile) | tophat 2.1.2 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
This image provides the TopHat spliced read mapper for RNA-Seq alignment.

Align RNA-Seq reads to a reference genome:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/tophat:{Tag} tophat2 -o output_dir reference_genome reads.fastq
```

Run with paired-end reads:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/tophat:{Tag} tophat2 -o output_dir reference_genome reads_1.fastq reads_2.fastq
```

Other available tools:

```
bam2fastx    — convert BAM to FASTQ/FASTA
bam_merge    — merge BAM files
gtf_to_fasta — convert GTF to FASTA
gtf_juncs    — extract junctions from GTF
prep_reads   — prepare reads for alignment
```

Learn more on the [TopHat manual](https://ccb.jhu.edu/software/tophat/manual.shtml).

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).