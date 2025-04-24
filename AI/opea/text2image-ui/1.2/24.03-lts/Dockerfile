# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

FROM openeuler/openeuler:24.03-lts

RUN dnf install -y git nodejs && \
    dnf clean all 

RUN node --version && npm --version

RUN git clone https://github.com/opea-project/GenAIExamples.git && \
    cd GenAIExamples && \
    git checkout v1.2 && \
    cp -r  Text2Image/ui/svelte /home/svelte && \
    rm -rf /GenAIExamples

WORKDIR /home/svelte

RUN npm install && npm run build

EXPOSE 5173

CMD ["npm", "run", "preview", "--", "--port", "5173", "--host", "0.0.0.0"]
