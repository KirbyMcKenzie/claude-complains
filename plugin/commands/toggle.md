---
description: Toggle claude-complains on or off for this session
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh), Bash(find:*)
---

Run the toggle script and tell the user the new state in one short line, e.g. "claude-complains is now OFF" or "claude-complains is now ON". The script prints `on` or `off` on stdout. Do nothing else.

Primary path: `${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh`. **If that path doesn't exist**, locate it with:

```bash
find "$HOME/.claude/plugins" -path '*claude-complains*scripts/toggle.sh' -type f -print -quit 2>/dev/null
```

Run whichever path resolves.
