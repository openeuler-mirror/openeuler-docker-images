FROM openeuler/openeuler:24.03-lts-sp4

ARG MEM0AI_VERSION=2.2.1
ARG PYMILVUS_VERSION=3.0.2
ARG FASTAPI_VERSION=0.162.0
ARG UVICORN_VERSION=0.54.0
ARG REQUESTS_VERSION=2.34.2

RUN dnf install -y python3 python3-pip && dnf clean all
RUN pip3 install --no-cache-dir \
      "mem0ai==${MEM0AI_VERSION}" \
      "pymilvus==${PYMILVUS_VERSION}" \
      "fastapi==${FASTAPI_VERSION}" \
      "uvicorn[standard]==${UVICORN_VERSION}" \
      "requests==${REQUESTS_VERSION}"

COPY app.py /app/app.py
EXPOSE 8888
CMD ["uvicorn","app:app","--host","0.0.0.0","--port","8888","--app-dir","/app"]
