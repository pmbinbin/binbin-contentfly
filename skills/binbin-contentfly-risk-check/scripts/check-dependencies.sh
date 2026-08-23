#!/usr/bin/env bash

set -u

task_script_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
task_skill_dir=$(CDPATH= cd -- "$task_script_dir/.." && pwd)
task_reference_path="$task_skill_dir/references/video-risk-rules.md"
task_missing_reference=0

find_skill_file() {
  task_skill_name="$1"

  for task_candidate in \
    "$PWD/.agents/skills/$task_skill_name/SKILL.md" \
    "$PWD/.codex/skills/$task_skill_name/SKILL.md" \
    "$HOME/.agents/skills/$task_skill_name/SKILL.md" \
    "$HOME/.agents/skills/dbs/skills/$task_skill_name/SKILL.md" \
    "$HOME/.codex/skills/$task_skill_name/SKILL.md" \
    "$HOME/.codex/skills/dbs/skills/$task_skill_name/SKILL.md" \
    "$HOME/.claude/skills/$task_skill_name/SKILL.md" \
    "$HOME/.cola/skills/$task_skill_name/SKILL.md"
  do
    if [ -f "$task_candidate" ]; then
      printf '%s\n' "$task_candidate"
      return 0
    fi
  done

  return 1
}

printf '%s\n' 'Checking binbin-contentfly-risk-check dependencies...'

if [ -f "$task_reference_path" ]; then
  printf 'FOUND   %-24s %s\n' 'video-risk-rules' "$task_reference_path"
else
  printf 'MISSING %s\n' 'references/video-risk-rules.md'
  task_missing_reference=1
fi

if task_skill_path=$(find_skill_file dbs-content-risk-check); then
  printf 'FOUND   %-24s %s\n' 'dbs-content-risk-check' "$task_skill_path"
  printf 'DBS_CONTENT_RISK_CHECK_PATH=%s\n' "$task_skill_path"
  task_dbs_found=1
else
  printf '%s\n' 'MISSING dbs-content-risk-check'
  task_dbs_found=0
fi

if [ "$task_dbs_found" -eq 1 ] && [ "$task_missing_reference" -eq 0 ]; then
  printf '%s\n' 'RISK_CHECK_DEPENDENCIES_OK=1'
  exit 0
fi

printf '%s\n' 'RISK_CHECK_DEPENDENCIES_OK=0'

if [ "$task_missing_reference" -eq 1 ]; then
  printf '%s\n' 'BUNDLED_REFERENCE_ERROR=Reinstall the complete binbin-contentfly repository.'
fi

if [ "$task_dbs_found" -eq 0 ]; then
  printf '%s\n' 'Install only after the user confirms:'
  printf '%s\n' 'DBS_REPOSITORY=https://github.com/dontbesilent2025/dbskill'
  printf '%s\n' 'DBS_INSTALL=npx -y skills add dontbesilent2025/dbskill -g --all'
fi

exit 0
