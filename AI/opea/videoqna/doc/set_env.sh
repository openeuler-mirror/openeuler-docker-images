export no_proxy=${your_no_proxy}
export http_proxy=${your_http_proxy}
export https_proxy=${your_http_proxy}
export MEGA_SERVICE_HOST_IP=${host_ip}
export EMBEDDING_SERVICE_HOST_IP=${host_ip}
export RETRIEVER_SERVICE_HOST_IP=${host_ip}
export RERANK_SERVICE_HOST_IP=${host_ip}
export LVM_SERVICE_HOST_IP=${host_ip}

export LVM_ENDPOINT="http://${host_ip}:9009"
export BACKEND_SERVICE_ENDPOINT="http://${host_ip}:8888/v1/videoqna"
export BACKEND_HEALTH_CHECK_ENDPOINT="http://${host_ip}:8888/v1/health_check"
export DATAPREP_SERVICE_ENDPOINT="http://${host_ip}:6007/v1/dataprep"
export DATAPREP_GET_FILE_ENDPOINT="http://${host_ip}:6007/v1/dataprep/get_file"
export DATAPREP_GET_VIDEO_LIST_ENDPOINT="http://${host_ip}:6007/v1/dataprep/get_videos"

export VDMS_HOST=${host_ip}
export VDMS_PORT=8001
export INDEX_NAME="mega-videoqna"
export LLM_DOWNLOAD="True"
export USECLIP=1