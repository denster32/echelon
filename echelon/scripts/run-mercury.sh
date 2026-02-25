#!/bin/bash

# ECHELON Mercury Runner
# Wraps Mercury by Inception Labs for high-volume mechanical tasks.
# Mercury: diffusion LM, 1000+ t/s, OpenAI-compatible API.
# Pricing: $0.25 input / $0.75 output per 1M tokens. 10M free tokens on signup.
# Sign up: https://inceptionlabs.ai
#
# Usage:
#   echelon/scripts/run-mercury.sh --prompt-file prompts/task.md --output analysis/result.md
#
# Model: mercury-2 (routes all ECHELON mechanical tiers: ingest, verify, write)

set -euo pipefail

MERCURY_BASE="https://api.inceptionlabs.ai/v1"
MERCURY_MODEL="mercury-2"

# Parse arguments
PROMPT_FILE=""
OUTPUT_FILE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --prompt-file)
      if [[ -z "${2:-}" ]]; then
        echo "❌ Error: --prompt-file requires a path argument" >&2
        exit 1
      fi
      PROMPT_FILE="$2"
      shift 2
      ;;
    --output)
      if [[ -z "${2:-}" ]]; then
        echo "❌ Error: --output requires a path argument" >&2
        exit 1
      fi
      OUTPUT_FILE="$2"
      shift 2
      ;;
    -h|--help)
      cat << 'HELP_EOF'
ECHELON Mercury Runner

USAGE:
  echelon/scripts/run-mercury.sh --prompt-file prompts/task.md --output analysis/result.md

OPTIONS:
  --prompt-file PATH   Path to the pre-written prompt file (prompts/[task_id].md)
  --output PATH        Path where Mercury should write its output
  -h, --help           Show this help

SETUP:
  1. Get a Mercury API key at: https://inceptionlabs.ai
     (10 million free tokens on signup)
  2. Export your key:
     export INCEPTION_API_KEY=your_key_here
  3. Run this script

PRICING:
  $0.25 / 1M input tokens
  $0.75 / 1M output tokens
  Mercury generates at 1000+ tokens/second on standard NVIDIA hardware.

HELP_EOF
      exit 0
      ;;
    *)
      echo "❌ Error: Unknown argument: $1" >&2
      echo "   Usage: run-mercury.sh --prompt-file PATH --output PATH" >&2
      exit 1
      ;;
  esac
done

# Validate required arguments
if [[ -z "$PROMPT_FILE" ]]; then
  echo "❌ Error: --prompt-file is required" >&2
  exit 1
fi

if [[ -z "$OUTPUT_FILE" ]]; then
  echo "❌ Error: --output is required" >&2
  exit 1
fi

# Validate prompt file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "❌ Error: Prompt file not found: $PROMPT_FILE" >&2
  exit 1
fi

# Check for Mercury API key
if [[ -z "${INCEPTION_API_KEY:-}" ]]; then
  cat << 'EOF' >&2

❌ Mercury API key not set.

ECHELON routes high-volume tasks (ingest, verify, write) to Mercury by Inception Labs.
Mercury generates at 1000+ tokens/second — orders of magnitude faster than Claude for
mechanical passes.

To enable Mercury:

  1. Sign up at https://inceptionlabs.ai
     (10 million free tokens — no credit card required)

  2. Export your API key:
     export INCEPTION_API_KEY=your_key_here

  3. Add it permanently to your shell profile:
     echo 'export INCEPTION_API_KEY=your_key_here' >> ~/.bashrc

Pricing: $0.25 input / $0.75 output per 1M tokens
Model: mercury-2 (OpenAI-compatible endpoint)

Alternatively, change model_tier to 'sonnet' in MISSION_PLAN.md for this task
to route it through Claude instead of Mercury.

EOF
  exit 1
fi

# Ensure output directory exists
OUTPUT_DIR="$(dirname "$OUTPUT_FILE")"
mkdir -p "$OUTPUT_DIR"

# Extract prompt content (strip YAML frontmatter if present)
# Content after the second --- separator
PROMPT_CONTENT=$(awk '/^---$/{i++; next} i>=2' "$PROMPT_FILE")

# If no frontmatter found, use the whole file
if [[ -z "$PROMPT_CONTENT" ]]; then
  PROMPT_CONTENT=$(cat "$PROMPT_FILE")
fi

# --- MERCURY API CALL ---
# TODO: This is the stub. Wire up the curl call below when ready.
#
# The OpenAI-compatible request:
#
# curl -s -X POST "$MERCURY_BASE/chat/completions" \
#   -H "Authorization: Bearer $INCEPTION_API_KEY" \
#   -H "Content-Type: application/json" \
#   -d "$(jq -n \
#     --arg model "$MERCURY_MODEL" \
#     --arg content "$PROMPT_CONTENT" \
#     '{
#       "model": $model,
#       "messages": [{"role": "user", "content": $content}],
#       "max_tokens": 8192
#     }')" | jq -r '.choices[0].message.content' > "$OUTPUT_FILE"
#
# Uncomment the above and remove the stub block below when INCEPTION_API_KEY is set.

echo "⚡ Mercury stub: API key detected but full integration not yet wired." >&2
echo "   Prompt file: $PROMPT_FILE" >&2
echo "   Output file: $OUTPUT_FILE" >&2
echo "   Model: $MERCURY_MODEL @ $MERCURY_BASE" >&2
echo "" >&2
echo "   To complete Mercury integration, uncomment the curl block in:" >&2
echo "   echelon/scripts/run-mercury.sh" >&2
echo "" >&2

# Write a placeholder output so the CO can verify the file exists
cat > "$OUTPUT_FILE" << PLACEHOLDER_EOF
# Mercury Output Placeholder

task: $(basename "$PROMPT_FILE" .md)
status: STUB — Mercury API call not yet wired
prompt_file: $PROMPT_FILE

## claims
[Mercury would populate this section]

## evidence
[Mercury would populate this section]

## methodology
[Mercury would populate this section]

## gaps
[Mercury would populate this section]

---
Note: Uncomment the curl block in echelon/scripts/run-mercury.sh to enable real Mercury output.
PLACEHOLDER_EOF

echo "   Placeholder output written to: $OUTPUT_FILE" >&2
exit 0
