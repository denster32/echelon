#!/bin/bash

# ECHELON Launch Script
# Activates the ralph-wiggum loop with the ECHELON orchestrator prompt.
# Run from the project root (where ECHELON.md and MISSION_PLAN.md live).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ECHELON_REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Validate ECHELON workspace
if [[ ! -f "ECHELON.md" ]]; then
  echo "❌ Error: ECHELON.md not found in current directory." >&2
  echo "   Run /echelon-init first to bootstrap this workspace." >&2
  exit 1
fi

if [[ ! -f "MISSION_PLAN.md" ]]; then
  echo "❌ Error: MISSION_PLAN.md not found in current directory." >&2
  echo "   Run /echelon-init first to bootstrap this workspace." >&2
  exit 1
fi

# Locate ralph-wiggum setup script
RALPH_SETUP="$ECHELON_REPO_ROOT/plugins/ralph-wiggum/scripts/setup-ralph-loop.sh"

if [[ ! -f "$RALPH_SETUP" ]]; then
  echo "❌ Error: ralph-wiggum plugin not found at:" >&2
  echo "   $RALPH_SETUP" >&2
  echo "" >&2
  echo "   The ralph-wiggum plugin is required for ECHELON." >&2
  echo "   It should be present in: plugins/ralph-wiggum/" >&2
  exit 1
fi

# Check for any remaining tasks
INCOMPLETE=$(grep -c 'passes: false' MISSION_PLAN.md 2>/dev/null || echo "0")

if [[ "$INCOMPLETE" == "0" ]]; then
  echo "✅ All tasks in MISSION_PLAN.md already have passes: true."
  echo "   Nothing to do. Edit MISSION_PLAN.md to add new tasks."
  exit 0
fi

echo ""
echo "Launching ECHELON orchestration loop..."
echo "  Incomplete tasks: $INCOMPLETE"
echo "  Max iterations: 500"
echo "  Completion promise: MISSION COMPLETE"
echo ""

# The ECHELON orchestrator prompt — fed back every ralph iteration
ECHELON_PROMPT="Read ECHELON.md. Read MISSION_PLAN.md. Find the first task where passes: false and all depends_on tasks have passes: true. Dispatch it to the appropriate echelon using prompts/[task_id].md. Verify the output file exists and contains the required_sections. Update MISSION_PLAN.md: set passes: true for the completed task. Append one line to ACTIVITY.md: timestamp, task_id, echelon, one-line summary, output_file. Write sitreps/[task_id].md with three fields: completed, status, next. Run: git add -A && git commit -m 'Echelon [echelon]: [task_id]'. Repeat for the next incomplete task. Output <promise>MISSION COMPLETE</promise> only when every task in MISSION_PLAN.md has passes: true."

# Activate the ralph loop
bash "$RALPH_SETUP" \
  --max-iterations 500 \
  --completion-promise "MISSION COMPLETE" \
  "$ECHELON_PROMPT"
