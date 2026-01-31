 # 使用 OpenEuler 24.03 LTS 作为基础镜像
FROM openeuler/openeuler:24.03-lts

# 1. 更新系统并安装必要依赖
# opencode 是基于 Node.js 的工具，需要 nodejs 和 git
# curl, wget, tar, unzip 等是常用工具，方便 Agent 使用
RUN dnf update -y && \
    dnf install -y \
    nodejs \
    npm \
    git \
    curl \
    wget \
    tar \
    unzip \
    which \
    shadow-utils && \
    dnf clean all

# 2. 安装 opencode-ai
# 根据官方文档，opencode 可以通过 npm 全局安装
# 这里的版本号依赖于 npm 仓库最新版
RUN npm install -g opencode-ai@1.1.48

# 3. 创建工作目录
WORKDIR /workspace

# 4. 设置容器启动时的入口点
# 当用户执行 docker run 时，会自动运行 opencode
ENTRYPOINT ["opencode"]

# 默认参数（如果是交互式工具，通常不需要额外参数，但可以预留 CMD）
CMD []