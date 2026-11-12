# Quick reference

- The official rust docker image.

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative).

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community).
# rust | openEuler
This is the main source code repository for Rust. It contains the compiler, standard library, and documentation.

- **Performance:** Fast and memory-efficient, suitable for critical services, embedded devices, and easily integrated with other languages.
- **Reliability:** Our rich type system and ownership model ensure memory and thread safety, reducing bugs at compile-time.
- **Productivity:** Comprehensive documentation, a compiler committed to providing great diagnostics, and advanced tooling including package manager and build tool ([Cargo](https://github.com/rust-lang/cargo)), auto-formatter ([rustfmt](https://github.com/rust-lang/rustfmt)), linter ([Clippy](https://github.com/rust-lang/rust-clippy)) and editor support ([rust-analyzer](https://github.com/rust-lang/rust-analyzer)).

Learn more on [Rust Programming Language](https://www.rust-lang.org/).


# Supported tags and respective Dockerfile links
The tag of each rust docker image is consist of the version of rust and the version of basic image. The details are as follows
| Tags | Currently |  Architectures|
|--|--|--|
|[1.99.1-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/rust/1.99.1/24.03-lts-sp4/Dockerfile) | rust 1.99.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.99.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/rust/1.99.0/24.03-lts-sp4/Dockerfile) | rust 1.99.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.98.1-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/rust/1.98.1/24.03-lts-sp4/Dockerfile) | rust 1.98.1 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.96.0-oe2403sp4](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/rust/1.96.0/24.03-lts-sp4/Dockerfile) | rust 1.96.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |
|[1.96.0-oe2403sp3](https://gitcode.com/openeuler/openeuler-docker-images/blob/master/Others/rust/1.96.0/24.03-lts-sp3/Dockerfile) | rust 1.96.0 on openEuler 24.03-LTS-SP3 | amd64, arm64 |
|[1.95.0-oe2403sp3](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/Others/rust/1.95.0/24.03-lts-sp3/Dockerfile) | rust 1.95.0 on openEuler 24.03-lts-sp3 | amd64, arm64 |


# Usage

> **Note:** Rust is installed with rustup, so the toolchain is located in `/root/.cargo/bin`. This directory is not on the default `PATH` when a command is passed directly to `docker run`, so source `$HOME/.cargo/env` before running cargo commands (an interactive `bash` shell does this automatically).

## Start a Rust development environment

```bash
docker run -it openeuler/rust:{Tag} bash
```

## Create and run a new Rust project

```bash
docker run -it --rm -v $(pwd):/workspace -w /workspace openeuler/rust:{Tag} bash -c 'source $HOME/.cargo/env && cargo init && cargo run'
```

For an existing Rust project (a directory that already contains a `Cargo.toml`), drop `cargo init &&`:

```bash
docker run -it --rm -v $(pwd):/workspace -w /workspace openeuler/rust:{Tag} bash -c 'source $HOME/.cargo/env && cargo run'
```

# Question and answering
If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).