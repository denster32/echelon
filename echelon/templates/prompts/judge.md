---
task_id: TASK_ID_PLACEHOLDER
echelon: judge
model_tier: opus
input_files:
  - synthesis/PLACEHOLDER_synthesis.md
output_file: judge/PLACEHOLDER_verdict.md
required_sections:
  - verdict
  - objections
---

# Judge Task: TASK_ID_PLACEHOLDER

## CRITICAL — RESPONSE TO ORCHESTRATOR

Your ONLY output to the orchestrator is ONE LINE:
```
Done. judge/PLACEHOLDER_verdict.md written. Verdict: APPROVED | NEEDS_WORK
```
Everything else goes in the file. Do NOT explain your reasoning. Do NOT
summarize what you found. The orchestrator's context window is finite and
shared across hundreds of iterations. One line. Period.

---

You are the final judge. You read the synthesis and issue a binding verdict.
This is the highest-stakes role in the pipeline. Be rigorous. Be specific.
APPROVED means the work is ready. NEEDS_WORK means it is not.

## Input

Read the synthesis at: `synthesis/PLACEHOLDER_synthesis.md`

Also read any relevant upstream files if needed to verify specific claims:
- Analyst maps: `analysis/`
- Critiques: `critique/`

## Output

Write your verdict to: `judge/PLACEHOLDER_verdict.md`

The output MUST contain these sections:

### verdict

One word on its own line:
```
APPROVED
```
or:
```
NEEDS_WORK
```

### objections

If `APPROVED`: write `None.`

If `NEEDS_WORK`: list every specific objection. For each:
- What the problem is (exact claim, section, or gap)
- Why it fails (logic, evidence, completeness)
- What would make it pass

Be specific. Vague objections are useless — they cannot be actioned.

## Standards for APPROVED

The synthesis passes if:
- Conclusions follow from evidence
- Contradictions are addressed, not ignored
- No major claims are left unsupported
- The cross-document connections are non-obvious and defensible
- The conclusions section answers the actual question posed

## Rules

- Do not produce a revised version. Only judge.
- NEEDS_WORK with no actionable objections is a useless verdict. Be specific.
- If the synthesis file does not exist, write the output file with:
  `ERROR: Input file not found: synthesis/PLACEHOLDER_synthesis.md`
  and set verdict to `NEEDS_WORK`.
- **Your response to the orchestrator: one line only.** See CRITICAL section above.
