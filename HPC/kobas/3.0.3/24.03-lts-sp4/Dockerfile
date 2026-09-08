# 复刻 conda-dev 容器中 KOBAS 3.0.3 的安装过程
# 架构:linux/aarch64(conda-forge/bioconda 均按 aarch64 解析,与源容器一致)
# 构建前需把预构建的 conda 包 kobas-3.0.3-py_3.tar.bz2 放到本文件同目录(build context)
FROM openeuler/miniconda:24.03-lts-sp4

# 便于在 RUN 中激活 conda 环境
RUN echo '. /opt/conda/etc/profile.d/conda.sh' >> /root/.bashrc

SHELL ["/bin/bash", "-lc"]

# 1) 建空环境并装 Python 2.7.15(KOBAS 3.0.3 仅支持 python2)
RUN conda create -y -n kobas \
    && conda install -y -n kobas -c conda-forge -c bioconda python==2.7.15

# 2) 装 pandas(numpy/six 随之而来)
RUN conda install -y -n kobas -c conda-forge -c bioconda pandas

# 3) 纯 Python 依赖:KOBAS 本地 web 服务(flask 系)及占位包 blast
#    blast==0.3.0(pypi)用于让后续 conda 解析 run 依赖 `blast` 时不至于去装 aarch64 上没有的 ncbi-blast
RUN conda activate kobas && pip install --no-cache-dir \
        flask==1.1.4 \
        jinja2==2.11.3 \
        werkzeug==1.0.1 \
        click==7.1.2 \
        itsdangerous==1.1.0 \
        markupsafe==1.1.1 \
        blast==0.3.0

# 4) 装 R(rpy2 编译和 bioconductor-qvalue 都需要)
RUN conda install -y -n kobas -c conda-forge -c bioconda r-base

# 5) 补齐缺失的 crypt.h:rpy2 源码编译时需要 <crypt.h>,
#    openEuler 上该头文件由 libxcrypt-devel 提供,`dnf install -y glibc-devel` 会连带装上
RUN dnf install -y glibc-devel \
    && dnf clean all

# 6) pip 编译安装 rpy2(需 R + crypt.h),并装 biopython/singledispatch
RUN conda activate kobas && pip install --no-cache-dir \
        rpy2==2.8.5 \
        biopython==1.75 \
        singledispatch==3.7.0

# 7) 装 R 包 qvalue(KOBAS 富集分析用)
RUN conda install -y -n kobas -c conda-forge -c bioconda bioconductor-qvalue

# 8) 用本地 conda 包安装 KOBAS 本体
#    conda 26 默认开启 pip-interop,前面 pip 装的 biopython/rpy2/blast 可满足 run 依赖
COPY kobas-3.0.3-py_3.tar.bz2 /tmp/kobas-3.0.3-py_3.tar.bz2
RUN conda install -y -n kobas --use-local /tmp/kobas-3.0.3-py_3.tar.bz2

# 9) 验证
RUN conda run -n kobas kobas-annotate -h \
    && conda run -n kobas kobas-identify -h \
    && conda run -n kobas kobas-run -h

ENV PATH=/opt/conda/envs/kobas/bin:$PATH

CMD ["/bin/bash"]
