#!/usr/bin/env bash

# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

export no_proxy=${your_no_proxy}
export http_proxy=${your_http_proxy}
export https_proxy=${your_http_proxy}
export LLM_ENDPOINT_PORT=8008
export LLM_SERVICE_PORT=9000
export FAQGen_COMPONENT_NAME="OpeaFaqGenTgi"
export LLM_MODEL_ID="Intel/neural-chat-7b-v3"
export MEGA_SERVICE_HOST_IP=${host_ip}
export LLM_SERVICE_HOST_IP=${host_ip}
export LLM_ENDPOINT="http://${host_ip}:${LLM_ENDPOINT_PORT}"
export BACKEND_SERVICE_ENDPOINT="http://${host_ip}:8888/v1/faqgen"
