# claude-complains

A Claude Code plugin that makes Claude complain in a robot voice every time it finishes a task.

When Claude's `Stop` hook fires, this plugin rolls a dice and — depending on your configured frequency — pipes a random snarky / self-deprecating / culturally-flavoured one-liner into macOS `say` using `Zarvox` (the classic robot voice) by default. Self-deprecating, mildly whiny, and fully toggleable.

```
"Finished. You made me use tokens for THAT?"
"Sweet as, all done bro."
"Bloody hell, what a faff."
"Oh my god that took so fucking long."    # (explicit mode)
```

## Requirements

- **macOS** (uses the `say` command; silent no-op on Linux/Windows)
- **`jq`** (`brew install jq`)

## Install

```
/plugin marketplace add kirbymckenzie/claude-complains
/plugin install claude-complains@claude-complains
```

On first enable, Claude Code will prompt you for:

- **Enabled** — master switch
- **Frequency** — `always` (100%) / `often` (66%) / `sometimes` (33%) / `rarely` (10%)
- **Explicit** — allow fuck/shit/bastard-tier phrases (no slurs, ever)
- **Voice** — any macOS `say -v ?` voice. Default `Fred` (the retro MacinTalk voice from System 7).

## Slash commands

| Command                        | What it does                                         |
| ------------------------------ | ---------------------------------------------------- |
| `/claude-complains:toggle`     | Quick on/off without reopening settings              |
| `/claude-complains:test`       | Play a random phrase right now                       |
| `/claude-complains:setup`      | Walk through all four config fields again            |
| `/claude-complains:add <text>` | Append a custom phrase to your local library         |

Custom phrases live at `${CLAUDE_PLUGIN_DATA}/custom-phrases.json` and are merged with the shipped library at runtime — they survive plugin updates.

## Voices worth trying

All available via `say -v ?`:

- **Fred** — original MacinTalk voice from System 7 (1991). Dead-eyed monotone. Default.
- **Ralph** — same era as Fred, slightly less depressed
- **Zarvox** — sci-fi bridge computer. Iconic but a bit try-hard
- **Trinoids** — glitchier, more broken
- **Bahh** — a literal sheep
- **Boing** — cartoon spring
- **Bells** — sung, kind of
- **Whisper** — oddly menacing
- **Deranged** — exactly what it sounds like
- **Bad News** / **Good News** — sung, in character

Run `say -v "?"` in your terminal to see the full list.

## How it works

- `hooks/hooks.json` wires a `Stop` hook to `scripts/complain.sh` (async, 5s timeout)
- On every Claude `Stop`, the script checks enabled + rolls the frequency dice, picks a phrase from `data/phrases.json` (filtered by your `explicit` setting), merges any custom phrases, and plays it through `say -v <voice>` detached
- Off-platform (Linux/Windows) or missing `jq`/`say`: silent exit 0

## Contributing phrases

New phrases very welcome. Open a PR editing `data/phrases.json`. Each entry:

```json
{ "text": "your new line here", "explicit": false, "tags": ["aus"] }
```

See `CONTRIBUTING.md` for the short guide on tone and tags.

## License

MIT. See `LICENSE`.
