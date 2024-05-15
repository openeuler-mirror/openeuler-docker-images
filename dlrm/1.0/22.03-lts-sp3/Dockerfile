FROM openeuler/openeuler:22.03-lts-sp3

RUN yum install -y python3 python3-pip git

RUN pip3 config set global.extra-index-url https://pypi.tuna.tsinghua.edu.cn/simple

RUN git clone https://gitee.com/ls39938477/dlrm.git /opt/dlrm

RUN pip3 install --default-timeout=10000 -r /opt/dlrm/requirements.txt

RUN pip3 install tensorboard

RUN git clone https://gitee.com/ls39938477/logging.git mlperf-logging

RUN pip3 install -e mlperf-logging

WORKDIR /opt/dlrm
