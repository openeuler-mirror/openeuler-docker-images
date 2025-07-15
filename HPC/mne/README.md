# Quick reference

- The official MNE-Python docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# MNE-Python | openEuler
Current MNE-Python docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

MNE-Python is an open-source Python package for exploring, visualizing, and analyzing human neurophysiological data such as MEG, EEG, sEEG, ECoG, and more. It includes modules for data input/output, preprocessing, visualization, source estimation, time-frequency analysis, connectivity analysis, machine learning, statistics, and more.

Learn more on [MNE-Python Documentation](https://mne.tools/stable/documentation/index.html).

# Supported tags and respective Dockerfile links
The tag of each mne docker image is consist of the version of mne and the version of basic image. The details are as follows

| Tags                                                                                                                      | Currently                                   | Architectures |
|---------------------------------------------------------------------------------------------------------------------------|---------------------------------------------|---------------|
| [1.9.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/HPC/mne/1.9.0/24.03-lts-sp1/Dockerfile) | MNE-Python 1.9.0 on openEuler 24.03-LTS-SP1 | amd64, arm64  |


# Usage
Here, users can select the corresponding `{Tag}` and `container startup options` based on their requirements.

- Pull the `openeuler/mne` image from `hub.docker.com`

	```bash
	docker pull openeuler/mne:{Tag}
	```

- Run with an interactive shell

    You can also start the container with an interactive shell to use mne.
    ```
    docker run -it --rm openeuler/mne:{Tag} bash
    ```
  
- A minimal example showing how to load MNE's built-in sample MEG dataset

    The `test_mne.py` script will load the raw MEG file `sample_audvis_raw.fif`.
	```
	import mne

	# Set the sample data path (downloads it if not present)
	data_path = mne.datasets.sample.data_path()
	raw_fname = str(data_path) + '/MEG/sample/sample_audvis_raw.fif'

	# Load the raw MEG data
	raw = mne.io.read_raw_fif(raw_fname, preload=True)
    ```

- Run the script

    ```
    python3 test_mne.py
    ```
    You will see printed information about the MEG recording: number of channels, sampling rate, duration, etc.

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).