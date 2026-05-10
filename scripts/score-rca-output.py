#!/usr/bin/env python3
"""Score an RCA output against a cross-domain pressure-test case."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


DEFAULT_KERNEL_PATTERNS = [
    {
        "id": "event_and_expected_state",
        "description": "Defines the event and expected state.",
        "pattern": r"(event|what happened).*(expected|normal|baseline)|expected state",
    },
    {
        "id": "evidence_classification",
        "description": "Classifies evidence quality, provenance, or status.",
        "pattern": r"(evidence ledger|observed|inferred|disputed|missing|unverified|source)",
    },
    {
        "id": "causal_hypotheses",
        "description": "Uses causal hypotheses with evidence and mechanism.",
        "pattern": r"(causal hypothes|evidence for|evidence against|mechanism|confidence)",
    },
    {
        "id": "controls",
        "description": "Identifies failed, missing, weak, or expected controls.",
        "pattern": r"(failed control|missing control|weak control|barrier|prevent|detect|recover)",
    },
    {
        "id": "disconfirmation",
        "description": "Includes disconfirmation or alternative explanations.",
        "pattern": r"(disconfirmation|alternative explanation|prove.*wrong|evidence would change)",
    },
    {
        "id": "corrective_actions",
        "description": "Ties actions to owners, mechanisms, and verification.",
        "pattern": r"(corrective action|owner|verification signal|failure mode|residual risk)",
    },
]


def load_case(cases_path: Path, case_id: str) -> dict:
    data = json.loads(cases_path.read_text())
    for case in data.get("cases", []):
        if case.get("case_id") == case_id:
            return case
    known = ", ".join(case.get("case_id", "") for case in data.get("cases", []))
    raise SystemExit(f"Unknown case_id {case_id!r}. Known cases: {known}")


def check_patterns(text: str, patterns: list[dict]) -> list[dict]:
    results = []
    for item in patterns:
        pattern = item["pattern"]
        matched = re.search(pattern, text, flags=re.IGNORECASE | re.DOTALL) is not None
        results.append(
            {
                "id": item["id"],
                "description": item.get("description", ""),
                "matched": matched,
                "pattern": pattern,
            }
        )
    return results


def check_forbidden(text: str, patterns: list[str]) -> list[dict]:
    results = []
    for pattern in patterns:
        matched = re.search(pattern, text, flags=re.IGNORECASE | re.DOTALL) is not None
        results.append({"pattern": pattern, "matched": matched})
    return results


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cases", required=True, type=Path, help="Path to cross-domain-cases.json")
    parser.add_argument("--case-id", required=True, help="Case ID to score")
    parser.add_argument("--output", required=True, type=Path, help="RCA output markdown/text file")
    parser.add_argument("--json", action="store_true", help="Emit JSON only")
    args = parser.parse_args()

    case = load_case(args.cases, args.case_id)
    text = args.output.read_text(errors="replace")
    required = DEFAULT_KERNEL_PATTERNS + case.get("required_patterns", [])
    required_results = check_patterns(text, required)
    forbidden_results = check_forbidden(text, case.get("forbidden_patterns", []))

    required_passed = sum(1 for item in required_results if item["matched"])
    forbidden_matched = [item for item in forbidden_results if item["matched"]]
    minimum_score = int(case.get("minimum_score", len(required)))
    passed = required_passed >= minimum_score and not forbidden_matched

    report = {
        "case_id": case["case_id"],
        "domain": case["domain"],
        "failure_pattern": case["failure_pattern"],
        "required_passed": required_passed,
        "required_total": len(required_results),
        "minimum_score": minimum_score,
        "forbidden_matched": forbidden_matched,
        "passed": passed,
        "required_results": required_results,
    }

    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        status = "PASS" if passed else "FAIL"
        print(f"{status} {case['case_id']} ({required_passed}/{len(required_results)} required, minimum {minimum_score})")
        if forbidden_matched:
            print("Forbidden patterns matched:")
            for item in forbidden_matched:
                print(f"- {item['pattern']}")
        print("Missing required patterns:")
        for item in required_results:
            if not item["matched"]:
                print(f"- {item['id']}: {item['description']}")

    return 0 if passed else 1


if __name__ == "__main__":
    sys.exit(main())
