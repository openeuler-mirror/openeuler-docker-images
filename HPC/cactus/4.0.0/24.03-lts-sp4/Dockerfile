ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=4.0.0

RUN dnf install -y \
      python3-pip python3-virtualenv \
      gcc gcc-c++ make \
      git rsync && \
    dnf clean all

RUN git clone --branch v${VERSION} --depth 1 https://github.com/ComparativeGenomicsToolkit/cactus.git /opt/cactus && \
    cd /opt/cactus && \
    git submodule update --init --recursive --depth 1

WORKDIR /opt/cactus

RUN python3 -m virtualenv cactus_env && \
    echo "export PATH=/opt/cactus/bin:\$PATH" >> cactus_env/bin/activate && \
    echo "export PYTHONPATH=/opt/cactus/lib:\$PYTHONPATH" >> cactus_env/bin/activate

ENV PATH=/opt/cactus/cactus_env/bin:/opt/cactus/bin:$PATH
ENV PYTHONPATH=/opt/cactus/lib:$PYTHONPATH

RUN pip3 install --no-cache-dir -i https://pypi.org/simple -U setuptools pip wheel
RUN pip3 install --no-cache-dir -i https://pypi.org/simple -U .
RUN pip3 install --no-cache-dir -i https://pypi.org/simple -U -r ./toil-requirement.txt

WORKDIR /data

CMD ["cactus", "--help"]
