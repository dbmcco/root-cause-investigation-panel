#!/bin/bash
# Initialize a root cause investigation workspace.

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

YEAR=$(date +%Y)
NEXT_NUM=1
while [ -d "investigations/active/RCA-$YEAR-$(printf '%03d' "$NEXT_NUM")" ] || \
      [ -d "investigations/archived/RCA-$YEAR-$(printf '%03d' "$NEXT_NUM")" ]; do
  NEXT_NUM=$((NEXT_NUM + 1))
done

INVESTIGATION_ID="RCA-$YEAR-$(printf '%03d' "$NEXT_NUM")"
INVESTIGATION_DIR="investigations/active/$INVESTIGATION_ID"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

mkdir -p "$INVESTIGATION_DIR/method-analyses"

for template in intake evidence-ledger method-stack timeline causal-hypotheses evidence-gaps disconfirmation causal-synthesis corrective-actions learning-review; do
  cp "templates/$template.md" "$INVESTIGATION_DIR/$template.md"
done

cat > "$INVESTIGATION_DIR/metadata.json" <<EOF
{
  "id": "$INVESTIGATION_ID",
  "created_at": "$TIMESTAMP",
  "status": "active",
  "phase": "case_framing",
  "domain_overlays": [],
  "method_stack": [],
  "evidence_gap_count": 0,
  "provisional": true,
  "next_action": "begin_case_framing"
}
EOF

echo "Investigation initialized: $INVESTIGATION_ID"
echo "Location: $INVESTIGATION_DIR"
echo "Next: use the root-cause-investigation skill and begin case framing."

