#!/bin/bash

# ECHELON Workspace Initializer
# Creates the directory structure and copies template files into the current project.
# Run from the project root where you want ECHELON to operate.

set -euo pipefail

# Find the ECHELON fork root (this script lives at echelon/scripts/init-workspace.sh)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ECHELON_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPLATES_DIR="$ECHELON_ROOT/echelon/templates"

# Validate templates exist
if [[ ! -d "$TEMPLATES_DIR" ]]; then
  echo "❌ Error: Templates directory not found at $TEMPLATES_DIR" >&2
  echo "   Are you running this from the ECHELON fork?" >&2
  exit 1
fi

CWD="$(pwd)"

echo ""
echo "████████╗ ██████╗██╗  ██╗███████╗██╗      ██████╗ ███╗   ██╗"
echo "██╔════╝██╔════╝██║  ██║██╔════╝██║     ██╔═══██╗████╗  ██║"
echo "█████╗  ██║     ███████║█████╗  ██║     ██║   ██║██╔██╗ ██║"
echo "██╔══╝  ██║     ██╔══██║██╔══╝  ██║     ██║   ██║██║╚██╗██║"
echo "███████╗╚██████╗██║  ██║███████╗███████╗╚██████╔╝██║ ╚████║"
echo "╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝"
echo ""
echo "Initializing ECHELON workspace in: $CWD"
echo ""

# Check if already initialized
if [[ -f "ECHELON.md" ]] && [[ -f "MISSION_PLAN.md" ]]; then
  echo "⚠️  ECHELON.md and MISSION_PLAN.md already exist."
  echo "   This workspace appears to already be initialized."
  echo "   Delete ECHELON.md and MISSION_PLAN.md to reinitialize."
  exit 1
fi

# Create squad-owned directories
SQUAD_DIRS=(outputs analysis critique synthesis verification judge prompts sitreps)

echo "Creating directory structure..."
for dir in "${SQUAD_DIRS[@]}"; do
  mkdir -p "$dir"
  touch "$dir/.gitkeep"
  echo "  ✓ $dir/"
done

# Copy template files
echo ""
echo "Copying template files..."

cp "$TEMPLATES_DIR/ECHELON.md" ./ECHELON.md
echo "  ✓ ECHELON.md (orchestrator constitution)"

cp "$TEMPLATES_DIR/MISSION_PLAN.md" ./MISSION_PLAN.md
echo "  ✓ MISSION_PLAN.md (task registry — edit to add your tasks)"

cp "$TEMPLATES_DIR/ACTIVITY.md" ./ACTIVITY.md
echo "  ✓ ACTIVITY.md (rolling activity log)"

# Copy prompt templates
cp "$TEMPLATES_DIR/prompts/analyst.md" ./prompts/analyst.template.md
cp "$TEMPLATES_DIR/prompts/critic.md" ./prompts/critic.template.md
cp "$TEMPLATES_DIR/prompts/synthesizer.md" ./prompts/synthesizer.template.md
echo "  ✓ prompts/ (analyst, critic, synthesizer templates)"

# Git add the structure
if git rev-parse --git-dir > /dev/null 2>&1; then
  git add -A > /dev/null 2>&1 || true
  echo ""
  echo "  ✓ Files staged for git"
fi

echo ""
echo "════════════════════════════════════════════════════════"
echo "ECHELON workspace initialized."
echo "════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo ""
echo "  1. Edit MISSION_PLAN.md"
echo "     Replace the example tasks with your actual mission tasks."
echo "     Each task needs: id, echelon, model_tier, task, input_files,"
echo "     output_file, required_sections, depends_on, passes: false"
echo ""
echo "  2. Create prompt files for each task"
echo "     Copy and edit the templates in prompts/*.template.md"
echo "     Save as prompts/[task_id].md"
echo "     These are pre-written — they never change during a session."
echo ""
echo "  3. Add your input files"
echo "     Put source documents, manuscripts, or code in your project."
echo "     Update input_files paths in MISSION_PLAN.md accordingly."
echo ""
echo "  4. Launch the loop"
echo "     /echelon-launch"
echo ""
echo "  Optional — Mercury (1000+ t/s for high-volume tasks):"
echo "     export INCEPTION_API_KEY=your_key_here"
echo "     Get a key at: https://inceptionlabs.ai"
echo "     10M free tokens on signup. \$0.25/\$0.75 per 1M tokens."
echo ""
