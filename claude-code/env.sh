source ~/.env
setenv ANTHROPIC_API_KEY "dummy"
export ANTHROPIC_BASE_URL="https://llm-api.amd.com/Anthropic"
export ANTHROPIC_CUSTOM_HEADERS="Ocp-Apim-Subscription-Key: ${AMD_LLM_GATEWAY_KEY}"
export ANTHROPIC_MODEL="claude-sonnet-4.5"
export ANTHROPIC_DEFAULT_OPUS_MODEL="claude-opus-4.5"
export ANTHROPIC_DEFAULT_SONNET_MODEL="claude-sonnet-4.5"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="claude-haiku-4.5"
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export CLAUDE_CONFIG_DIR="${HOME}/.claude"
export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1