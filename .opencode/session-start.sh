#!/bin/bash
# OpenCode session bootstrapper for Root Cause Investigation Panel.

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

"$ROOT/.claude/session-start.sh" "$@"

