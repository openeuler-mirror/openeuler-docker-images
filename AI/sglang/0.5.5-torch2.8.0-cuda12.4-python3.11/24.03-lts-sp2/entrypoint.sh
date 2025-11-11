#!/bin/bash
# filepath: entrypoint.sh

# 设置-e，如果任何命令失败，脚本会立即退出
set -e

# 初始化 Conda for bash shell
# 这是比 `source activate` 更推荐的官方方法
source "/usr/local/miniconda3/etc/profile.d/conda.sh"

# 激活目标环境
conda activate sglang_env

# 执行传递给此脚本的所有参数（即 docker run 后面的命令）
# exec 会用新进程替换当前 shell 进程，这是最佳实践
exec "$@"
