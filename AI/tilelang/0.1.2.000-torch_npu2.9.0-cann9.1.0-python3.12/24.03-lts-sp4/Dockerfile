# syntax=docker/dockerfile:1
# TileLang-Ascend (Ascend C & PTO adaptation of TileLang) on openEuler.
FROM quay.io/ascend/torch-npu:2.9.0.post8-cann9.1.0-910b-openeuler24.03-py3.12

# Use PyPI directly; the base image pip.conf points at a mirror that is
# unreachable from the CI builders.
ENV PIP_INDEX_URL=https://pypi.org/simple

# Harden git against the flaky CI network (HTTP/2 resets, stalled transfers).
ENV GIT_CONFIG_COUNT=4 \
    GIT_CONFIG_KEY_0=http.version \
    GIT_CONFIG_VALUE_0=HTTP/1.1 \
    GIT_CONFIG_KEY_1=http.postBuffer \
    GIT_CONFIG_VALUE_1=524288000 \
    GIT_CONFIG_KEY_2=http.lowSpeedLimit \
    GIT_CONFIG_VALUE_2=1000 \
    GIT_CONFIG_KEY_3=http.lowSpeedTime \
    GIT_CONFIG_VALUE_3=60

ARG VERSION=TileLang-ascend-v0.1.2.000-release

LABEL author="openEuler CloudNative SIG" description="TileLang-Ascend (TILELANG with Ascend NPU backend) with torch_npu + CANN"


# Build the tilelang-ascend wheel from source and install it (torch/torch_npu
# from the base image are reused; requirements list them without pins).
# The setup.py patch clamps the build parallelism to 12 jobs so that the C++
# build does not exhaust the container memory limit on large hosts.
RUN dnf install -y git gcc gcc-c++ make && dnf clean all && \
    source /usr/local/Ascend/ascend-toolkit/set_env.sh && \
    export ASCEND_HOME_PATH=${ASCEND_HOME_PATH:-/usr/local/Ascend/ascend-toolkit/latest} && \
    git clone --recursive https://github.com/tile-ai/tilelang-ascend.git /tmp/tilelang-ascend && \
    git -C /tmp/tilelang-ascend checkout ${VERSION} && \
    cd /tmp/tilelang-ascend && \
    python3 -m pip install --no-cache-dir -r requirements.txt -r requirements-build.txt && \
    python3 - <<'PY'
from pathlib import Path

p = Path('setup.py')
s = p.read_text()
subs = [
    ('int(multiprocessing.cpu_count() * 0.5)', 'min(12, int(multiprocessing.cpu_count() * 0.5))'),
    ('int(multiprocessing.cpu_count() * 0.75)', 'min(12, int(multiprocessing.cpu_count() * 0.75))'),
]
for old, new in subs:
    assert old in s, f'setup.py patch anchor missing: {old!r} (upstream changed parallelism derivation)'
    s = s.replace(old, new)
p.write_text(s)
print('setup.py build parallelism clamped to <=12')
PY

# Separate RUN: a Dockerfile heredoc cannot be continued after its terminator
RUN source /usr/local/Ascend/ascend-toolkit/set_env.sh && \
    export ASCEND_HOME_PATH=${ASCEND_HOME_PATH:-/usr/local/Ascend/ascend-toolkit/latest} && \
    cd /tmp/tilelang-ascend && \
    ./build_wheel_ascend.sh && \
    ls -la dist/ && \
    for W in dist/tilelang-*.whl; do \
        python3 -m zipfile -l "$W" | grep -q 'tilelang/__init__.py' || { echo "FATAL: $W missing tilelang package"; exit 1; }; \
    done && \
    python3 -m pip install --no-cache-dir --force-reinstall --no-deps dist/tilelang-*.whl && \
    mkdir -p /opt/tilelang-ascend && \
    cp -r examples /opt/tilelang-ascend/examples && \
    python3 -c "import tilelang; print('tilelang installed:', tilelang.__version__)" && \
    cd / && rm -rf /tmp/tilelang-ascend && \
    python3 -m pip cache purge

CMD ["/bin/bash"]
