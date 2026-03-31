FROM oven/bun:1-debian

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://claude.ai/install.sh | bash \
    && cp -a /root/.local/share/claude /usr/local/share/claude \
    && ln -sf /usr/local/share/claude/versions/$(ls /root/.local/share/claude/versions/) /usr/local/bin/claude \
    && useradd -m -s /bin/bash claude \
    && mkdir -p /app && chown claude:claude /app \
    && printf '%s\n' '{"hasCompletedOnboarding":true,"projects":{"/app":{"allowedTools":[],"mcpContextUris":[],"mcpServers":{},"enabledMcpjsonServers":[],"disabledMcpjsonServers":[],"hasTrustDialogAccepted":true,"projectOnboardingSeenCount":1,"hasClaudeMdExternalIncludesApproved":false,"hasClaudeMdExternalIncludesWarningShown":false}}}' > /home/claude/.claude.json \
    && mkdir -p /home/claude/.claude \
    && chown -R claude:claude /home/claude

USER claude

WORKDIR /app

ENTRYPOINT ["claude"]
