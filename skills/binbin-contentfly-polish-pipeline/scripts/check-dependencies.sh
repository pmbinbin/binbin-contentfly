#!/usr/bin/env bash

set -u

task_missing_dbs=0
task_missing_renwei=0
task_missing_bundled_risk=0
task_script_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
task_skill_dir=$(CDPATH= cd -- "$task_script_dir/.." && pwd)
task_risk_skill_dir="$task_skill_dir/../binbin-contentfly-risk-check"

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

printf '%s\n' 'Checking binbin-contentfly-polish-pipeline dependencies...'

if [ -f "$task_risk_skill_dir/SKILL.md" ] && [ -f "$task_risk_skill_dir/references/video-risk-rules.md" ]; then
  printf 'FOUND   %-20s %s\n' 'binbin-risk-bundle' "$task_risk_skill_dir"
else
  printf '%s\n' 'MISSING binbin-contentfly-risk-check or its bundled video-risk-rules reference'
  task_missing_bundled_risk=1
fi

for task_skill_name in dbs-content dbs-hook dbs-script-flow dbs-xhs-title dbs-content-risk-check
do
  if task_skill_path=$(find_skill_file "$task_skill_name"); then
    printf 'FOUND   %-20s %s\n' "$task_skill_name" "$task_skill_path"
  else
    printf 'MISSING %s\n' "$task_skill_name"
    task_missing_dbs=1
  fi
done

if task_skill_path=$(find_skill_file renwei-writing); then
  printf 'FOUND   %-20s %s\n' 'renwei-writing' "$task_skill_path"
else
  printf '%s\n' 'MISSING renwei-writing'
  task_missing_renwei=1
fi

printf '\n'

if [ "$task_missing_dbs" -eq 0 ] && [ "$task_missing_renwei" -eq 0 ] && [ "$task_missing_bundled_risk" -eq 0 ]; then
  printf '%s\n' 'DEPENDENCIES_OK=1'
  exit 0
fi

printf '%s\n' 'DEPENDENCIES_OK=0'
printf '%s\n' 'Install only after the user confirms:'

if [ "$task_missing_dbs" -eq 1 ]; then
  printf '%s\n' 'DBS_REPOSITORY=https://github.com/dontbesilent2025/dbskill'
  printf '%s\n' 'DBS_INSTALL=npx -y skills add dontbesilent2025/dbskill -g --all'
fi

if [ "$task_missing_renwei" -eq 1 ]; then
  printf '%s\n' 'RENWEI_REPOSITORY=https://github.com/orange2ai/renwei-writing'
  printf '%s\n' 'RENWEI_INSTALL=git clone https://github.com/orange2ai/renwei-writing.git ~/.cola/skills/renwei-writing'
fi

if [ "$task_missing_bundled_risk" -eq 1 ]; then
  printf '%s\n' 'BUNDLED_SKILL_ERROR=Reinstall the complete binbin-contentfly repository with --all.'
fi

exit 0
