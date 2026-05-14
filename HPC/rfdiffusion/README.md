# Quick reference

- The official RFdiffusion docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# RFdiffusion | openEuler
Current RFdiffusion docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

RFdiffusion is an open source method for structure generation, with or without conditional information (a motif, target etc). It can perform a whole range of protein design challenges:

- Motif Scaffolding
- Unconditional protein generation
- Symmetric oligomer generation (cyclic, dihedral, tetrahedral)
- Binder design
- Design diversification ("partial diffusion")

Learn more on [RFdiffusion](https://github.com/RosettaCommons/RFdiffusion).

# Supported tags and respective Dockerfile links
The tag of each `rfdiffusion` docker image is consist of the version of `rfdiffusion` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.1.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/rfdiffusion/1.1.0/24.03-lts-sp3/Dockerfile) | RFdiffusion 1.1.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |

# Model Weights
**Note:** This image does not include model weights. You need to download them separately:

```bash
cd /opt/RFdiffusion/models
wget http://files.ipd.uw.edu/pub/RFdiffusion/6f5902ac237024bdd0c176cb93063dc4/Base_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/e29311f6f1bf1af907f9ef9f44b8328b/Complex_base_ckpt.pt
```

For more model weights, see the [RFdiffusion README](https://github.com/RosettaCommons/RFdiffusion).

# Usage
Here, users can select the corresponding `{Tag}` by their requirements.

- Pull the `openeuler/rfdiffusion` image from docker

	```
	docker pull openeuler/rfdiffusion:{Tag}
	```

- Run `rfdiffusion` container

	```
	docker run -it --rm openeuler/rfdiffusion:{Tag}
	```

- Basic unconditional protein generation example

	```bash
	cd /opt/RFdiffusion
	./scripts/run_inference.py 'contigmap.contigs=[150-150]' inference.output_prefix=test_outputs/test inference.num_designs=10
	```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).