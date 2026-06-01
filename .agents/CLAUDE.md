# openEuler Container Image Contribution — Global Discipline Rules (non-negotiable)

## 1. Directory Structure — MANDATORY
```
<category>/<app-name>/
├── README.md | meta.yml | doc/image-info.yml | doc/picture/logo.png
└── <version>/<oe-version>/Dockerfile
```
Categories: Base, Bigdata, AI, Storage, Database, Cloud, HPC, Others, Distroless. **doc/ is MANDATORY.**

## 2. Version Path — Strip `v` Prefix
Use `1.14.0` not `v1.14.0` in paths, tags, and meta.yml.

## 3. Tag Format: `<app-version>-oe<YY><MM>[sp<N>|lts]`
24.03-lts-sp3→oe2403sp3, 22.03-lts-sp4→oe2203sp4, 22.03-lts→oe2203lts, etc.

## 4. Logo Policy
Search for REAL official logo (GitHub avatar, website favicon, Wikipedia). If none exists, generate white-background PNG with black app name text (Pillow, 400x200px). Never use AI-generated placeholder logos.

## 5. Dependency Version Policy — CRITICAL
- NEVER modify project config files (go.mod, CMakeLists.txt, etc.) to downgrade requirements
- If yum version too old, download official binaries: Go→go.dev, Python→python.org, Rust→rustup, Node.js→nodejs.org
- Any missing dependency: install from official upstream source

## 6. image-list.yml
Add alphabetical entries: `app-name: app-name` under `images:` key.

## 7. Package Name Mappings
libssl-dev→openssl-devel, build-essential→gcc gcc-c++ make, shadow→shadow-utils, python3-dev→python3-devel, libcurl4-openssl-dev→libcurl-devel, libffi-dev→libffi-devel, libpcre3-dev→pcre-devel, libncurses5-dev→ncurses-devel

Packages NOT on openEuler: clang-tools-extra, gmock-devel, gtest-devel, libdwarf-devel, gperftools-devel

## 8. Validation Limitations
- `cd` state lost → use git -C, cmake -S/-B, bash -c
- ARG not shell var → hardcode versions in URLs
- ENV/WORKDIR not effective in docker exec → absolute binary paths
- Shell vars lost across && → bash -c wrapper
- groupadd/useradd may fail → 2>/dev/null || true
- yum remove ONLY wget gcc make (git/cmake cascade to systemd)

## 9. Minimal Change Set
1. Dockerfile (new) 2. README.md (new/updated) 3. meta.yml (new/updated) 4. doc/image-info.yml (new) 5. doc/picture/logo.png (new) 6. image-list.yml (updated)
