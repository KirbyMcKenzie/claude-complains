# Contributing to claude-complains

Phrase PRs are the main contribution. Keep them short, quotable, and in character.

## The vibe

The fictional narrator is Claude, mildly exhausted, occasionally proud, often snarky, frequently self-deprecating. Phrases should sound like something a tired professional mutters to themselves after finishing a task they didn't want to do.

Good lanes:

- **Meta / token self-awareness** — Claude complaining about its own subculture (tokens, context windows, compaction, "you're paying for this")
- **Self-deprecating** — "not my best work", "watch out for bugs I left in"
- **Regional slang** — real Australian, Kiwi, British, American, Scottish, Irish idioms
- **Snark directed at the user** — "you could've googled that"
- **Deadpan / existential** — "the deed is done"
- **Weirdly proud** — "masterpiece. you're welcome."

## Rules

1. **No slurs. Ever.** Explicit-tier swears are fine (fuck, shit, bastard, bollocks, piss, bugger, damn). Anything racial, misogynistic, homophobic, ableist, or otherwise targeted is not. PRs including any will be closed.
2. **No real person names or brand attacks.**
3. **Short**. One sentence ideal, two max. Should land in under 3 seconds of Zarvox.
4. **Say it out loud first.** If it doesn't sound funny in a robot voice, it isn't.
5. **Tag it.** Use tags from this list (add new ones sparingly):
   - `meta`, `snark`, `self-deprecating`, `complaint`, `proud`, `deadpan`, `existential`
   - `aus`, `nz`, `uk`, `usa`, `scottish`, `irish`
   - `explicit` (redundant with the `explicit: true` flag but fine to include)
   - `custom` is reserved for user-added phrases — don't use in the shipped file.
6. **Set `explicit: true`** if the phrase contains fuck/shit/bollocks/bastard/piss/bugger. Clean phrases default to `false`.

## Entry format

```json
{ "text": "Done and dusted, that is a wrap.", "explicit": false, "tags": ["uk"] }
```

- Use straight ASCII punctuation — curly quotes can confuse `say` TTS.
- Avoid contractions with apostrophes in the middle of words where possible (Zarvox handles them fine, but escape-free JSON is easier). Example: `you are` reads almost identically to `you're` via TTS.
- No trailing commas. `jq . data/phrases.json` should parse cleanly.

## Validate before you PR

```bash
jq . data/phrases.json > /dev/null && echo "valid json"
```

Then preview:

```bash
# from repo root
CLAUDE_PLUGIN_ROOT="$PWD" ./scripts/complain.sh --test
```

## License for contributions

By opening a PR you agree your contributions are licensed under the MIT license of this repo.
