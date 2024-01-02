FROM openeuler/openeuler:22.03-lts-sp2

ARG CANN_TOOLKIT_URL=https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C13SPC702/Ascend-cann-toolkit_7.0.RC1.alpha002_linux-aarch64.run
ARG CANN_KERNELS_URL=https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C13SPC702/Ascend-cann-kernels-910b_7.0.RC1.alpha002_linux.run


ENV ASCEND_TOOLKIT_HOME=/usr/local/Ascend/ascend-toolkit/latest
ENV LD_LIBRARY_PATH=${ASCEND_TOOLKIT_HOME}/lib64:${ASCEND_TOOLKIT_HOME}/lib64/plugin/opskernel:${ASCEND_TOOLKIT_HOME}/lib64/plugin/nnengine:${ASCEND_TOOLKIT_HOME}/opp/built-in/op_impl/ai_core/tbe/op_tiling:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=/usr/local/Ascend/driver/lib64/common/:/usr/local/Ascend/driver/lib64/driver/:$LD_LIBRARY_PATH
ENV PYTHONPATH=${ASCEND_TOOLKIT_HOME}/python/site-packages:${ASCEND_TOOLKIT_HOME}/opp/built-in/op_impl/ai_core/tbe:$PYTHONPATH
ENV PATH=${ASCEND_TOOLKIT_HOME}/bin:${ASCEND_TOOLKIT_HOME}/compiler/ccec_compiler/bin:$PATH
ENV PATH=/usr/local/miniconda/envs/torch_npu/bin/:/usr/local/miniconda/bin:$PATH
ENV ASCEND_AICPU_PATH=${ASCEND_TOOLKIT_HOME}
ENV ASCEND_OPP_PATH=${ASCEND_TOOLKIT_HOME}/opp
ENV TOOLCHAIN_HOME=${ASCEND_TOOLKIT_HOME}/toolkit
ENV ASCEND_HOME_PATH=${ASCEND_TOOLKIT_HOME}

RUN yum install -y git wget gcc gcc-c++ make cmake unzip zlib-devel libffi-devel openssl-devel pciutils net-tools sqlite-devel lapack-devel gcc-gfortran python3-devel util-linux patchelf && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /usr/local/miniconda && \
    rm -f ~/miniconda.sh

RUN /usr/local/miniconda/bin/conda init bash && \
    /usr/local/miniconda/bin/conda create --name torch_npu -y python=3.8.11

RUN source /root/.bashrc && conda activate torch_npu && \
    pip3 install attrs decorator psutil numpy absl-py cloudpickle scipy synr==0.5.0 protobuf==3.19.0 tornado -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip3 cache purge

RUN wget ${CANN_TOOLKIT_URL} -O ~/Ascend-cann-toolkit.run && \
    chmod +x ~/Ascend-cann-toolkit.run && \
    printf "Y\n" | ~/Ascend-cann-toolkit.run --install && \
    rm -f ~/Ascend-cann-toolkit.run

RUN wget ${CANN_KERNELS_URL} -O ~/Ascend-cann-kernels.run && \
    chmod +x ~/Ascend-cann-kernels.run && \
    printf "Y\n" | ~/Ascend-cann-kernels.run --install && \
    rm -f ~/Ascend-cann-kernels.run