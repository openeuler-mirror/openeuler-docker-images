# Quick reference

- The official ProteinMPNN docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# ProteinMPNN | openEuler

ProteinMPNN is a deep learning-based protein sequence design method. It generates protein sequences that fold into given backbone structures with high accuracy.

Learn more on [ProteinMPNN GitHub](https://github.com/dauparas/ProteinMPNN).

# Supported tags and respective Dockerfile links

The tag of each `proteinmpnn` docker image is consist of the version of `proteinmpnn` and the version of basic image. The details are as follows

| Tag                                                                                                                                  | Currently                                  | Architectures |
|--------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------|---------------|
| [1.0.1-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/proteinmpnn/1.0.1/24.03-lts-sp3/Dockerfile)   | ProteinMPNN 1.0.1 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Usage

In this usage, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/proteinmpnn` image from docker

	```bash
	docker pull openeuler/proteinmpnn:{Tag}
	```

- Start a ProteinMPNN instance

	```bash
	docker run -it --rm openeuler/proteinmpnn:{Tag} bash
	```

- Run a simple example

	```bash
	# Inside the container
	cd /opt/ProteinMPNN

	# Step 1: Parse PDB files to jsonl format
	python3 helper_scripts/parse_multiple_chains.py \
		--input_path inputs/PDB_monomers/pdbs/ \
		--output_path parsed_pdbs.jsonl

	# Step 2: Run protein sequence design
	python3 protein_mpnn_run.py \
		--jsonl_path parsed_pdbs.jsonl \
		--out_folder outputs/ \
		--num_seq_per_target 2 \
		--sampling_temp "0.1"
	```

- Design with custom PDB files

	```bash
	# Mount local directory and run
	docker run -it --rm -v /path/to/pdbs:/pdbs openeuler/proteinmpnn:{Tag} bash

	# Inside the container, parse and design
	cd /opt/ProteinMPNN
	python3 helper_scripts/parse_multiple_chains.py \
		--input_path /pdbs/ \
		--output_path /pdbs/parsed_pdbs.jsonl

	python3 protein_mpnn_run.py \
		--jsonl_path /pdbs/parsed_pdbs.jsonl \
		--out_folder /pdbs/outputs/ \
		--num_seq_per_target 10
	```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).