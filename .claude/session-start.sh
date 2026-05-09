#!/bin/bash
# Claude session bootstrapper for Root Cause Investigation Panel.

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

INVESTIGATION_ID=""
SESSION_MODE="planning"

if [ "${1:-}" = "--investigation" ]; then
  INVESTIGATION_ID="${2:-}"
  if [ -z "$INVESTIGATION_ID" ]; then
    echo "Usage: $0 --investigation RCA-YYYY-NNN" >&2
    exit 1
  fi
  if [ ! -d "$ROOT/investigations/active/$INVESTIGATION_ID" ]; then
    echo "Investigation not found: investigations/active/$INVESTIGATION_ID" >&2
    exit 1
  fi
elif [ "${1:-}" = "--new" ]; then
  "$ROOT/.claude/investigation-init.sh"
  INVESTIGATION_DIR=$(ls -td "$ROOT"/investigations/active/RCA-* 2>/dev/null | head -n1 || true)
  if [ -z "$INVESTIGATION_DIR" ]; then
    echo "No active investigation directory found." >&2
    exit 1
  fi
  INVESTIGATION_ID="$(basename "$INVESTIGATION_DIR")"
else
  echo "Model-mediated selection required."
  echo "Decide whether to resume an existing investigation or create a new one."
  echo ""
  "$ROOT/.claude/list-investigations.sh"
  echo "To resume: $0 --investigation RCA-YYYY-NNN"
  echo "To create new: $0 --new"
  exit 0
fi

RESOURCE_COUNT=0
if [ -d "$ROOT/resources" ]; then
  RESOURCE_COUNT=$(find "$ROOT/resources" -type f \
    ! -name "README.md" \
    ! -name ".gitkeep" \
    ! -name ".DS_Store" | wc -l | tr -d ' ')
fi

if [ "$RESOURCE_COUNT" -gt 0 ]; then
  echo "Resources detected ($RESOURCE_COUNT files). Ask the user which materials to treat as evidence."
else
  echo "No resources found; proceed with evidence inventory during case framing."
fi

echo "INVESTIGATION_ID=$INVESTIGATION_ID"
echo "SESSION_MODE=$SESSION_MODE"
echo "Next: use the root-cause-investigation skill for case framing."

