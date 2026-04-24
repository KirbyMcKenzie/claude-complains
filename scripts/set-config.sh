#!/bin/bash
# Write runtime config overrides to state.json.
# Usage: set-config.sh <key> <value> [<key> <value> ...]
# Valid keys: enabled (true|false), frequency (always|often|sometimes|rarely),
#             explicit (true|false), voice (any string).

set -u

PLUGIN_DATA="${CLAUDE_PLUGIN_DATA:-}"
if [[ -z "$PLUGIN_DATA" ]]; then
  printf 'error: CLAUDE_PLUGIN_DATA not set\n' >&2
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  printf 'error: jq is required\n' >&2
  exit 1
fi

mkdir -p "$PLUGIN_DATA"
STATE_FILE="$PLUGIN_DATA/state.json"
[[ -f "$STATE_FILE" ]] || printf '{}\n' > "$STATE_FILE"

while [[ $# -gt 0 ]]; do
  KEY="$1"
  VAL="${2:-}"
  shift 2 || { printf 'error: missing value for %s\n' "$KEY" >&2; exit 1; }

  case "$KEY" in
    enabled|explicit)
      if [[ "$VAL" != "true" && "$VAL" != "false" ]]; then
        printf 'error: %s must be true or false\n' "$KEY" >&2; exit 1
      fi
      jq --argjson v "$VAL" ".${KEY} = \$v" "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
      ;;
    frequency)
      case "$VAL" in always|often|sometimes|rarely) ;;
        *) printf 'error: frequency must be always|often|sometimes|rarely\n' >&2; exit 1 ;;
      esac
      jq --arg v "$VAL" '.frequency = $v' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
      ;;
    voice)
      jq --arg v "$VAL" '.voice = $v' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
      ;;
    *)
      printf 'error: unknown key %s\n' "$KEY" >&2; exit 1
      ;;
  esac
done

cat "$STATE_FILE"
