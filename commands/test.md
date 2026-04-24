---
description: Play a random phrase right now to preview the voice and vibe
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/complain.sh:*)
---

Run `${CLAUDE_PLUGIN_ROOT}/scripts/complain.sh --test`. The script prints a single line like `voice=Zarvox  phrase=<text>` and plays the phrase through `say`. Echo that line back verbatim to the user — no extra commentary.
