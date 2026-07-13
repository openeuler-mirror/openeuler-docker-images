# Quick reference

- The official cufflinks docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# cufflinks | openEuler
Cufflinks assembles transcripts, estimates their abundances, and tests for differential expression and regulation in RNA-Seq samples. It accepts aligned RNA-Seq reads and assembles the alignments into a parsimonious set of transcripts. Cufflinks then estimates the relative abundances of these transcripts based on how many reads support each one.


# Supported tags and respective Dockerfile links
The tag of each cufflinks docker image is consist of the version of cufflinks and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[2.2.1-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/cufflinks/2.2.1/24.03-lts-sp4/Dockerfile) | cufflinks 2.2.1 on openEuler 24.03-lts-sp4 | amd64, arm64 |
|[2.2.1-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/HPC/cufflinks/2.2.1/24.03-lts-sp3/Dockerfile) | cufflinks 2.2.1 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage
This image provides the Cufflinks suite of tools for transcriptome assembly and differential expression analysis.

Run cufflinks on aligned RNA-Seq reads:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/cufflinks:{Tag} cufflinks -o output_dir accepted_hits.bam
```

Run cuffdiff for differential expression analysis:

```
docker run -it --rm -v $(pwd):/data -w /data openeuler/cufflinks:{Tag} cuffdiff -o diff_output transcripts.gtf sample1.bam sample2.bam
```

Other available tools in the image:

```
cuffcompare  — compare assembled transcripts to reference annotation
cuffmerge    — merge assembled transcripts
cuffnorm     — normalize expression levels
cuffquant    — quantify expression levels
gffread      — convert GFF/GTF files
gtf_to_sam   — convert GTF to SAM format
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
