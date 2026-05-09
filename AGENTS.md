# Root Cause Investigation Panel

Use the `root-cause-investigation` skill for incidents, postmortems, RCA requests, regressions, recurring failures, surprising metrics, near misses, and "why did this happen?" questions.

## Startup

Before investigation work, run the session bootstrap for your runtime:

```bash
# Claude Code
.claude/session-start.sh

# Codex
.codex/session-start.sh

# OpenCode
.opencode/session-start.sh
```

Use `--new` to create an investigation or `--investigation RCA-YYYY-NNN` to resume one.

## Investigation Rules

- Do not choose a method until the minimum case frame is clear.
- Treat user explanations as inputs, not facts.
- Maintain evidence, mechanism, and uncertainty for every causal claim.
- Keep the method stack provisional and revisable.
- Use domain overlays only when they add evidence requirements or specialist pressure.
- Ask for more input when missing evidence would change causal confidence or action choice.
- Run disconfirmation before synthesis.
- Do not treat "human error," "training," "remind people," or "be careful" as sufficient conclusions.

## Canonical Files

- `README.md` for the user-facing workflow.
- `.claude/config.json` for panel metadata and phase configuration.
- `templates/` for investigation artifacts.
- The globally installed `root-cause-investigation` skill for detailed method and persona guidance.

