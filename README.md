# claude-code-container

Pre-built container image for [Claude Code](https://claude.ai/code) with all dependencies included. Works with Docker, Podman, or any OCI-compatible runtime.

## What's included

- [Bun](https://bun.sh/) runtime
- Claude Code CLI (pre-installed)
- curl, CA certificates
- Non-root `claude` user
- Onboarding and workspace trust pre-configured for `/app`

## Build

```bash
docker build -t claude-code .
```

## Authentication

Generate a long-lived token (one-time setup on your host):
```bash
claude setup-token
```

Export it in your shell:
```bash
export CLAUDE_CODE_OAUTH_TOKEN=<your-token>
```

## Usage

### Interactive session

```bash
docker run --rm -it \
  -e CLAUDE_CODE_OAUTH_TOKEN \
  claude-code \
  --model haiku \
  --dangerously-skip-permissions
```

### Print mode (non-interactive)

```bash
docker run --rm \
  -e CLAUDE_CODE_OAUTH_TOKEN \
  -v "$PWD:/app" \
  claude-code \
  -p "explain this codebase"
```

### With custom entrypoint

Mount your own entrypoint script to run setup before launching Claude Code:

```bash
docker run --rm -it \
  --entrypoint /app/entrypoint.sh \
  -v "$PWD/entrypoint.sh:/app/entrypoint.sh:ro" \
  -e CLAUDE_CODE_OAUTH_TOKEN \
  claude-code
```

Your entrypoint should call `exec claude "$@"` at the end to pass through any CMD arguments.

## Configuration

| Env var | Description |
|---------|-------------|
| `CLAUDE_CODE_OAUTH_TOKEN` | Long-lived auth token from `claude setup-token` |
| `ANTHROPIC_API_KEY` | Alternative: API key from Claude Console (API billing) |

## Notes

- The container runs as a non-root `claude` user (required for `--dangerously-skip-permissions`)
- `/app` is the default working directory, owned by the `claude` user
- The Claude CLI version is baked into the image at build time — rebuild to update
