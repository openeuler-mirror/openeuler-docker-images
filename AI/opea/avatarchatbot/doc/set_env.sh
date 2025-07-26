export LLM_MODEL_ID=Intel/neural-chat-7b-v3-3

export WAV2LIP_ENDPOINT=http://$host_ip:7860

export MEGA_SERVICE_HOST_IP=${host_ip}
export WHISPER_SERVER_HOST_IP=${host_ip}
export WHISPER_SERVER_PORT=7066
export SPEECHT5_SERVER_HOST_IP=${host_ip}
export SPEECHT5_SERVER_PORT=7055
export LLM_SERVER_HOST_IP=${host_ip}
export LLM_SERVER_PORT=3006
export ANIMATION_SERVICE_HOST_IP=${host_ip}
export ANIMATION_SERVICE_PORT=3008

export MEGA_SERVICE_PORT=8888

export DEVICE="cpu"
export WAV2LIP_PORT=7860
export INFERENCE_MODE='wav2lip_only'
export CHECKPOINT_PATH='/usr/local/lib/python3.11/site-packages/Wav2Lip/checkpoints/wav2lip_gan.pth'
export FACE="assets/img/avatar1.jpg"
# export AUDIO='assets/audio/eg3_ref.wav' # audio file path is optional, will use base64str in the post request as input if is 'None'
export AUDIO='None'
export FACESIZE=96
export OUTFILE="/outputs/result.mp4"
export GFPGAN_MODEL_VERSION=1.4 # latest version, can roll back to v1.3 if needed
export UPSCALE_FACTOR=1
export FPS=10