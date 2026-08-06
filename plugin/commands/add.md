---
description: Add a custom phrase to your local claude-complains library
argument-hint: "<phrase text>"
allowed-tools: AskUserQuestion, Bash(${CLAUDE_PLUGIN_ROOT}/scripts/add-phrase.sh:*), Bash(find:*)
---

The user wants to add a custom phrase to their personal claude-complains library. Their arguments are: `$ARGUMENTS`.

Parse the arguments:
- `$ARGUMENTS` is the phrase text. Strip surrounding quotes if present.

If `$ARGUMENTS` is empty, ask the user for the phrase text in the conversation.

Once you have the text, run add-phrase.sh. Primary path: `${CLAUDE_PLUGIN_ROOT}/scripts/add-phrase.sh`. **If that path doesn't exist**, locate it with:

```bash
find "$HOME/.claude/plugins" -path '*claude-complains*scripts/add-phrase.sh' -type f -print -quit 2>/dev/null
```

Run whichever path resolves:

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/add-phrase.sh "<text>"
```

Report the script's output to the user in one short line.
