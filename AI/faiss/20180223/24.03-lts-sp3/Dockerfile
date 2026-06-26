ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=20180223

RUN yum -y update && \
    yum -y install gcc-c++ make openblas-devel python3 python3-devel python3-numpy swig git && \
    git clone --branch v${VERSION} --depth 1 https://github.com/facebookresearch/faiss.git /tmp/faiss && \
    cp /tmp/faiss/example_makefiles/makefile.inc.Linux /tmp/faiss/makefile.inc && \
    echo "SWIG = swig" >> /tmp/faiss/makefile.inc && \
    echo "SWIGFLAGS = -c++ -Doverride=" >> /tmp/faiss/makefile.inc && \
    PYTHON_INCLUDE=$(python3 -c "import numpy; print(numpy.get_include())") && \
    PYTHON_CONFIG_INCLUDES=$(python3-config --includes) && \
    echo "PYTHONCFLAGS = -I\${PYTHON_INCLUDE} \${PYTHON_CONFIG_INCLUDES}" >> /tmp/faiss/makefile.inc && \
    make -C /tmp/faiss -j$(nproc) && \
    make -C /tmp/faiss py && \
    SITE_PKGS=$(python3 -c "import site; print(site.getsitepackages()[0])") && \
    cp /tmp/faiss/python/_swigfaiss.so \${SITE_PKGS}/ && \
    cp /tmp/faiss/python/swigfaiss.py \${SITE_PKGS}/ && \
    rm -rf /tmp/faiss && \
    yum -y remove gcc make 2>/dev/null || true && \
    yum clean all

WORKDIR /workspace

CMD ["python3"]
