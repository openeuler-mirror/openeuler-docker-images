# Quick reference

- The official lumpy-sv container image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).
# lumpy-sv | openEuler
Current lumpy-sv docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

lumpy-sv is a general probabilistic framework for structural variant discovery. 

Learn more on [lumpy-sv website](https://github.com/arq5x/lumpy-sv).


# Supported tags and respective Dockerfile links
The tag of each lumpy-sv container image is consist of the version of lumpy-sv and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|------|-----------|---------------|
|[0.3.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/lumpy-sv/0.3.1/24.03-lts-sp1/Dockerfile)| lumpy-sv 0.3.1 on openEuler 24.03-LTS-SP1 | amd64, arm64 |


# Usage
- Pull the `openeuler/lumpy-sv` image from `hub.docker.com`
	```
	docker pull openeuler/lumpy-sv:{Tag}
	```
- Start a `lumpy-sv` instance
	```
	docker run -it --name my-lumpy-sv openeuler/lumpy-sv:{Tag}
	```

    Now, you can use lumpy by your requirements.

    Flexible and customizable breakpoint detection for advanced users.
    ```
    usage:    lumpy [options]
    ```
    **Options**
    ```
        -g       Genome file (defines chromosome order)
        -e       Show evidence for each call
        -w       File read windows size (default 1000000)
        -mw      minimum weight across all samples for a call
        -msw     minimum per-sample weight for a call
        -tt      trim threshold
        -x       exclude file bed file
        -t       temp file prefix, must be to a writeable directory
        -P       output probability curve for each variant
        -b       output as BEDPE instead of VCF

        -sr      bam_file:<file name>,
                id:<sample name>,
                back_distance:<distance>,
                min_mapping_threshold:<mapping quality>,
                weight:<sample weight>,
                min_clip:<minimum clip length>,
                read_group:<string>

        -pe      bam_file:<file name>,
                id:<sample name>,
                histo_file:<file name>,
                mean:<value>,
                stdev:<value>,
                read_length:<length>,
                min_non_overlap:<length>,
                discordant_z:<z value>,
                back_distance:<distance>,
                min_mapping_threshold:<mapping quality>,
                weight:<sample weight>,
                read_group:<string>

        -bedpe   bedpe_file:<bedpe file>,
                id:<sample name>,
                weight:<sample weight>
    ```
# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).