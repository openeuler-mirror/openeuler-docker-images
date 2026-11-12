# Quick reference

- DeepSeek Harness (DSH) is DeepSeek AI's open-source agent harness ("everything is a plugin").

- Maintained by: [unac](https://atomgit.com/unac)

- Where to get help: [deepseek-harness issues](https://github.com/deepseek-ai/deepseek-harness/issues)

# DSH | openEuler

DeepSeek Harness (`dsh`) is an open-source agent harness built on an everything-is-a-plugin
architecture. This image packages the `dsh` CLI and its Web UI on openEuler.

# Supported tags and respective Dockerfile links

| Tags | Currently | Architectures |
|--|--|--|
| [0.2.1-rc.5-oe2403sp4](0.2.1-rc.5/24.03-lts-sp4/Dockerfile) | DSH 0.2.1-rc.5 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

```bash
docker pull openeuler/dsh:0.2.1-rc.5-oe2403sp4

docker run -d --name dsh \
  --network host \
  -v dsh-data:/root/.dsh \
  -v "$PWD/workspace:/workspace" \
  openeuler/dsh:0.2.1-rc.5-oe2403sp4

docker logs dsh | grep -m1 'token='
```

Open the printed URL on the host (`http://127.0.0.1:3080/?token=...`).

## Sandboxed command execution

DSH uses bubblewrap as its command sandbox backend (the openEuler kernel ships without
Landlock). Containers that need sandboxed tool execution should add:

```bash
--cap-add SYS_ADMIN \
--security-opt apparmor=unconfined \
--security-opt seccomp=unconfined
```

## Notes

- The Web UI binds to `127.0.0.1` only; use an SSH tunnel (`ssh -L 3080:127.0.0.1:3080 <host>`)
  or a reverse proxy for remote access.
- A one-time token URL is printed at startup; it changes on every restart.

# Question and answering

Please open issues at https://github.com/deepseek-ai/deepseek-harness/issues
