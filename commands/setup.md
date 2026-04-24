---
description: Reconfigure claude-complains (frequency, explicit, voice, enabled)
---

Walk the user through configuring claude-complains. Use `AskUserQuestion` to ask these four questions (one call, all four questions batched so it's one screen):

1. **Enabled?** — options: "on" (default), "off". Header: "Enabled".
2. **Frequency** — options: "always (100%)", "often (66%)", "sometimes (33%)", "rarely (10%)". Header: "Frequency". Default: often.
3. **Explicit language?** — options: "clean" (default), "explicit (fuck/shit/bastard tier)". Header: "Explicit".
4. **Voice** — options: "Fred (retro MacinTalk, default)", "Ralph", "Zarvox", "Trinoids", "Bahh", "Whisper". Header: "Voice". Tell the user they can pick "Other" to enter any macOS `say -v ?` voice name.

After they answer, map their choices to the config keys:
- enabled: "on" → `true`, "off" → `false`
- frequency: strip the percentage → `always`, `often`, `sometimes`, `rarely`
- explicit: "clean" → `false`, "explicit …" → `true`
- voice: strip the parenthetical → `Fred`, `Ralph`, `Zarvox`, `Trinoids`, `Bahh`, `Whisper`, or their custom input

Then run `${CLAUDE_PLUGIN_ROOT}/scripts/set-config.sh` with the key/value pairs they changed. Example:

```
${CLAUDE_PLUGIN_ROOT}/scripts/set-config.sh enabled true frequency often explicit false voice Fred
```

After saving, offer to run `/claude-complains:test` so they can hear the new setting. Keep your response short — one line confirming what was saved.
