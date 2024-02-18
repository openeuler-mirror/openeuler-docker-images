FROM openeuler/cann:cann7.0.RC1.alpha002-oe2203sp2

# Install requirements
RUN pip install --no-cache-dir -i https://repo.huaweicloud.com/repository/pypi/simple \
    cmake \
    ninja \
    protobuf==3.20.0 \
    attrs \
    cython \
    numpy \
    decorator \
    sympy \
    cffi \
    pyyaml \
    pathlib2 \
    psutil \
    scipy \
    requests \
    absl-py \
    prompt_toolkit

RUN git clone https://github.com/pytorch/pytorch.git && \
    cd pytorch && \
    git reset 5913437a40a6e45ab7e164afb7c6ec930dd40b2f --hard && \
    pip install --no-cache-dir -r ./requirements.txt -i https://repo.huaweicloud.com/repository/pypi/simple && \
    export USE_CUDA=0 && \
    export USE_XNNPACK=0 && \
    python3 setup.py develop

RUN git clone https://github.com/ascend/pytorch.git ascend-pytorch && \
    cd ascend-pytorch && \
    git reset 81ece7b664adc28e698044d0e9091d39a1a6dfa6 --hard && \
    pip install --no-cache-dir pyyaml wheel decorator snippy && \
    bash ci/build.sh --python=3.8 && \
    pip3 install --upgrade dist/torch_npu-2.1.0-cp38-cp38-linux_aarch64.whl && \
    rm -rf ../ascend-pytorch