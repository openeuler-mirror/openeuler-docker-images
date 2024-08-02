# Quick reference

- The official Kselftests-virtme docker image.

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community).

# Kselftests-virtme | openEuler
Current Kselftests-virtme (Kernel self-tests by Virtme) docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

This image provides a virtual environment with Virtme to validate [mptcp_net-next](https://github.com/multipath-tcp/mptcp_net-next) repo and can be used by devs and CI, to replace [mptcp-upstream-virtme-docker](https://github.com/multipath-tcp/mptcp-upstream-virtme-docker) which is based on Ubuntu.

# Supported tags and respective Dockerfile links
The tag of each `kselftests-virtme` docker image is consist of the version of `virtme-ng` and the version of basic image. The details are as follows
|    Tag   |  Currently  |   Architectures  |
|----------|-------------|------------------|
|[1.25-oe2203sp4](https://gitee.com/openeuler/openeuler-docker-images/blob/master/kselftests-virtme/1.25/22.03-lts-sp4/Dockerfile)| Virtme-ng 1.25 on openEuler 22.03-LTS-sp4 | amd64, arm64 |


# Usage

## Entrypoint options

When launching the docker image, you have to specify the mode you want to use:

- `manual-*`: Build the kernel and dependences, start a VM, then leave you with
  a shell prompt inside the VM:
  - `manual-normal`: With a non-debug kernel config.
  - `manual-debug`: With a debug kernel config.
  - `manual-btf`: With BTF support (needed for BPF features).
- `auto-*`: Build the kernel and dependences, start a VM, then run all the
  automatic tests from the VM:
  - `auto-normal`: With a non-debug kernel config.
  - `auto-debug`: With a debug kernel config.
  - `auto-all`: First with a non-debug, then a debug kernel config.
  - `auto-btf`: With BTF support (needed for BPF features).
- `make`: Run the `make` command with optional parameters.
- `make.cross`: Run Intel's `make.cross` command with optional parameters.
- `build`: Build everything, but don't start the VM (`normal` mode by default).
- `defconfig`: Only generate the `.config` file (`normal` mode by default).
- `selftests`: Only build the KSelftests.
- `bpftests`: Only build the BPF tests.
- `cmd`: Run the given command in the docker image (not in the VM), e.g.
  `cmd bash` to have a prompt.
- `static`: Run static analysis, with `make W=1 C=1`.
- `vm-manual`: Start the VM with what has already been built (`normal` mode by
  default).
- `vm-auto`: Start the VM with what has already been built, then run the tests
  (`normal` mode by default).
- `src`: `source` a given script file.
- `help`: display all possible commands.

All the `manual-*` and `auto-*` options accept optional arguments for
`scripts/config` script from the kernel source code, e.g. `-e DEBUG_LOCKDEP`


You can quickly get a ready to use environment:

```bash
cd <kernel source code>
docker run -v "${PWD}:${PWD}:rw" -w "${PWD}" -v "${PWD}/.home:/root:rw" --rm \
  -it --privileged --pull always openeuler/kselftests-virtme:latest \
  <entrypoint options, see above>
```
This docker image needs to be executed with `--privileged` option to be able to
execute QEmu with KVM acceleration.

## Extension

### Files

3 files can be created in the root dir of the kernel source code:

- `.virtme-exec-pre`
- `.virtme-exec-run`
- `.virtme-exec-post`

`pre` and `post` are run before and after the tests' suite. `run` is run instead
of the tests' suite.

These scripts are sourced and can use functions from the virtme script.

### Env vars

Env vars can be set to change the behaviour of the script. When using the Docker
command, you need to specify the `-e` parameter, e.g. to set
`INPUT_BUILD_SKIP=1`:

```bash
docker run -e INPUT_BUILD_SKIP=1 (...) openeuler/kselftests-virtme:latest (...)
```

#### Skip kernel build

If you didn't change the kernel code, it can be useful to skip the compilation
part. You can then set `INPUT_BUILD_SKIP=1` to save a few seconds to start the
VM.

#### Use CLang instead of GCC

Simply set `INPUT_CLANG=1` env var with all the commands you use.

#### Not blocking with questions

You can set `INPUT_NO_BLOCK=1` env var not to block if these files are present.
This is useful if you need to do a `git bisect`.

### Not stop after an error is detected with `run_loop`

You can set `INPUT_RUN_LOOP_CONTINUE=1` env var to continue even if an error is
detected. Failed iterations are logged in `${CONCLUSION}.failed`.

#### Packetdrill

You can set `INPUT_PACKETDRILL_STABLE=1` env var to use the branch for the
current kernel version instead of the dev version following MPTCP net-next.

You can set `INPUT_PACKETDRILL_NO_SYNC=1` env var not to sync Packetdrill with
upstream. This is useful if you mount a local packetdrill repo in the image.

You can also set `INPUT_PACKETDRILL_NO_MORE_TOLERANCE=1` not to increase
Packetdrill's tolerances.

Run the Docker commands directly, you can use:

```bash
docker run \
  -e INPUT_PACKETDRILL_NO_SYNC=1 \
  -e INPUT_PACKETDRILL_NO_MORE_TOLERANCE=1 \
  -v /PATH/TO/packetdrill:/opt/packetdrill:rw \
  -v "${PWD}:${PWD}:rw" -w "${PWD}" -v "${PWD}/.home:/root:rw" \
  --privileged --rm -it \
  openeuler/kselftests-virtme:latest \
  manual

cd /opt/packetdrill/gtests/net/
./packetdrill/run_all.py -lvv -P 2 mptcp/dss ## or any other subdirs
```

If packetdrill itself is modified and to continue to use the same build
environment, the recompilation can also be done from the running docker image:

```bash
docker exec -w /opt/packetdrill/gtests/net/packetdrill -it \
  $(docker ps --filter ancestor=openeuler/kselftests-virtme --format='{{.ID}}') \
    make
```

## Using for other subsystems than MPTCP

This image is used to validate modifications done in MPTCP
Upstream project. But it can also be used to validate other subsystems. Here are
a few tips to use it elsewhere:

- If you only need to run extra steps at the "preparation" phase but keeping the
  same docker image, write them in a `.virtme-prepare-post` file, e.g. to
  compile iproute2 differently.

- Similar to the previous point, you might prefer to extend the docker image not
  to have to install new packages from `.virtme-prepare-post` each time you run
  the docker image. You can use our docker image as a base and then install
  other dependences:
  ```dockerfile
  FROM openeuler/kselftests-virtme:latest

  RUN yum update -y && yum install -y python3-pip && pip3 install scapy-python3
  ```


- Skip the build steps you don't need, e.g.
  ```bash
  docker run (...) \
      -e INPUT_BUILD_SKIP_PERF=1 \
      -e INPUT_BUILD_SKIP_SELFTESTS=1 \
      -e INPUT_BUILD_SKIP_PACKETDRILL=1 \
      (...) \
      openeuler/kselftests-virtme:latest \
      auto-normal
  ```

- Specify the path to another selftests dir to test by using
  `INPUT_SELFTESTS_DIR` env var, e.g.
  ```bash
  docker run (...) \
      -e INPUT_SELFTESTS_DIR=tools/testing/selftests/tc-testing
      (...)
  ```

- Use `.virtme-exec-run` file (and similar) to execute different tests,
  see above.

An example:

```bash
# Better to extend the docker image (but quick solution here), see above:
cat <<'EOF' > ".virtme-prepare-post"
yum update -y && yum install -y python3-pip && pip3 install scapy-python3
EOF

# Only run the selftests
cat <<'EOF' > ".virtme-exec-run"
run_selftest_all
EOF

# skip Packetdrill build (not needed), run TC selftests and add CONFIG_DUMMY
docker run -v "${PWD}:${PWD}:rw" -w "${PWD}" -v "${PWD}/.home:/root:rw" --rm \
  -it --privileged \
  -e INPUT_BUILD_SKIP_PACKETDRILL=1 \
  -e INPUT_SELFTESTS_DIR=tools/testing/selftests/tc-testing \
  --pull always openeuler/kselftests-virtme:latest \
  auto-normal -e DUMMY
```

Feel free to contact us and/or open Pull Requests to support more cases.

## Compilation issues with Perf or Objtools

If you see such messages:

```
Makefile.config:458: *** No gnu/libc-version.h found, please install glibc-dev[el].  Stop.
```

This can happen when switching between major versions of the compiler. In this
case, it will be required to clean the build dir in `.virtme/build`, e.g.

```bash
docker run -v "${PWD}:${PWD}:rw" -w "${PWD}" --rm -it \
  openeuler/kselftests-virtme:latest \
  cmd rm -r .virtme/build*/tools
```

## Working with VSCode

If you use [VSCode for Linux kernel development](https://github.com/FlorentRevest/linux-kernel-vscode)
add-on, you can configure it to use this docker image: simply copy all files
from the [`vscode`](/vscode) directory in your `.vscode` dir from the kernel
source (or use symbolic links). `.clangd` needs to be placed at the root of the
kernel source directory.

Notes:
- The VSCode add-on needs some modifications, see
  [PR #5](https://github.com/FlorentRevest/linux-kernel-vscode/pull/5) and
  [PR #6](https://github.com/FlorentRevest/linux-kernel-vscode/pull/6). If these
  PRs are not merged, you can use
  [this fork](https://github.com/matttbe/linux-kernel-vscode/) (`virtme-support`
  branch) for the moment.
- CLang will be used by VSCode instead of GCC. It is then required to launch all
  docker commands with `-e INPUT_CLANG=1`, see above.
- CLangD will be used on the host machine, not in the Docker.

## CLang Analyzer

In the kernel, it is possible to run `make clang-analyzer`, but it will scan all
compiled files, that's too long, and maybe not needed here. Here is a workaround
to scan only MPTCP files:

```bash
cd <kernel source code>
docker run -v "${PWD}:${PWD}:rw" -w "${PWD}" -v "${PWD}/.home:/root:rw" --rm \
  -e INPUT_CLANG=1 \
  -it --privileged --pull always openeuler/kselftests-virtme:latest \
  build
jq 'map(select(.file | contains ("/mptcp/")))' \
  .virtme/build-clang/compile_commands.json > compile_commands-mptcp.json
docker run -v "${PWD}:${PWD}:rw" -w "${PWD}" -v "${PWD}/.home:/root:rw" --rm \
  -e INPUT_CLANG=1 \
  -it --privileged --pull always openeuler/kselftests-virtme:latest \
  cmd ./scripts/clang-tools/run-clang-tools.py clang-analyzer compile_commands-mptcp.json
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://gitee.com/openeuler/openeuler-docker-images).