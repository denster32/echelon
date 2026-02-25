---
description: "Launch the ECHELON orchestration loop (run /echelon-init first)"
argument-hint: ""
allowed-tools: ["Bash(echelon/scripts/launch-echelon.sh:*)"]
---

# ECHELON Launch

Activate the ralph-wiggum loop with the ECHELON orchestrator prompt.

Requires `ECHELON.md` and `MISSION_PLAN.md` in the current directory.
Run `/echelon-init` first if you haven't initialized this workspace.

```!
echelon/scripts/launch-echelon.sh
```

The loop will:
- Read MISSION_PLAN.md every iteration
- Find the next incomplete task (passes: false)
- Dispatch to the appropriate echelon via prompts/[task_id].md
- Verify output, update plan, write sitrep, commit
- Run for up to 500 iterations
- Stop when all tasks have passes: true and output: `<promise>MISSION COMPLETE</promise>`

Session recovery: if the loop dies, re-run `/echelon-launch`. MISSION_PLAN.md tracks
all completed tasks. The loop resumes from the first task with passes: false.
