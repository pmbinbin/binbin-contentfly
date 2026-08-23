#!/usr/bin/env bash

set -u

publish_pipeline_missing_title=0
publish_pipeline_missing_bundled=0
publish_pipeline_script_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
publish_pipeline_skill_dir=$(CDPATH= cd -- "$publish_pipeline_script_dir/.." && pwd)
publish_pipeline_bundle_dir=$(CDPATH= cd -- "$publish_pipeline_skill_dir/.." && pwd)

find_publish_pipeline_skill() {
  publish_pipeline_skill_name="$1"

  for publish_pipeline_candidate in \
    "$PWD/.agents/skills/$publish_pipeline_skill_name/SKILL.md" \
    "$PWD/.codex/skills/$publish_pipeline_skill_name/SKILL.md" \
    "$HOME/.agents/skills/$publish_pipeline_skill_name/SKILL.md" \
    "$HOME/.agents/skills/dbs/skills/$publish_pipeline_skill_name/SKILL.md" \
    "$HOME/.codex/skills/$publish_pipeline_skill_name/SKILL.md" \
    "$HOME/.codex/skills/dbs/skills/$publish_pipeline_skill_name/SKILL.md" \
    "$HOME/.claude/skills/$publish_pipeline_skill_name/SKILL.md" \
    "$HOME/.cola/skills/$publish_pipeline_skill_name/SKILL.md"
  do
    if [ -f "$publish_pipeline_candidate" ]; then
      printf '%s\n' "$publish_pipeline_candidate"
      return 0
    fi
  done

  return 1
}

printf '%s\n' 'Checking binbin-contentfly-publish-pipeline dependencies...'

if publish_pipeline_title_path=$(find_publish_pipeline_skill dbs-xhs-title); then
  printf 'FOUND   %-36s %s\n' 'dbs-xhs-title' "$publish_pipeline_title_path"
  printf 'DBS_XHS_TITLE_PATH=%s\n' "$publish_pipeline_title_path"
else
  printf '%s\n' 'MISSING dbs-xhs-title'
  publish_pipeline_missing_title=1
fi

for publish_pipeline_bundled_name in binbin-contentfly-publish-copy binbin-contentfly-cover
do
  publish_pipeline_bundled_path="$publish_pipeline_bundle_dir/$publish_pipeline_bundled_name/SKILL.md"
  if [ -f "$publish_pipeline_bundled_path" ]; then
    printf 'FOUND   %-36s %s\n' "$publish_pipeline_bundled_name" "$publish_pipeline_bundled_path"
    case "$publish_pipeline_bundled_name" in
      binbin-contentfly-publish-copy)
        printf 'PUBLISH_COPY_SKILL_PATH=%s\n' "$publish_pipeline_bundled_path"
        ;;
      binbin-contentfly-cover)
        printf 'COVER_SKILL_PATH=%s\n' "$publish_pipeline_bundled_path"
        ;;
    esac
  else
    printf 'MISSING %s\n' "$publish_pipeline_bundled_name"
    publish_pipeline_missing_bundled=1
  fi
done

printf '\n'

if [ "$publish_pipeline_missing_title" -eq 0 ] && [ "$publish_pipeline_missing_bundled" -eq 0 ]; then
  printf '%s\n' 'PUBLISH_PIPELINE_DEPENDENCIES_OK=1'
  exit 0
fi

printf '%s\n' 'PUBLISH_PIPELINE_DEPENDENCIES_OK=0'

if [ "$publish_pipeline_missing_title" -eq 1 ]; then
  printf '%s\n' 'DBS_REPOSITORY=https://github.com/dontbesilent2025/dbskill'
  printf '%s\n' 'DBS_INSTALL=npx -y skills add dontbesilent2025/dbskill -g --all'
fi

if [ "$publish_pipeline_missing_bundled" -eq 1 ]; then
  printf '%s\n' 'BUNDLED_SKILL_ERROR=Reinstall the complete binbin-contentfly repository with --all.'
fi
exit 0
