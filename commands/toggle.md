---
description: Toggle claude-complains on or off for this session
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh)
---

Run `${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh` and tell the user the new state in one short line, e.g. "claude-complains is now OFF" or "claude-complains is now ON". The script prints `on` or `off` on stdout. Do nothing else.
