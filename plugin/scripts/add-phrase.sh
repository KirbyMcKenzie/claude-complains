#!/bin/bash
# Append a custom phrase to the user's local phrase pack.
# Usage: add-phrase.sh <text>

set -u

PLUGIN_DATA="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/data/claude-complains}"
if ! command -v jq >/dev/null 2>&1; then
  printf 'error: jq is required (install with `brew install jq`)\n' >&2
  exit 1
fi

TEXT="${1:-}"
if [[ -z "$TEXT" ]]; then
  printf 'error: phrase text required\n' >&2; exit 1
fi

mkdir -p "$PLUGIN_DATA"
CUSTOM="$PLUGIN_DATA/custom-phrases.json"
[[ -f "$CUSTOM" ]] || printf '{"phrases": []}\n' > "$CUSTOM"

jq --arg t "$TEXT" \
   '.phrases += [{"text": $t, "tags": ["custom"]}]' \
   "$CUSTOM" > "$CUSTOM.tmp" && mv "$CUSTOM.tmp" "$CUSTOM"

COUNT=$(jq '.phrases | length' "$CUSTOM")
printf 'added. custom phrase count: %s\n' "$COUNT"
