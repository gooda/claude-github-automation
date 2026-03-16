#!/usr/bin/env bash
# 为 GitHub Issue 添加/移除标签
# 用法: ./scripts/edit-issue-labels.sh --issue 123 --add-label bug --add-label P1
set -euo pipefail

ISSUE=""
ADD_LABELS=()
REMOVE_LABELS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --issue)
      ISSUE="$2"
      shift 2
      ;;
    --add-label)
      ADD_LABELS+=("$2")
      shift 2
      ;;
    --remove-label)
      REMOVE_LABELS+=("$2")
      shift 2
      ;;
    *)
      exit 1
      ;;
  esac
done

if [[ -z "$ISSUE" ]] || ! [[ "$ISSUE" =~ ^[0-9]+$ ]]; then
  exit 1
fi

if [[ ${#ADD_LABELS[@]} -eq 0 && ${#REMOVE_LABELS[@]} -eq 0 ]]; then
  exit 1
fi

VALID_LABELS=$(gh label list --limit 500 --json name --jq '.[].name')

FILTERED_ADD=()
for label in "${ADD_LABELS[@]}"; do
  if echo "$VALID_LABELS" | grep -qxF "$label"; then
    FILTERED_ADD+=("$label")
  fi
done

FILTERED_REMOVE=()
for label in "${REMOVE_LABELS[@]}"; do
  if echo "$VALID_LABELS" | grep -qxF "$label"; then
    FILTERED_REMOVE+=("$label")
  fi
done

if [[ ${#FILTERED_ADD[@]} -eq 0 && ${#FILTERED_REMOVE[@]} -eq 0 ]]; then
  exit 0
fi

GH_ARGS=("issue" "edit" "$ISSUE")
for label in "${FILTERED_ADD[@]}"; do
  GH_ARGS+=("--add-label" "$label")
done
for label in "${FILTERED_REMOVE[@]}"; do
  GH_ARGS+=("--remove-label" "$label")
done

gh "${GH_ARGS[@]}"
