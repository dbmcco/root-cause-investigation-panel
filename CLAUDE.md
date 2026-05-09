# Claude Instructions

Before any root cause investigation work, run:

```bash
.claude/session-start.sh
```

To create a new investigation:

```bash
.claude/session-start.sh --new
```

To resume:

```bash
.claude/session-start.sh --investigation RCA-YYYY-NNN
```

Follow `AGENTS.md` and use the `root-cause-investigation` skill. Treat `.claude/config.json` as the panel configuration source of truth.

