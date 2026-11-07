# Quick reference

- The official DeepSpeed Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# DeepSpeed | openEuler

Current DeepSpeed docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[DeepSpeed](https://github.com/deepspeedai/DeepSpeed) is a deep learning optimization library by Microsoft that makes large-scale training and inference fast, effective and affordable. It provides ZeRO memory optimization, 3D parallelism, CPU offload and a high-throughput inference engine on top of PyTorch, and ships a Huawei-contributed NPU accelerator (`deepspeed.accelerator`).

This image ships DeepSpeed with [torch_npu](https://atomgit.com/ascend/pytorch) so that training workloads run seamlessly on the Ascend NPU. The software stack is validated on a single Ascend 910B4 card with CANN 9.1.0, `torch==2.9.0` and `torch_npu==2.9.0.post8` on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/deepspeed/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the DeepSpeed documentation at [deepspeed.ai](https://www.deepspeed.ai/).

# Supported tags and respective Dockerfile links

The tag of each DeepSpeed docker image consists of the DeepSpeed version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[0.19.9-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/deepspeed/0.19.9-torch_npu2.9.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| DeepSpeed 0.19.9 (torch_npu 2.9.0.post8, CANN 9.1.0) on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the deepspeed image
export IMAGE=openeuler/deepspeed:0.19.9-torch_npu2.9.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name deepspeed \
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

## Quick start 3: training on Ascend NPU

Validate the environment inside the container:

```bash
python3 -c "import torch, torch_npu; print('torch=', torch.__version__); print('torch_npu=', torch_npu.__version__); print('is_available:', torch.npu.is_available()); print('count:', torch.npu.device_count())"
python3 -c "import deepspeed; print('deepspeed', deepspeed.__version__)"
python3 -c "from deepspeed.accelerator import get_accelerator; print('accelerator:', get_accelerator()._name)"
```

`accelerator: npu` means DeepSpeed has picked up the Ascend accelerator. Then train a small CNN on CIFAR10 with ZeRO-1 and BF16. Save the following script as `train_cifar10.py`:

```python
import os
import urllib.request
import zipfile
from pathlib import Path

import torch
import torch.nn as nn
import torchvision
from torchvision import transforms
import deepspeed

MICRO_BATCH = 8

# CIFAR10 is downloaded from the ModelScope mirror on first use
data_dir = Path('./data')
if not (data_dir / 'cifar-10-batches-py').exists():
    data_dir.mkdir(parents=True, exist_ok=True)
    archive = data_dir / 'cifar-10-batches-py.zip'
    urllib.request.urlretrieve(
        'https://modelscope.cn/api/v1/datasets/studyhard1/cifar10-dataset/repo?Revision=master&FilePath=cifar-10-batches-py.zip',
        archive)
    with zipfile.ZipFile(archive) as zf:
        zf.extractall(data_dir)
transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5)),
    transforms.ConvertImageDtype(torch.bfloat16),
])
trainset = torchvision.datasets.CIFAR10(root='./data', train=True, download=True, transform=transform)
trainloader = torch.utils.data.DataLoader(trainset, batch_size=MICRO_BATCH, shuffle=True)

class Net(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv2d(3, 6, 5)
        self.pool = nn.MaxPool2d(2, 2)
        self.conv2 = nn.Conv2d(6, 16, 5)
        self.fc1 = nn.Linear(16 * 5 * 5, 120)
        self.fc2 = nn.Linear(120, 84)
        self.fc3 = nn.Linear(84, 10)

    def forward(self, x):
        x = self.pool(torch.relu(self.conv1(x)))
        x = self.pool(torch.relu(self.conv2(x)))
        x = x.view(-1, 16 * 5 * 5)
        x = torch.relu(self.fc1(x))
        x = torch.relu(self.fc2(x))
        return self.fc3(x)

# deepspeed.initialize() injects the optimizer, ZeRO memory optimization and
# BF16 mixed precision; WORLD_SIZE is provided by the deepspeed launcher
world_size = int(os.environ.get('WORLD_SIZE', 1))
ds_config = {
    'train_batch_size': MICRO_BATCH * world_size,
    'optimizer': {
        'type': 'Adam',
        'params': {'lr': 0.001},
    },
    'zero_optimization': {'stage': 1},
    'bf16': {'enabled': True},
}
model = Net()
model_engine, optimizer, _, _ = deepspeed.initialize(
    model=model, model_parameters=model.parameters(), config=ds_config)

criterion = nn.CrossEntropyLoss()
for epoch in range(1):
    running_loss = 0.0
    for i, data in enumerate(trainloader):
        inputs, labels = data[0].to(model_engine.device), data[1].to(model_engine.device)
        outputs = model_engine(inputs)
        loss = criterion(outputs, labels)
        model_engine.backward(loss)
        model_engine.step()
        running_loss += loss.item()
        if i % 100 == 99:
            if model_engine.global_rank == 0:
                print(f'[{epoch + 1}, {i + 1:5d}] loss: {running_loss / 100:.3f}')
            running_loss = 0.0
if model_engine.global_rank == 0:
    print('Finished Training')
```

Launch the training with the DeepSpeed launcher (on two cards run the same script with `--num_gpus 2`):

```bash
deepspeed --num_gpus 1 train_cifar10.py
```

More examples are available in the [DeepSpeedExamples](https://github.com/deepspeedai/DeepSpeedExamples) repository.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
