FROM openeuler/openeuler:22.03-lts-sp3

RUN yum install -y python3 python3-pip git

RUN git clone https://github.com/facebookresearch/dlrm.git /opt/dlrm

RUN pip3 install --default-timeout=10000 -r /opt/dlrm/requirements.txt

RUN pip3 install tensorboard

RUN git clone https://github.com/mlperf/logging.git mlperf-logging

RUN pip3 install -e mlperf-logging

WORKDIR /opt/dlrm
