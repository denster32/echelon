---
description: "Bootstrap an ECHELON workspace in the current directory"
argument-hint: ""
allowed-tools: ["Bash(echelon/scripts/init-workspace.sh:*)"]
---

# ECHELON Init

Bootstrap an ECHELON workspace in the current working directory.

Creates the squad directory structure, copies the orchestrator constitution (ECHELON.md),
task registry template (MISSION_PLAN.md), activity log (ACTIVITY.md), and prompt templates.

```!
echelon/scripts/init-workspace.sh
```

After initialization:
1. Edit `MISSION_PLAN.md` to add your actual mission tasks
2. Create `prompts/[task_id].md` for each task (use templates in `prompts/*.template.md`)
3. Add your input files (manuscripts, source documents, code)
4. Run `/echelon-launch` to start the orchestration loop
