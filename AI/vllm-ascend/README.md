<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/vllm-project/vllm-ascend/main/docs/source/logos/vllm-ascend-logo-text-dark.png">
    <img alt="vllm-ascend" src="https://raw.githubusercontent.com/vllm-project/vllm-ascend/main/docs/source/logos/vllm-ascend-logo-text-light.png" width=55%>
  </picture>
</p>

<h3 align="center">
vLLM Ascend Plugin
</h3>

<p align="center">
| <a href="https://www.hiascend.com/en/"><b>About Ascend</b></a> | <a href="https://vllm-ascend.readthedocs.io/en/latest/"><b>Documentation</b></a> | <a href="https://slack.vllm.ai"><b>#sig-ascend</b></a> | <a href="https://discuss.vllm.ai/c/hardware-support/vllm-ascend-support"><b>Users Forum</b></a> | <a href="https://tinyurl.com/vllm-ascend-meeting"><b>Weekly Meeting</b></a> |
</p>

<p align="center">
<a ><b>English</b></a> | <a href="README.zh.md"><b>中文</b></a>
</p>

---
*Latest News* 🔥
- [2025/03] We hosted the [vLLM Beijing Meetup](https://mp.weixin.qq.com/s/VtxO9WXa5fC-mKqlxNUJUQ) with vLLM team! Please find the meetup slides [here](https://drive.google.com/drive/folders/1Pid6NSFLU43DZRi0EaTcPgXsAzDvbBqF).
- [2025/02] vLLM community officially created [vllm-project/vllm-ascend](https://github.com/vllm-project/vllm-ascend) repo for running vLLM seamlessly on the Ascend NPU.
- [2024/12] We are working with the vLLM community to support [[RFC]: Hardware pluggable](https://github.com/vllm-project/vllm/issues/11162).
---
## Overview

vLLM Ascend (`vllm-ascend`) is a community maintained hardware plugin for running vLLM seamlessly on the Ascend NPU.

It is the recommended approach for supporting the Ascend backend within the vLLM community. It adheres to the principles outlined in the [[RFC]: Hardware pluggable](https://github.com/vllm-project/vllm/issues/11162), providing a hardware-pluggable interface that decouples the integration of the Ascend NPU with vLLM.

By using vLLM Ascend plugin, popular open-source models, including Transformer-like, Mixture-of-Expert, Embedding, Multi-modal LLMs can run seamlessly on the Ascend NPU.

## Prerequisites

- Hardware: Atlas 800I A2 Inference series, Atlas A2 Training series
- OS: Linux
- Software:
  * Python >= 3.9
  * CANN >= 8.0.0
  * PyTorch >= 2.5.1, torch-npu >= 2.5.1.dev20250320
  * vLLM (the same version as vllm-ascend)

## Getting Started

Please refer to [QuickStart](https://vllm-ascend.readthedocs.io/en/latest/quick_start.html) and [Installation](https://vllm-ascend.readthedocs.io/en/latest/installation.html) for more details.

## Contributing
See [CONTRIBUTING](https://vllm-ascend.readthedocs.io/en/main/developer_guide/contributing.html) for more details, which is a step-by-step guide to help you set up development environment, build and test.

We welcome and value any contributions and collaborations:
- Please let us know if you encounter a bug by [filing an issue](https://github.com/vllm-project/vllm-ascend/issues)
- Please use [User forum](https://discuss.vllm.ai/c/hardware-support/vllm-ascend-support) for usage questions and help.

## Branch

vllm-ascend has main branch and dev branch.

- **main**: main branch，corresponds to the vLLM main branch, and is continuously monitored for quality through Ascend CI.
- **vX.Y.Z-dev**: development branch, created with part of new releases of vLLM. For example, `v0.7.3-dev` is the dev branch for vLLM `v0.7.3` version.

Below is maintained branches:

| Branch     | Status       | Note                                 |
|------------|--------------|--------------------------------------|
| main       | Maintained   | CI commitment for vLLM main branch   |
| v0.7.1-dev | Unmaintained | Only doc fixed is allowed |
| v0.7.3-dev | Maintained   | CI commitment for vLLM 0.7.3 version |

Please refer to [Versioning policy](https://vllm-ascend.readthedocs.io/en/main/developer_guide/versioning_policy.html) for more details.

## Weekly Meeting

- vLLM Ascend Weekly Meeting: https://tinyurl.com/vllm-ascend-meeting
- Wednesday, 15:00 - 16:00 (UTC+8, [Convert to your timezone](https://dateful.com/convert/gmt8?t=15))

## License

Apache License 2.0, as found in the [LICENSE](./LICENSE) file.
test