# Quick reference

- The official OpenCV Ascend docker images

- Maintained by: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://atomgit.com/openeuler/cloudnative), [openEuler](https://atomgit.com/openeuler/community)

# OpenCV | openEuler

Current OpenCV docker images are built on the [openEuler](https://repo.openeuler.org/). This repository is free to use and exempted from per-user rate limits.

[OpenCV](https://github.com/opencv/opencv) is the open source computer vision library, providing image and video I/O, image processing, video analysis and the DNN module for deep learning inference. The `opencv-python` wheel does not ship the CANN backend, so this image builds OpenCV from source together with [opencv_contrib](https://github.com/opencv/opencv_contrib) with `WITH_CANN=ON`: `cv2.dnn` can offload inference to the NPU via `DNN_BACKEND_CANN`/`DNN_TARGET_NPU`, and the `cannops` module exposes classic vision operators on the Ascend NPU.

The build applies the CANN adaptation patches for OpenCV 5.x (cv::MatShape compatibility, per-TU narrow CANN op headers and the NULL-stream fallback required by CANN 9.1.0). The result is validated on a single Ascend 910B card with CANN 9.1.0 on Python 3.12, following the [Ascend quick start guard](https://github.com/cosdt-ci-test/workflows/blob/main/projects/opencv/docs/Quick-start-Ascend.md).

Read more about Ascend at [hiascend.com](https://www.hiascend.com/en/) and explore the OpenCV documentation at [docs.opencv.org](https://docs.opencv.org/).

# Supported tags and respective Dockerfile links

The tag of each OpenCV docker image consists of the OpenCV version and the version of the software stack. The details are as follows

| Tags | Currently | Architectures |
|--|--|--|
|[5.1.0-cann9.1.0-python3.12-oe2403sp4](https://atomgit.com/openeuler/openeuler-docker-images/blob/master/AI/opencv/5.1.0-cann9.1.0-python3.12/24.03-lts-sp4/Dockerfile)| OpenCV 5.1.0 (CANN backend, opencv_contrib cannops) with CANN 9.1.0 on openEuler 24.03-LTS-SP4 | amd64, arm64 |

# Usage

## Quick start 1: supported devices

- Atlas A2 Training series (Atlas 800T A2, Atlas 900 A2 PoD, Atlas 200T A2 Box16, Atlas 300T A2)

- Atlas 800I A2 Inference series (Atlas 800I A2)

## Quick start 2: setup environment using container

```bash
# Update DEVICE according to your device (/dev/davinci[0-7])
export DEVICE=/dev/davinci0
# Update the opencv image
export IMAGE=openeuler/opencv:5.1.0-cann9.1.0-python3.12-oe2403sp4
docker run --rm \
--name opencv \
--device $DEVICE \
--device /dev/davinci_manager \
--device /dev/devmm_svm \
--device /dev/hisi_hdc \
-v /usr/local/dcmi:/usr/local/dcmi \
-v /usr/local/bin/npu-smi:/usr/local/bin/npu-smi \
-v /usr/local/Ascend/driver/lib64/:/usr/local/Ascend/driver/lib64/ \
-v /usr/local/Ascend/driver/version.info:/usr/local/Ascend/driver/version.info \
-v /etc/ascend_install.info:/etc/ascend_install.info \
-it $IMAGE bash
```

## Quick start 3: computer vision and NPU inference with OpenCV

Load the CANN environment and validate the stack inside the container:

```bash
source /usr/local/Ascend/ascend-toolkit/set_env.sh
python3 -c "
import cv2
print('cv2 version:', cv2.__version__)
print('CANN backend available:', cv2.dnn.DNN_BACKEND_CANN)
print('NPU target available:', cv2.dnn.DNN_TARGET_NPU)
"
```

Read, convert and resize an image with the classic APIs:

```python
import cv2
import numpy as np

img = np.random.randint(0, 255, (512, 512, 3), dtype=np.uint8)
ok = cv2.imwrite('/tmp/opencv_quickstart.png', img)
print('imwrite ok:', ok)
loaded = cv2.imread('/tmp/opencv_quickstart.png')
gray = cv2.cvtColor(loaded, cv2.COLOR_BGR2GRAY)
resized = cv2.resize(loaded, (50, 200), interpolation=cv2.INTER_AREA)
print('shape:', loaded.shape, 'dtype:', loaded.dtype)
print('gray shape:', gray.shape, 'mean:', float(gray.mean()))
print('resized shape:', resized.shape)
```

Run a DNN inference on the Ascend NPU with MobileNetV2 (from [onnx/models](https://github.com/onnx/models); OpenCV 5.x needs `OPENCV_FORCE_DNN_ENGINE=1` so the classic engine honors the CANN backend):

```bash
python3 -c "from urllib.request import urlretrieve; urlretrieve('https://github.com/onnx/models/raw/main/validated/vision/classification/mobilenet/model/mobilenetv2-12.onnx', '/tmp/mobilenetv2-12.onnx')"
OPENCV_FORCE_DNN_ENGINE=1 python3 - <<'PY'
import numpy as np
import cv2

net = cv2.dnn.readNetFromONNX('/tmp/mobilenetv2-12.onnx')
net.setPreferableBackend(cv2.dnn.DNN_BACKEND_CANN)
net.setPreferableTarget(cv2.dnn.DNN_TARGET_NPU)

blob = np.random.rand(1, 3, 224, 224).astype(np.float32)
net.setInput(blob)
out = net.forward()
print('output shape:', out.shape)
print('output dtype:', out.dtype)
assert out.shape == (1, 1000) and out.dtype == np.float32
PY
```

The first `forward()` includes the CANN graph compilation (about 0.5-1 minute); the expected output shape is `(1, 1000)`.

# Question and answering

If you have any questions or want to use some special features, please submit an issue or a pull request on [openeuler-docker-images](https://atomgit.com/openeuler/openeuler-docker-images).
