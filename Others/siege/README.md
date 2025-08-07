# Quick reference

- The official siege docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Siege | openEuler
Current siege docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

Siege is an open source regression test and benchmark utility. It can stress test a single URL with a user defined number of simulated users, or it can read many URLs into memory and stress them simultaneously

# Supported tags and respective Dockerfile links
The tag of each `siege` docker image is consist of the version of `siege` and the version of basic image. The details are as follows

| Tag                                                                                                                             | Currently                              | Architectures |
|---------------------------------------------------------------------------------------------------------------------------------|----------------------------------------|---------------|
| [4.1.7-oe2403sp1](https://gitee.com/openeuler/openeuler-docker-images/blob/master/Others/siege/4.1.7/24.03-lts-sp1/Dockerfile) | Siege 4.1.7 on openEuler 24.03-LTS-SP1 | amd64, arm64  |

# Usage
- Pull the `openeuler/siege` image from docker

	```bash
	docker pull openeuler/siege:latest
	```

- Start a siege instance

    ```
    docker run -it openeuler/siege:latest
    ```
    You can now run tasks by following commands
    ```
    Usage: siege [options]
       siege [options] URL
       siege -g URL
    Options:
    -V, --version             VERSION, prints the version number.
    -h, --help                HELP, prints this section.
    -C, --config              CONFIGURATION, show the current config.
    -v, --verbose             VERBOSE, prints notification to screen.
    -q, --quiet               QUIET turns verbose off and suppresses output.
    -g, --get                 GET, pull down HTTP headers and display the
                                transaction. Great for application debugging.
    -p, --print               PRINT, like GET only it prints the entire page.
    -c, --concurrent=NUM      CONCURRENT users, default is 10
    -r, --reps=NUM            REPS, number of times to run the test.
    -t, --time=NUMm           TIMED testing where "m" is modifier S, M, or H
                                ex: --time=1H, one hour test.
    -d, --delay=NUM           Time DELAY, random delay before each request
    -b, --benchmark           BENCHMARK: no delays between requests.
    -i, --internet            INTERNET user simulation, hits URLs randomly.
    -f, --file=FILE           FILE, select a specific URLS FILE.
    -R, --rc=FILE             RC, specify an siegerc file
    -l, --log[=FILE]          LOG to FILE. If FILE is not specified, the
                                default is used: PREFIX/var/siege.log
    -m, --mark="text"         MARK, mark the log file with a string.
                                between .001 and NUM. (NOT COUNTED IN STATS)
    -H, --header="text"       Add a header to request (can be many)
    -A, --user-agent="text"   Sets User-Agent in request
    -T, --content-type="text" Sets Content-Type in request
    -j, --json-output         JSON OUTPUT, print final stats to stdout as JSON
        --no-parser           NO PARSER, turn off the HTML page parser
        --no-follow           NO FOLLOW, do not follow HTTP redirects

    ```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).