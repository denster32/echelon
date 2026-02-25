#!/bin/bash

# ECHELON PreToolUse Enforcement Hook
# Intercepts CO write attempts to squad-owned directories
# and redirects to subagent dispatch.
#
# Activates only when ECHELON.md + MISSION_PLAN.md exist in cwd.
# Squad-owned directories: outputs/ analysis/ critique/ synthesis/ verification/ judge/

set -euo pipefail

# Read hook input from stdin
HOOK_INPUT=$(cat)

# Only activate in ECHELON mode (both sentinel files must exist)
if [[ ! -f "ECHELON.md" ]] || [[ ! -f "MISSION_PLAN.md" ]]; then
  exit 0
fi

# Extract tool name
TOOL_NAME=$(echo "$HOOK_INPUT" | jq -r '.tool_name // empty' 2>/dev/null)

# Only intercept write-type tools
if [[ "$TOOL_NAME" != "Write" ]] && [[ "$TOOL_NAME" != "Edit" ]] && [[ "$TOOL_NAME" != "MultiEdit" ]]; then
  exit 0
fi

# Extract file path (consistent field name across Write, Edit, MultiEdit)
FILE_PATH=$(echo "$HOOK_INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Normalize path: strip leading ./
FILE_PATH="${FILE_PATH#./}"

# Squad-owned directories — CO cannot write here directly
SQUAD_DIRS=(
  "outputs/"
  "analysis/"
  "critique/"
  "synthesis/"
  "verification/"
  "judge/"
)

# Check if the target path falls under a squad-owned directory
for dir in "${SQUAD_DIRS[@]}"; do
  if [[ "$FILE_PATH" == "$dir"* ]]; then
    # Block and explain
    jq -n \
      --arg file "$FILE_PATH" \
      --arg dir "$dir" \
      '{
        "decision": "block",
        "systemMessage": ("ECHELON ENFORCEMENT: Direct write to squad-owned directory blocked.\n\nYou attempted to write to: " + $file + "\nThis directory (" + $dir + ") is owned by specialist squads — not the CO.\n\nYour role is to DISPATCH, not execute.\n\nRequired action:\n  1. Identify the task_id for this work\n  2. Read prompts/[task_id].md (pre-written prompt file)\n  3. Spawn a Task subagent with that prompt\n  4. The subagent writes the output file\n  5. Verify the output file exists with required_sections\n  6. Update MISSION_PLAN.md: passes: true\n  7. Write sitreps/[task_id].md (3 fields: completed, status, next)\n  8. git commit with message: Echelon [role]: [task_id]\n\nNever write directly to: outputs/ analysis/ critique/ synthesis/ verification/ judge/")
      }'
    exit 0
  fi
done

# Not a squad directory — allow
exit 0
