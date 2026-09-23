#!/usr/bin/env bash
set -euo pipefail

user_dir="$(python3 -c 'from pathlib import Path; print(Path.home())')"
codex_dir="${CODEX_HOME:-$user_dir/.codex}"
codex_skills_dir="$codex_dir/skills"
agents_skills_dir="$user_dir/.agents/skills"
installer="$codex_skills_dir/.system/skill-installer/scripts/install-skill-from-github.py"

find_skill() {
  local skill_name="$1"
  local root
  local skill_file

  for root in "$codex_skills_dir" "$agents_skills_dir"; do
    [[ -d "$root" ]] || continue
    while IFS= read -r skill_file; do
      if awk -v expected="$skill_name" '
        NR == 1 && $0 != "---" { exit }
        NR > 1 && $0 == "---" { exit }
        NR > 1 && $0 ~ /^name:[[:space:]]*/ {
          value = $0
          sub(/^name:[[:space:]]*/, "", value)
          gsub(/^["'\'' ]+|["'\'' ]+$/, "", value)
          if (value == expected) found = 1
        }
        END { exit(found ? 0 : 1) }
      ' "$skill_file"; then
        printf '%s\n' "$skill_file"
        return 0
      fi
    done < <(find "$root" -maxdepth 7 -type f -name SKILL.md -print 2>/dev/null)
  done

  return 1
}

install_skill() {
  local skill_name="$1"

  if [[ ! -f "$installer" ]]; then
    printf 'DEPENDENCY_INSTALL_ERROR=%s\n' "Codex skill-installer not found: $installer" >&2
    return 1
  fi

  mkdir -p "$codex_skills_dir"

  case "$skill_name" in
    khazix-writer)
      python3 "$installer" \
        --repo KKKKhazix/khazix-skills \
        --path khazix-writer \
        --dest "$codex_skills_dir"
      ;;
    gzh-design)
      python3 "$installer" \
        --repo isjiamu/gzh-design-skill \
        --path . \
        --name gzh-design \
        --dest "$codex_skills_dir"
      ;;
    baoyu-cover-image)
      python3 "$installer" \
        --repo JimLiu/baoyu-skills \
        --path skills/baoyu-cover-image \
        --dest "$codex_skills_dir"
      ;;
    *)
      printf 'DEPENDENCY_INSTALL_ERROR=Unknown dependency: %s\n' "$skill_name" >&2
      return 1
      ;;
  esac
}

ensure_skill() {
  local skill_name="$1"
  local output_key="$2"
  local repo_url="$3"
  local found_path

  if found_path="$(find_skill "$skill_name")"; then
    printf '%s=%s\n' "$output_key" "$found_path"
    printf 'DEPENDENCY_STATUS_%s=already_installed\n' "${output_key%_PATH}"
    return 0
  fi

  printf 'DEPENDENCY_MISSING=%s\n' "$skill_name"
  printf 'DEPENDENCY_INSTALL_SOURCE=%s\n' "$repo_url"

  if ! install_skill "$skill_name"; then
    printf 'DEPENDENCY_INSTALL_FAILED=%s\n' "$skill_name" >&2
    return 1
  fi

  if found_path="$(find_skill "$skill_name")"; then
    printf '%s=%s\n' "$output_key" "$found_path"
    printf 'DEPENDENCY_STATUS_%s=installed_now\n' "${output_key%_PATH}"
    return 0
  fi

  printf 'DEPENDENCY_RECHECK_FAILED=%s\n' "$skill_name" >&2
  return 1
}

failed=0

ensure_skill \
  khazix-writer \
  KHAZIX_WRITER_PATH \
  https://github.com/KKKKhazix/khazix-skills || failed=1

ensure_skill \
  gzh-design \
  GZH_DESIGN_PATH \
  https://github.com/isjiamu/gzh-design-skill || failed=1

ensure_skill \
  baoyu-cover-image \
  BAOYU_COVER_IMAGE_PATH \
  https://github.com/JimLiu/baoyu-skills/tree/main/skills/baoyu-cover-image || failed=1

if [[ "$failed" -eq 0 ]]; then
  printf 'WECHAT_ARTICLE_DEPENDENCIES_OK=1\n'
else
  printf 'WECHAT_ARTICLE_DEPENDENCIES_OK=0\n'
  exit 1
fi
