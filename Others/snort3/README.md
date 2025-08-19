# Quick reference

- The official snort3 docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# snort3 | openEuler
Current snort3 docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Snort 3 is the next generation Snort IPS (Intrusion Prevention System).

# Supported tags and respective Dockerfile links
The tag of each `snort3` docker image is consist of the version of `snort3` and the version of basic image. The details are as follows

| Tag                                                                                                                             | Currently                              | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [3.7.2.0-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/snort3/3.7.2.0/24.03-lts-sp1/Dockerfile) | Snort3 3.7.2.0 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
- Pull the `openeuler/snort3` image from docker

	```bash
	docker pull openeuler/snort3:latest
	```

- Start a snort3 instance

    ```
    docker run -it openeuler/snort3:latest
    ```

    Please use `snort --help` to display the details
    ```
    Snort has several options to get more help:

    -? list command line options (same as --help)
    --help this overview of help
    --help-commands [<module prefix>] output matching commands
    --help-config [<module prefix>] output matching config options
    --help-counts [<module prefix>] output matching peg counts
    --help-limits print the int upper bounds denoted by max*
    --help-module <module> output description of given module
    --help-modules list all available modules with brief help
    --help-modules-json dump description of all available modules in JSON format
    --help-plugins list all available plugins with brief help
    --help-options [<option prefix>] output matching command line options
    --help-signals dump available control signals
    --list-buffers output available inspection buffers
    --list-builtin [<module prefix>] output matching builtin rules
    --list-gids [<module prefix>] output matching generators
    --list-modules [<module type>] list all known modules
    --list-plugins list all known modules
    --show-plugins list module and plugin versions

    --help* and --list* options preempt other processing so should be last on the
    command line since any following options are ignored.  To ensure options like
    --markup and --plugin-path take effect, place them ahead of the help or list
    options.

    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).