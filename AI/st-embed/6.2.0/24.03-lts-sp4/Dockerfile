FROM openeuler/openeuler:24.03-lts-sp4

ARG TORCH_VERSION=2.15.0
ARG ST_VERSION=6.2.0
ARG TRANSFORMERS_VERSION=5.22.1
ARG FASTAPI_VERSION=0.162.0
ARG UVICORN_VERSION=0.54.0

RUN dnf install -y python3 python3-pip && dnf clean all
RUN pip3 install --no-cache-dir "torch==${TORCH_VERSION}" --index-url https://download.pytorch.org/whl/cpu \
 && pip3 install --no-cache-dir \
      "sentence-transformers==${ST_VERSION}" \
      "transformers==${TRANSFORMERS_VERSION}" \
      "fastapi==${FASTAPI_VERSION}" \
      "uvicorn[standard]==${UVICORN_VERSION}"

COPY server.py /app/server.py
EXPOSE 80
CMD ["uvicorn","server:app","--host","0.0.0.0","--port","80","--app-dir","/app"]
