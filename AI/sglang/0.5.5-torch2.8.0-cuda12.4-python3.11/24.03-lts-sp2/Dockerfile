ARG BASE=hub.oepkgs.net/openeuler/openeuler:24.03-lts-sp2

FROM ${BASE}

RUN yum update -y && \
    yum install -y python3-pip gcc gcc-c++ make tar wget numactl-devel && \
    yum clean all && \
    rm -rf /var/cache/yum

ARG CUDA_URL=https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda_12.4.0_550.54.14_linux.run

RUN wget ${CUDA_URL} -O /tmp/cuda_installer.run && \
    sh /tmp/cuda_installer.run --silent --toolkit && \
    rm -f /tmp/cuda_installer.run
    
ENV PATH=/usr/local/cuda-12.4/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda-12.4/lib64:${LD_LIBRARY_PATH}
ENV CUDA_HOME=/usr/local/cuda-12.4

ARG CONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN mkdir -p /usr/local/miniconda3 && \
    wget ${CONDA_URL} -O /usr/local/miniconda3/miniconda.sh && \
    bash /usr/local/miniconda3/miniconda.sh -b -u -p /usr/local/miniconda3 && \
    rm -f /usr/local/miniconda3/miniconda.sh

ENV PATH=/usr/local/miniconda3/bin:${PATH}

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

RUN conda create -n sglang_env python=3.11 -y
RUN conda run -n sglang_env pip install --no-cache-dir sglang[all]==0.5.5

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
