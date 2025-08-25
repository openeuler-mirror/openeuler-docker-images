ARG BASE=openeuler/python:3.11.13-oe2403lts
ARG VERSION=v1.4

FROM $BASE

ENV LANG=C.UTF-8

ARG ARCH="cpu"

RUN yum update -y && \
    yum install -y \
        gcc g++ make cmake \
        java-21-openjdk \
        mesa-libGL \
        jemalloc-devel \
        git \
        wget \
        xz && \
    yum clean all

# Install ffmpeg static build
WORKDIR /root
RUN wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz && \
    mkdir ffmpeg-git-amd64-static && tar -xvf ffmpeg-git-amd64-static.tar.xz -C ffmpeg-git-amd64-static --strip-components 1 && \
    export PATH=/root/ffmpeg-git-amd64-static:$PATH && \
    cp /root/ffmpeg-git-amd64-static/ffmpeg /usr/local/bin/ && \
    cp /root/ffmpeg-git-amd64-static/ffprobe /usr/local/bin/

RUN mkdir -p /home/user

ARG VERSION
ARG GENAIEXAMPLES_REPO=https://github.com/opea-project/GenAIExamples.git
RUN git clone -b $VERSION $GENAIEXAMPLES_REPO && \
    cp -r GenAIExamples/CodeGen/ui/gradio /home/user/gradio

RUN pip install --no-cache-dir --upgrade pip setuptools && \
pip install --no-cache-dir -r /home/user/gradio/requirements.txt

WORKDIR /home/user/gradio
ENTRYPOINT ["python", "codegen_ui_gradio.py"]