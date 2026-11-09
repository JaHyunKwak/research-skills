# custom-skills

Skills I author myself. Every `custom-skills/<name>/SKILL.md` here is linked into
`~/.claude/skills/<name>` by `setup_research_skills.sh`, so adding a skill is:

```bash
mkdir custom-skills/<name> && $EDITOR custom-skills/<name>/SKILL.md   # or: /skill-creator
git commit -am "skill: <name>" && git push
# on each machine:
bash ~/.claude/skill-sources/research-skills/setup_research_skills.sh --update --no-plugins
```

Rules of thumb (from the Claude Code docs):
- `description` is what Claude reads every turn to decide when to use the skill — put the
  trigger first, keep it under ~2 sentences. The body loads only when invoked.
- Keep `SKILL.md` under ~500 lines; move long reference material into sibling files.
- `user-invocable: false` → background knowledge Claude applies on its own (no `/name`).
- `disable-model-invocation: true` → only you can trigger it (side-effectful workflows).

| skill | purpose | status |
|---|---|---|
| `manuscript-review` | 10-section skeptical pre-submission review (claim ledger, figure–text audit, stats audit, must-fix list) | draft v1 |
| `writing-conventions` | standing Korean/English writing, slide, and feedback conventions | draft v1 |
