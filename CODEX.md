# Codex Instructions

Before any root cause investigation work, run:

```bash
.codex/session-start.sh
```

To create a new investigation:

```bash
.codex/session-start.sh --new
```

To resume:

```bash
.codex/session-start.sh --investigation RCA-YYYY-NNN
```

Follow `AGENTS.md` and use the `root-cause-investigation` skill. Treat `.claude/config.json` as the panel configuration source of truth.

