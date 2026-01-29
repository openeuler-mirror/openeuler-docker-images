FROM openeuler/openeuler:24.03-lts-sp3

ARG CLAUDE_VERSION=2.1.20
ARG CLAUDE_INSTALL_SCRIPT="https://claude.ai/install.sh"
ARG OLLAMA_INSTALL_SCRIPT="https://ollama.com/install.sh"

ENV ANTHROPIC_AUTH_TOKEN=ollama \
    ANTHROPIC_BASE_URL=http://localhost:11434 \
    PATH=/root/.local/bin:$PATH

RUN yum update -y && \
    yum install -y bash python3 python3-pip curl tar findutils && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN curl -fsSL "${CLAUDE_INSTALL_SCRIPT}" -o /tmp/claude-install.sh && \
    chmod +x /tmp/claude-install.sh && \
    /tmp/claude-install.sh "${CLAUDE_VERSION}" && \
    rm -f /tmp/claude-install.sh

RUN curl -fsSL "${OLLAMA_INSTALL_SCRIPT}" | sh

WORKDIR /workspace

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

ENTRYPOINT ["/root/entrypoint.sh"]
CMD ["/bin/bash"]