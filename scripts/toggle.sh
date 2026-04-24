#!/bin/bash
# Flip the runtime "enabled" state for claude-complains without touching userConfig.
# Prints the new state ("on" or "off") so the slash command can echo it back.

set -u

PLUGIN_DATA="${CLAUDE_PLUGIN_DATA:-}"
if [[ -z "$PLUGIN_DATA" ]]; then
  printf 'error: CLAUDE_PLUGIN_DATA not set\n' >&2
  exit 1
fi

mkdir -p "$PLUGIN_DATA"
STATE_FILE="$PLUGIN_DATA/state.json"

CURRENT="true"
if [[ -f "$STATE_FILE" ]] && command -v jq >/dev/null 2>&1; then
  # `.enabled // true` wrongly coalesces false to true. Explicit has-check required.
  CURRENT=$(jq -r 'if has("enabled") then .enabled else true end' "$STATE_FILE" 2>/dev/null || printf 'true')
fi

if [[ "$CURRENT" == "true" ]]; then
  NEW="false"
  LABEL="off"
else
  NEW="true"
  LABEL="on"
fi

printf '{"enabled": %s}\n' "$NEW" > "$STATE_FILE"
printf '%s\n' "$LABEL"
