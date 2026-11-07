# Quick reference

- The official xDiT Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# xDiT | openEuler

Current xDiT docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[xDiT](https://github.com/xdit-project/xDiT) (PyPI package `xfuser`) is a unified parallel inference framework for large-scale diffusion models. It provides tensor parallelism, sequence parallelism (Ulysses) and PipeFusion pipeline parallelism so that text-to-image and text-to-video models such as Stable Diffusion 3 can be generated across multiple NPUs.

This image ships xDiT (`xfuser`) with [torch_npu](https://atomgit.com/ascend/pytorch) so that diffusion pipelines run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/xdit/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the xDiT documentation at [github.com/xdit-project/xDiT](https://github.com/xdit-project/xDiT).

# Supported tags and respective Dockerfile links

The tag of each xDiT docker image consists of the xDiT version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.7.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/xdit/0.7.0-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| xDiT 0.7.0 (xfuser, torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the xdit image
export IMAGE=openeuler/xdit:0.7.0-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name my-xdit \
--device $DEVICE \
--device /dev/davinci_manager \
--device /dev/devmm_svm \
--device /dev/hisi_hdc \
-v /usr/local/dcmi:/usr/local/dcmi \
-v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
-v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
-v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
-v /etc/ascend_install.info:/etc/ascend_install.info \
-v /root/.cache:/root/.cache \
-it $IMAGE bash
```

## Quick start 3: text-to-image on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available())"
python3 -c "from importlib.metadata import version; print('xDiT version:', version('xfuser'))"
```

Generate an image with [SD3 medium](https://modelscope.cn/models/stabilityai/stable-diffusion-3-medium-diffusers) on a single card (the model is about 28 GB and is downloaded from ModelScope automatically). Save the following Python code as `sd3_npu.py`:

```python
import os
import sys
import time

import torch
import torch_npu
from modelscope import snapshot_download
from transformers import T5EncoderModel
from xfuser import xFuserArgs, xFuserStableDiffusion3Pipeline
from xfuser.config import FlexibleArgumentParser
from xfuser.core.distributed import get_runtime_state, get_world_group

model_path = snapshot_download('stabilityai/stable-diffusion-3-medium-diffusers')

parser = FlexibleArgumentParser(description="xFuser SD3 Arguments")
args = xFuserArgs.add_cli_args(parser).parse_args(['--model', model_path] + sys.argv[1:])
engine_args = xFuserArgs.from_cli_args(args)
engine_config, input_config = engine_args.create_config()
local_rank = get_world_group().rank

text_encoder_3 = T5EncoderModel.from_pretrained(
    model_path, subfolder="text_encoder_3", dtype=torch.float16
)
pipe = xFuserStableDiffusion3Pipeline.from_pretrained(
    pretrained_model_name_or_path=model_path,
    engine_config=engine_config,
    dtype=torch.float16,
    text_encoder_3=text_encoder_3,
).to(f"npu:{local_rank}")
pipe.prepare_run(input_config)

torch.npu.synchronize(device=local_rank)
start = time.perf_counter()
output = pipe(
    height=input_config.height,
    width=input_config.width,
    prompt=input_config.prompt,
    num_inference_steps=input_config.num_inference_steps,
    output_type=input_config.output_type,
    guidance_scale=input_config.guidance_scale,
    generator=torch.Generator(device="npu").manual_seed(input_config.seed),
)
torch.npu.synchronize(device=local_rank)
elapsed = time.perf_counter() - start

os.makedirs("results", exist_ok=True)
if pipe.is_dp_last_group():
    world_size = get_world_group().world_size
    path = f"results/sd3_npu{world_size}_ulysses{engine_args.ulysses_degree}.png"
    output.images[0].save(path)
    print(f"inference time: {elapsed:.2f} sec")
    print(f"image saved to {path}")
get_runtime_state().destroy_distributed_env()
```

Run it on a single card with `torchrun`:

```bash
torchrun --nproc_per_node=1 sd3_npu.py --prompt "a tiny test sketch" --height 256 --width 256 --num_inference_steps 1 --seed 42
```

The same script scales to 2 cards with sequence parallelism by adding `--ulysses_degree 2 --attention_backend SDPA` and `--nproc_per_node=2`.

For faster model download in China, use the ModelScope or hf-mirror channel:

```bash
export HF_ENDPOINT=https://hf-mirror.com
# or
pip install modelscope
```

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
