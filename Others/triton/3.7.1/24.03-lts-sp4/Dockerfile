ARG BASE=openeuler/openeuler:24.03-lts-sp4

FROM ${BASE} AS builder

ARG VERSION=3.7.1

RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir --timeout 60 --retries 3 \
      -i https://pypi.tuna.tsinghua.edu.cn/simple triton==${VERSION}

FROM ${BASE}

COPY --from=builder /opt/venv /opt/venv

ENV PATH=/opt/venv/bin:$PATH

USER root

CMD ["python3", "-c", "import triton; print('Triton', triton.__version__)"]
