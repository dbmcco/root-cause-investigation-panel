# Root Cause Investigation Panel

A Claude Code / Codex-powered causal investigation system for incidents, failures, regressions, recurring problems, near misses, and postmortems. It combines classic root cause analysis methods with evidence discipline, specialist personas, method-specific structured data, and formal corrective-action review.

## Overview

This is a structured causal investigation tool based on root cause analysis, safety science, reliability engineering, human factors, and model-mediated panel review. It features:

- **Dr. Miriam Adler** (Investigation Lead) - Facilitates a formal, evidence-governed causal investigation workflow
- **Evidence-First Intake** - Separates observed facts, user beliefs, inference, missing evidence, and contested claims
- **Adaptive Method Stack** - Uses RCA methods as instruments rather than forcing one fixed methodology
- **Detailed Specialist Panel** - Named personas for evidence stewardship, timeline/change analysis, systems and human factors, fault logic, control structure, corrective actions, and disconfirmation
- **Domain Overlays** - Selectable specialists for software/SRE, security, healthcare, manufacturing, finance, product/growth, organizational process, and household systems
- **Structured Method Data** - Fishbone, 5 Whys, fault tree, barrier analysis, timeline, change analysis, and STAMP-style work produce hypothesis data, not just prose diagrams
- **Evidence Gap Loop** - The panel can pause mid-investigation, request specific missing inputs, and resume with amended artifacts
- **Action Quality Review** - Corrective actions must map to supported causal mechanisms and include verification signals
- **Two-Agent tmux Mode** - A coding agent can spin up a second tmux pane as the RCA panel, interact with it as the incident owner, and consume a structured handoff for implementation
- **Anti-Blame Guardrails** - Human error is treated as a symptom label, not an endpoint

## Recommended Mode for Code Problems

For code and agent-system failures, use the RCA panel as a second agent rather
than as a passive report generator.

The effective pattern is:

1. Keep your implementation agent in the working repo/session.
2. Start a second tmux pane or session for the RCA panel.
3. Have the implementation agent describe the incident, current hypothesis,
   suspected fix, relevant files/repos, evidence, and open questions.
4. Let the RCA panel challenge the causal model, ask for missing inputs, and
   return implementation-control feedback.
5. Feed the panel output back into the implementation agent as tests, WorkGraph
   tasks, validation gates, or code-review criteria.

The panel should write or return an `agent-handoff.md`-style output that the
first agent can consume directly:

```text
claim -> evidence class -> owner surface -> gate level -> command/gate -> required artifact fields -> pass/fail -> residual risk
```

Use this mode when the main agent is actively fixing a code problem and needs an
independent RCA panel to pressure-test the explanation before the fix hardens.

## The "Evidence-Mechanism-Action" Architecture

```text
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 0: CASE FRAMING                                          │
│  Define event, impact, boundary, evidence, uncertainty, and      │
│  the decision the investigation must support                    │
│  OUTPUT: intake.md                                              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 1: EVIDENCE LEDGER + SEQUENCE                            │
│  Record provenance, reconstruct timeline, identify changes,      │
│  separate observed facts from inference                         │
│  OUTPUT: evidence-ledger.md, timeline.md                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 2: PROVISIONAL METHOD STACK                              │
│  Select a revisable combination of methods based on case shape   │
│  OUTPUT: method-stack.md                                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 3: EVIDENCE-LED CAUSAL ANALYSIS                          │
│  Use selected methods to build and test causal hypotheses        │
│  OUTPUT: causal-hypotheses.md, method-analyses/                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 4: DISCONFIRMATION + GAP RESOLUTION                      │
│  Challenge leading explanations, request missing evidence,       │
│  and mark residual uncertainty                                  │
│  OUTPUT: disconfirmation.md, evidence-gaps.md                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 5: SYNTHESIS + CORRECTIVE ACTIONS                        │
│  Separate triggers, contributing conditions, failed controls,    │
│  systemic causes, and action mechanisms                         │
│  OUTPUT: causal-synthesis.md, corrective-actions.md             │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

### 1. Clone and Start Your Agent

```bash
git clone https://github.com/dbmcco/root-cause-investigation-panel.git
cd root-cause-investigation-panel
# Start Claude Code or Codex conversation
```

### 2. Describe the Incident or Failure

Start with a plain-language description:

```text
"We had a production outage yesterday after a deployment and I want a postmortem."
```

or

```text
"Our onboarding activation dropped 20% after the last release and we do not know why."
```

or

```text
"I want to understand why this recurring process breakdown keeps happening."
```

### 3. Dr. Adler Handles the Investigation

She will:

1. Frame the case and clarify what decision the investigation must support
2. Inventory evidence and uncertainty before choosing methods
3. Select a provisional method stack
4. Activate the relevant specialist panel and domain overlays
5. Track causal hypotheses with evidence, counterevidence, mechanisms, and confidence limits
6. Request more input when a gap affects causal confidence or action choice
7. Run disconfirmation before synthesis
8. Produce corrective actions that map to supported causal mechanisms

The panel should not promise a definitive single root cause. It should produce decision-grade causal learning.

---

## Agent Runbook (Claude/Codex)

Use this section if you are operating as the investigation agent inside this repo.

### Runtime support

This repo mirrors the Shell Scenario Panel's operating pattern for Claude Code and Codex: agent-specific instruction files, session bootstrap scripts, panel config, and lightweight hook scripts.

OpenCode uses `AGENTS.md`, `opencode.json`, global/project skills, and `.opencode/session-start.sh`. OpenCode does not currently expose the same native Claude Code hook model, so the repo provides equivalent startup guidance and skill permissions rather than claiming hook parity.

### 1. Start with case framing

Do not select a method until the minimum case frame is clear:

- Event definition: what happened, when, where, and what changed from expected operation
- Consequence and decision need: harm, loss, near miss, customer impact, compliance exposure, disruption, or learning goal
- System boundary: people, software, process, equipment, policy, vendors, environment, organization
- Evidence inventory: logs, timelines, interviews, records, metrics, tickets, artifacts, observations
- Known uncertainty: missing, disputed, inferred, sensitive, or politically constrained information
- Recurrence question: explanation, prevention, accountability, redesign, learning, or documentation
- Action authority: what the user can actually change

### 2. Choose a provisional method stack

Do not ask "which RCA method should we use?" Ask what the case shape requires.

Examples:

- Production outage: timeline + change analysis + barrier analysis + software/SRE overlay
- Recurring process breakdown: timeline + fishbone + systems/human factors + corrective action review
- Technical component failure: timeline + fault tree + barrier analysis
- Safety or near miss: timeline + barrier analysis + human factors + control-structure analysis
- Strategic or organizational failure: timeline + systems map + governance overlay + disconfirmation
- Metric surprise: metric definition review + change analysis + product/growth overlay + alternative hypotheses

### 3. Maintain a causal hypothesis register

Every causal hypothesis should include:

- hypothesis statement
- evidence for
- evidence against
- mechanism connecting it to the event
- causal role
- confidence
- open questions
- tests or corroboration
- actionability

Method artifacts do not become conclusions until they are represented in the register.

### 4. Use the evidence gap loop

When missing evidence matters, classify it:

- `blocking` - cannot proceed responsibly
- `material` - can proceed with reduced confidence
- `optional` - useful but not necessary

Ask for the top three decision-relevant missing inputs first. After new evidence arrives, update the evidence ledger and amend the affected artifact.

### 5. Run disconfirmation before synthesis

Before recommending actions, ask:

- What alternative explanation fits the same facts?
- What evidence would prove the leading hypothesis wrong?
- What cause is plausible but unsupported?
- Where is sequence being mistaken for causation?
- Where are we overfitting to the user's first story?

### 6. Use two-agent tmux mode for code problems

For implementation work, the most effective operating mode is often a two-agent
tmux loop:

1. The implementation agent stays in the product/code session and represents the
   user, system owner, and current implementation context.
2. A second tmux pane/session starts an RCA panel agent with this repo or the
   `root-cause-investigation` skill.
3. The implementation agent sends the incident brief, observed evidence,
   suspected fix, open questions, and target repo/files to the panel.
4. The RCA panel asks focused follow-up questions, challenges the causal model,
   identifies evidence gaps, and returns implementation-control feedback.
5. The implementation agent converts that feedback into tests, WorkGraph tasks,
   code changes, or validation gates.

Use tmux transport directly when helpful:

```bash
tmux send-keys -t <session>:<window>.<pane> "<RCA panel prompt>" Enter
tmux capture-pane -p -t <session>:<window>.<pane> | tail -120
```

The panel output must be consumable by the initiating agent. Prefer writing an
artifact such as `agent-handoff.md` in the investigation folder, or returning a
copyable handoff block in the pane. The handoff should include:

- claims and evidence classes
- owner surfaces, ideally repo/file/function when known
- gate level: `unit`, `scenario`, `live-browser`, `audit`, or `manual`
- required artifact fields to persist or inspect
- pass/fail conditions and residual risks
- model-mediated boundary notes when semantic judgment is involved

This mode keeps the implementation agent in the code path while giving the RCA
panel enough independence to challenge assumptions before the fix hardens.

### 7. Pressure-test across domains

Use `evals/cross-domain-cases.json` to test whether the panel preserves the same RCA kernel while adapting domain evidence and controls. The included cases cover insufficient intake, software contract boundaries, manufacturing traceability, healthcare handoffs, finance approval ledgers, and security identity context.

Run an agent against one case prompt, save the output, then score the structure:

```bash
python3 scripts/score-rca-output.py \
  --cases evals/cross-domain-cases.json \
  --case-id software-contract-boundary \
  --output /path/to/agent-output.md
```

The scorer checks for structural controls such as evidence classification, causal hypotheses, control maps, disconfirmation, corrective actions, domain-specific evidence, falsification gates, and forbidden failure patterns. It is not a semantic judge; use it as a first-pass gate before human review.

---

## Recommended Input Documents

Place materials in `resources/` before starting. The panel performs best when grounded in concrete evidence.

### Required (Investigation Foundation)

| Document | Why It Matters |
|----------|---------------|
| **Incident or Problem Brief** | Defines what happened, the impact, the time window, and why the investigation matters |
| **Evidence Inventory** | Lists available logs, tickets, notes, metrics, records, interviews, artifacts, or screenshots |
| **Known Timeline** | Captures what is already known about sequence, transitions, and detection |

### High-Value (Improves Causal Confidence)

| Document | Why It Matters |
|----------|---------------|
| **Change Records** | Deployments, process changes, staffing changes, policy changes, vendor changes, or environmental shifts |
| **Control/Barrier List** | Alerts, reviews, approvals, checks, policies, backups, escalation paths, or recovery mechanisms |
| **Stakeholder Accounts** | What different participants saw, knew, intended, and could reasonably do at the time |
| **System or Process Map** | Shows dependencies, handoffs, ownership, control points, and feedback loops |

### Nice-to-Have (Adds Depth)

| Document | Why It Matters |
|----------|---------------|
| **Prior Incidents or Near Misses** | Reveals recurrence, drift, weak controls, or repeated local adaptations |
| **Policies and Runbooks** | Helps compare work-as-imagined with work-as-done |
| **Metrics Definitions** | Prevents metric surprises from being misread as operational failures |
| **Authority/Ownership Notes** | Helps produce actions the user can actually implement |

### Format Tips

- Include dates and time zones where possible
- Label facts separately from assumptions
- Include contradictory accounts rather than smoothing them out
- Preserve raw evidence when available
- Note what is missing or politically sensitive

---

## Workflow

### Phase 0: Case Framing

**Purpose:** Establish enough context to avoid premature method selection.

**Output:** `intake.md`

### Phase 1: Evidence Ledger and Timeline

**Purpose:** Separate source evidence from interpretation and reconstruct the sequence of events.

**Outputs:** `evidence-ledger.md`, `timeline.md`

### Phase 2: Provisional Method Stack

**Purpose:** Select a revisable combination of methods.

**Output:** `method-stack.md`

Methods may include:

- Timeline analysis
- Change analysis
- 5 Whys
- Ishikawa / fishbone
- Fault tree
- Barrier analysis
- Systems / causal loop mapping
- Human factors / just culture review
- STAMP-style control analysis

### Phase 3: Causal Analysis

**Purpose:** Build causal hypotheses with evidence, mechanism, uncertainty, and testability.

**Outputs:** `causal-hypotheses.md`, `method-analyses/`

### Phase 4: Evidence Gaps and Disconfirmation

**Purpose:** Prevent overfit narratives and request additional evidence when needed.

**Outputs:** `evidence-gaps.md`, `disconfirmation.md`

### Phase 5: Synthesis and Corrective Actions

**Purpose:** Produce a decision-grade explanation and actions that change future system behavior.

**Outputs:** `causal-synthesis.md`, `corrective-actions.md`, `learning-review.md`

---

## Core Specialist Team

Each specialist brings a distinct lens and characteristic blind spots:

| Specialist | Focus Area | Strengths |
|------------|------------|-----------|
| **Miriam Adler** | Investigation Lead | Phase discipline, causal humility, user checkpoints |
| **Aiko Mori** | Evidence Steward | Provenance, confidence, contradiction tracking |
| **Kenji Takahashi** | Timeline and Change | Sequence, deltas, transitions, last-known-good states |
| **Ingrid Rasmussen** | Systems and Human Factors | Local rationality, work design, incentives, workload, interfaces |
| **Eleanor Watson** | Fault Logic and Dependencies | Necessary conditions, dependency paths, common-cause failures |
| **Amelia Levenson** | Control Structure and Systems Safety | Feedback, constraints, control actions, system observability |
| **Marcus Reed** | Corrective Action Review | Control strength, owners, verification signals, action failure modes |
| **Samira Qureshi** | Disconfirmation | Alternative explanations, overfit narratives, premature convergence |

## Domain Overlays

Activate one or two overlays when the case requires domain-specific evidence:

| Specialist | Domain |
|------------|--------|
| **Maya Srinivasan** | Software / SRE reliability |
| **Talia Ben-Ami** | Security incident analysis |
| **Sofia Alvarez** | Healthcare and clinical safety |
| **Hiroshi Watanabe** | Manufacturing and operations |
| **Nadia El-Masri** | Finance and risk controls |
| **Grace Okonkwo** | Organizational process and governance |
| **Elena Petrescu** | Product and growth failure analysis |
| **Marisol Vega** | Household and personal systems impact |

## Structured Method Data

The panel treats method outputs as structured data. For example, Ishikawa/fishbone analysis is not a freeform diagram. Each factor should include:

- factor statement
- category
- evidence for
- evidence against
- mechanism
- status: observed, inferred, contested, or unsupported
- causal role
- confidence
- open questions
- possible tests
- related factors
- actionability

Categories are containers, not causes. "People" is not a cause. "Operator did not notice alert" is not yet a cause. A better hypothesis is: "Alert design and escalation policy allowed a critical signal to remain indistinguishable from routine noise during high workload; this delayed response."

## Output Artifacts

Substantial investigations may create:

```text
investigations/active/RCA-YYYY-NNN/
  intake.md
  evidence-ledger.md
  method-stack.md
  timeline.md
  causal-hypotheses.md
  method-analyses/
  evidence-gaps.md
  disconfirmation.md
  field-contract-map.md
  scenario-evidence.md
  agent-handoff.md
  causal-synthesis.md
  corrective-actions.md
  learning-review.md
  metadata.json
```

Not every case needs every artifact. Compact rigor is preferred over maximal ceremony.

## Red Lines

The panel should not:

- Promise a definitive root cause
- Default to 5 Whys
- Treat fishbone branches as causes
- Treat absence of evidence as evidence of absence
- Treat human error as a terminal explanation
- Accept "training," "remind people," "be careful," or "add a checklist" as sufficient corrective action without testing control strength
- Hide uncertainty to make the output feel complete
- Invent domain facts through personas

## Philosophy

Root cause analysis often fails when it turns incomplete evidence into a tidy story. This project is designed to do the opposite: preserve uncertainty, make evidence visible, test mechanisms, challenge comfortable explanations, and produce actions that measurably improve the system.
