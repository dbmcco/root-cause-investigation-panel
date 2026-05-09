#!/bin/bash
# List active root cause investigations.

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! ls investigations/active/RCA-* >/dev/null 2>&1; then
  echo "No active investigations."
  exit 0
fi

for dir in investigations/active/RCA-*; do
  id="$(basename "$dir")"
  phase="$(jq -r '.phase // "unknown"' "$dir/metadata.json" 2>/dev/null || echo "unknown")"
  status="$(jq -r '.status // "unknown"' "$dir/metadata.json" 2>/dev/null || echo "unknown")"
  echo "$id  status=$status  phase=$phase"
done

