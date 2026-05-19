# Quick reference

- The official Hefei-NAMD docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Hefei-NAMD | openEuler
Current Hefei-NAMD docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Hefei-NAMD is an ab-initio nonadiabatic molecular dynamics program developed for simulating nonadiabatic processes in molecular systems. It implements surface hopping methods for studying excited state dynamics and electron transfer processes.

# Supported tags and respective Dockerfile links
The tag of each `hefei-namd` docker image is consist of the version of `hefei-namd` and the version of basic image. The details are as follows

| Tag                                                                                                                                   | Currently                                  | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------|---------------|
| [1.0.0-oe2403sp3](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/hefei-namd/1.0.0/24.03-lts-sp3/Dockerfile)      | Hefei-NAMD 1.0.0 on openEuler 24.03-LTS-SP3 | amd64, arm64  |

# Usage
In this usage, users can select the corresponding `{Tag}` based on their requirements.

- Pull the `openeuler/hefei-namd` image from docker

	```bash
	docker pull openeuler/hefei-namd:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use Hefei-NAMD.
    ```
    docker run -it --rm openeuler/hefei-namd:{Tag} bash
    ```

- Run Hefei-NAMD programs

    Hefei-NAMD provides three main executables:
    - `namd`: Nonadiabatic molecular dynamics program
    - `namdk`: K-point version for periodic systems
    - `dish`: Auxiliary tool for data processing

    ```
    namd <input_file>
    namdk <input_file>
    dish <input_file>
    ```

- Run vaspwfc utilities

    vaspwfc tools for processing VASP WAVECAR files:
    - `vaspwfc`: Standard version
    - `vaspwfc_gam`: Gamma-point only version

    ```
    vaspwfc WAVECAR
    vaspwfc_gam WAVECAR
    ```

- Use Python scripts

    Python scripts for nonadiabatic coupling calculations are available in `/opt/Hefei-NAMD/scripts`:
    ```
    cd /opt/Hefei-NAMD/scripts
    python3 nac.py
    python3 Dephase.py
    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).