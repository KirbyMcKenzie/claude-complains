---
description: Play a random phrase right now to preview the voice and vibe
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/complain.sh:*), Bash(find:*)
---

Run the complain script with `--test`. The script prints a single line like `voice=Zarvox  phrase=<text>` and plays the phrase through `say`. Echo that line back verbatim to the user — no extra commentary.

Primary path: `${CLAUDE_PLUGIN_ROOT}/scripts/complain.sh --test`. **If that path doesn't exist**, locate the script with:

```bash
find "$HOME/.claude/plugins" -path '*claude-complains*scripts/complain.sh' -type f -print -quit 2>/dev/null
```

Run whichever path resolves with `--test`.
