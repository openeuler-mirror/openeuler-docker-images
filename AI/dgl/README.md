# Quick reference

- The official DGL Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# DGL | openEuler

Current DGL docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[DGL](https://github.com/dmlc/dgl) is an open source deep learning framework for graph neural networks, providing graph data structures, message passing primitives and GNN modules. [DGL-Ascend](https://github.com/BUPT-GAMMA/dgl-ascend) is the Huawei x BUPT-GAMMA Ascend adaptation of DGL: it adds an NPU backend so graph structures, message passing and model parameters take part in the computation on the Ascend NPU.

This image ships DGL-Ascend built from source with [torch_npu](https://atomgit.com/ascend/pytorch) so that graph workloads run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/dgl/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the DGL documentation at [dgl.ai](https://www.dgl.ai/dgl_docs/).

# Supported tags and respective Dockerfile links

The tag of each DGL docker image consists of the DGL version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[c6c2ee8-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/dgl/c6c2ee8-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| DGL-Ascend c6c2ee8 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the dgl image
export IMAGE=openeuler/dgl:c6c2ee8-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name dgl \
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

## Quick start 3: graph neural networks on Ascend NPU

Load the CANN environment and validate the stack inside the container. The import order matters: always import `torch` and `torch_npu` before `dgl`, because loading `libdgl.so` requires the PyTorch NPU libraries to be already present in the global symbol namespace:

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
python3 -c "import torch, torch_npu, dgl; print('dgl version:', dgl.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
```

Run a minimal NPU message-passing check:

```python
import torch        # 1st
import torch_npu    # 2nd
import dgl          # 3rd
import dgl.function as fn

src = torch.tensor([0, 1, 2])
dst = torch.tensor([1, 2, 0])
g = dgl.graph((src, dst)).to('npu:0')
g.ndata['h'] = torch.randn(g.num_nodes(), 4, device='npu:0')
g.update_all(fn.copy_u('h', 'm'), fn.sum('m', 'agg'))
print('dgl version:', dgl.__version__)
print('aggregated tensor device:', g.ndata['agg'].device)
```

Train LightGCN on the Gowalla dataset for one epoch (the quick start example from the upstream repository):

```bash
git clone https://github.com/BUPT-GAMMA/dgl-ascend.git
cd dgl-ascend/examples/pytorch/lightgcn
```

```python
from pathlib import Path
from urllib.request import urlretrieve
from zipfile import ZipFile

example_dir = Path('.')
archive = example_dir / 'gowalla.zip'
if not archive.exists():
    urlretrieve('https://s3.us-west-2.amazonaws.com/dgl-data/dataset/gowalla.zip', archive)
with ZipFile(archive) as dataset:
    dataset.extractall(example_dir)
```

```bash
python3 main.py --dataset gowalla --batch 2048 --recdim 64 --epochs 1 --device npu
```

The log should report `device: npu` and the average BPR loss of the epoch.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
