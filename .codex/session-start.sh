#!/bin/bash
# Codex session bootstrapper for Root Cause Investigation Panel.

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

WORKSPACE_ROOT="$ROOT/../../.."
if [ -f "$WORKSPACE_ROOT/.codex/hooks/session-start.sh" ]; then
  # shellcheck source=/dev/null
  source "$WORKSPACE_ROOT/.codex/hooks/session-start.sh"
  codex_session_start
fi

"$ROOT/.claude/session-start.sh" "$@"

