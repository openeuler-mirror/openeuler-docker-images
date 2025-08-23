# Quick reference

- The official Splitter docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Splitter | openEuler
Splitter is a core utility for creating openEuler's distroless images. It works by analyzing RPM packages and breaking them down into minimal, functional units called "slices," based on rules defined in the [slice-releases](https://gitee.com/openeuler/slice-releases) repository. By building images from these fine-grained slices instead of whole RPMs, the final container images are significantly smaller and more secure, containing only the absolute necessary components to run an application.

Learn more about Splitter on [Splitter repository](https://gitee.com/openeuler/splitter).

# Supported tags and respective Dockerfile links
The tag of each `splitter` docker image is consist of the version of `splitter` and the version of basic image. The details are as follows

|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.0.3-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/splitter/1.0.3/24.03-lts/Dockerfile)| Splitter 1.0.3 on openEuler 24.03-LTS | amd64, arm64 |
|[1.0.3-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/splitter/1.0.3/24.03-lts-sp1/Dockerfile)| Splitter 1.0.3 on openEuler 24.03-LTS-sp1 | amd64, arm64 |
|[1.0.3-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/splitter/1.0.3/24.03-lts-sp2/Dockerfile)| Splitter 1.0.3 on openEuler 24.03-LTS-sp2 | amd64, arm64 |
|[1.0.1-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/splitter/1.0.1/24.03-lts/Dockerfile)| Splitter 1.0.1 on openEuler 24.03-LTS | amd64, arm64 |
|[1.0.1-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/splitter/1.0.1/24.03-lts-sp1/Dockerfile)| Splitter 1.0.1 on openEuler 24.03-LTS-sp1 | amd64, arm64 |
|[1.0.1-oe2403sp2](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/splitter/1.0.1/24.03-lts-sp2/Dockerfile)| Splitter 1.0.1 on openEuler 24.03-LTS-sp2 | amd64, arm64 |

# Usage

The `openeuler/splitter` image is designed to be used as a command-line tool. You can run `splitter` commands directly via `docker run`, mounting a host directory to retrieve the output slices.

- **Pull the image**

  First, pull the desired image tag to your local machine:

  ```bash
  docker pull openeuler/splitter:{Tag}
  ```

- **Generate Slices (`cut` command)**

  This is the primary way to use the image. The following example demonstrates how to use the `splitter cut` command to generate the `python3_standard` slice for openEuler 24.03-LTS (x86_64) and save it to your current directory.

  1.  **Prepare an output directory on your host:**

      ```bash
      mkdir -p ./output
      ```

  2.  **Run the `splitter cut` command:**

      ```bash
      docker run \
        -v "$(pwd)/output":/output \
        --rm \
        openeuler/splitter:{Tag} \
        /bin/bash -c "splitter cut -r 24.03-LTS -a x86_64 -o /output python3_standard"
      ```

  **Explanation of the command:**
  *   `-v "$(pwd)/output":/output`: Mounts the `./output` directory from your host into the `/output` directory inside the container. This is where the generated slices will be saved.
  *   `--rm`: Automatically removes the container after the command finishes.
  *   `/bin/bash -c "..."`: Executes the `splitter cut` command inside the container.
  *   `-o /output`: Tells `splitter` to place the results in the `/output` directory, which is mapped back to your host.

  After the command completes, you will find the generated slice packages in the `./output` directory on your host.

- **Generate SDF Files (`gen` command)**

  For developers wanting to create new slicing rules, the `splitter gen` command can generate a SDF file for a specific RPM package.
  
  1.  **Prepare an output directory on your host (you can reuse the same one):**
      ```bash
      mkdir -p ./output
      ```

  2.  **Run the `splitter gen` command:**
      ```bash
      docker run \
        -v "$(pwd)/output":/output \
        --rm \
        openeuler/splitter:{Tag} \
        /bin/bash -c "dnf install -y brotli && splitter gen -r 24.03-LTS -a x86_64 -o /output -p brotli"
      ```
  **Explanation:**
  *   The `splitter gen` command requires the target package to be installed within the container to analyze its file contents. The example command handles this by running `dnf install -y brotli` first.
  *   `-p brotli`: Specifies the package for which to generate the SDF.
  *   The generated SDF file (e.g., `brotli.yaml`) will be saved in your host's `./output` directory.

- **Verify Installation or Get Help**

  You can run `splitter` without any arguments or with `--help` to see the available options:

  ```bash
  docker run --rm openeuler/splitter:{Tag} /bin/bash -c "splitter --help"
  ```

- **Run with an Interactive Shell**

  For debugging or exploration, you can also start an interactive shell inside the container:

  ```bash
  docker run -it --rm openeuler/splitter:{Tag} bash
  ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).