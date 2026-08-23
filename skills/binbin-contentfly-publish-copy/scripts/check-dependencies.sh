#!/usr/bin/env bash

set -u

task_script_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
task_skill_dir=$(CDPATH= cd -- "$task_script_dir/.." && pwd)
task_skills_dir=$(CDPATH= cd -- "$task_skill_dir/.." && pwd)

renwei_candidate_paths=(
  "${HOME}/.codex/skills/renwei-writing"
  "${HOME}/.agents/skills/renwei-writing"
  "${HOME}/.cola/skills/renwei-writing"
  "${HOME}/.codex/skills/dbs/skills/renwei-writing"
  "${HOME}/.agents/skills/dbs/skills/renwei-writing"
)

task_renwei_found=0
task_risk_check_found=0

for candidate_path in "${renwei_candidate_paths[@]}"; do
  if [[ -f "${candidate_path}/SKILL.md" ]]; then
    printf 'RENWEI_WRITING_PATH=%s\n' "${candidate_path}"
    task_renwei_found=1
    break
  fi
done

risk_check_candidate_paths=(
  "${task_skills_dir}/binbin-contentfly-risk-check/SKILL.md"
  "${HOME}/.agents/skills/binbin-contentfly-risk-check/SKILL.md"
  "${HOME}/.codex/skills/binbin-contentfly-risk-check/SKILL.md"
)

for candidate_path in "${risk_check_candidate_paths[@]}"; do
  if [[ -f "${candidate_path}" ]]; then
    printf 'RISK_CHECK_SKILL_PATH=%s\n' "${candidate_path}"
    task_risk_check_found=1
    break
  fi
done

if [[ "${task_renwei_found}" -eq 1 && "${task_risk_check_found}" -eq 1 ]]; then
  printf 'PUBLISH_COPY_DEPENDENCIES_OK=1\n'
  exit 0
fi

if [[ "${task_renwei_found}" -eq 0 ]]; then
  printf 'RENWEI_WRITING_PATH=\n'
  printf 'MISSING=renwei-writing\n'
fi

if [[ "${task_risk_check_found}" -eq 0 ]]; then
  printf 'RISK_CHECK_SKILL_PATH=\n'
  printf 'MISSING=binbin-contentfly-risk-check\n'
fi

printf 'PUBLISH_COPY_DEPENDENCIES_OK=0\n'
exit 0
