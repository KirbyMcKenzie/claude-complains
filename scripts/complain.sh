#!/bin/bash
# claude-complains: on every Claude Stop, roll the dice and maybe complain.
# Perf contract: most invocations MUST exit with zero jq calls, zero file reads.
# Always exits 0. Never writes to stderr in normal operation.

set -u

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
PLUGIN_DATA="${CLAUDE_PLUGIN_DATA:-}"

# Flags:
#   (none)     honor all gates, play audio      — hook default
#   --test     bypass gates, play audio         — :test slash command
#   --dry-run  honor gates, skip audio          — verification only
FORCE=0
SKIP_AUDIO=0
PRINT_PHRASE=0
for arg in "$@"; do
  case "$arg" in
    --test)    FORCE=1; PRINT_PHRASE=1 ;;
    --dry-run) SKIP_AUDIO=1; PRINT_PHRASE=1 ;;
  esac
done

# ---- fast-path guards (no forking, no I/O) ----

[[ "$OSTYPE" == "darwin"* ]] || exit 0
command -v say >/dev/null 2>&1 || exit 0

# HARD GUARD: never pile audio on top of a speaking `say`. This applies to the
# hook default AND --test. The speech synthesis daemon cannot be swamped from
# this script. --dry-run bypasses because it never spawns say in the first place.
# If someone scripts --test in a loop, this is what prevents the OOM crash.
if [[ $SKIP_AUDIO -eq 0 ]]; then
  if pgrep -x say >/dev/null 2>&1; then
    [[ $PRINT_PHRASE -eq 1 ]] && printf 'claude-complains: already speaking, skipped\n'
    exit 0
  fi
fi

# ---- config resolution (env first; state.json only if it exists) ----

ENABLED="${CLAUDE_PLUGIN_OPTION_enabled:-true}"
FREQUENCY="${CLAUDE_PLUGIN_OPTION_frequency:-often}"
EXPLICIT="${CLAUDE_PLUGIN_OPTION_explicit:-false}"
VOICE="${CLAUDE_PLUGIN_OPTION_voice:-Fred}"

STATE_FILE="${PLUGIN_DATA:+$PLUGIN_DATA/state.json}"
HAS_STATE=0
if [[ -n "$STATE_FILE" && -f "$STATE_FILE" ]]; then
  if command -v jq >/dev/null 2>&1; then
    HAS_STATE=1
    # Single jq call: emit all 4 fields as TSV, empty string where unset.
    IFS=$'\t' read -r S_EN S_FQ S_EX S_VO < <(jq -r '
      [
        (if has("enabled")   then (.enabled|tostring)  else "" end),
        (if has("frequency") then .frequency           else "" end),
        (if has("explicit")  then (.explicit|tostring) else "" end),
        (if has("voice")     then .voice               else "" end)
      ] | @tsv
    ' "$STATE_FILE" 2>/dev/null) || { S_EN=""; S_FQ=""; S_EX=""; S_VO=""; }
    [[ -n "${S_EN:-}" ]] && ENABLED="$S_EN"
    [[ -n "${S_FQ:-}" ]] && FREQUENCY="$S_FQ"
    [[ -n "${S_EX:-}" ]] && EXPLICIT="$S_EX"
    [[ -n "${S_VO:-}" ]] && VOICE="$S_VO"
  fi
fi

# ---- gates ----

if [[ $FORCE -eq 0 ]]; then
  [[ "$ENABLED" == "true" ]] || exit 0

  case "$FREQUENCY" in
    always)    THRESHOLD=100 ;;
    often)     THRESHOLD=66  ;;
    sometimes) THRESHOLD=33  ;;
    rarely)    THRESHOLD=10  ;;
    *)         THRESHOLD=66  ;;
  esac
  [[ $((RANDOM % 100)) -lt $THRESHOLD ]] || exit 0
fi

# ---- phrase pick (reached only when we're actually going to speak) ----

command -v jq >/dev/null 2>&1 || exit 0

PHRASES_FILE="$PLUGIN_ROOT/data/phrases.json"
[[ -f "$PHRASES_FILE" ]] || exit 0

CUSTOM_FILE="${PLUGIN_DATA:+$PLUGIN_DATA/custom-phrases.json}"
if [[ "$EXPLICIT" == "true" ]]; then ALLOW_EXPLICIT=true; else ALLOW_EXPLICIT=false; fi

# Single jq call: (optional merge) -> filter -> pick by $RANDOM index.
if [[ -n "$CUSTOM_FILE" && -f "$CUSTOM_FILE" ]]; then
  PHRASE=$(jq -r -s \
    --argjson r "$RANDOM" \
    --argjson ax "$ALLOW_EXPLICIT" \
    '
    (.[0].phrases + (.[1].phrases // [])) as $all
    | [$all[] | select($ax or (.explicit == false)) | .text] as $p
    | if ($p|length) == 0 then empty else $p[$r % ($p|length)] end
    ' "$PHRASES_FILE" "$CUSTOM_FILE" 2>/dev/null)
else
  PHRASE=$(jq -r \
    --argjson r "$RANDOM" \
    --argjson ax "$ALLOW_EXPLICIT" \
    '
    [.phrases[] | select($ax or (.explicit == false)) | .text] as $p
    | if ($p|length) == 0 then empty else $p[$r % ($p|length)] end
    ' "$PHRASES_FILE" 2>/dev/null)
fi

[[ -n "$PHRASE" && "$PHRASE" != "null" ]] || exit 0

# ---- speak (detached) / print ----

if [[ $SKIP_AUDIO -eq 0 ]]; then
  ( nohup say -v "$VOICE" "$PHRASE" >/dev/null 2>&1 </dev/null & ) >/dev/null 2>&1
fi

if [[ $PRINT_PHRASE -eq 1 ]]; then
  printf 'voice=%s  phrase=%s\n' "$VOICE" "$PHRASE"
fi

exit 0
