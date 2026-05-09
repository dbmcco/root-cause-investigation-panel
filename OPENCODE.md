# OpenCode Instructions

Before any root cause investigation work, run:

```bash
.opencode/session-start.sh
```

To create a new investigation:

```bash
.opencode/session-start.sh --new
```

To resume:

```bash
.opencode/session-start.sh --investigation RCA-YYYY-NNN
```

OpenCode does not use Claude Code's hook model directly. This repo provides OpenCode-compatible project instructions, skill registration, and a session-start script instead.

