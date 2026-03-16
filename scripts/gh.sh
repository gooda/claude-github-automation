#!/usr/bin/env bash
# gh CLI 安全封装，仅允许特定子命令
# 用于 Claude Issue Triage，限制可执行的 gh 操作
set -euo pipefail

export GH_HOST=github.com

REPO="${GH_REPO:-${GITHUB_REPOSITORY:-}}"
if [[ -z "$REPO" || "$REPO" == */*/* || "$REPO" != */* ]]; then
  echo "Error: GITHUB_REPOSITORY 必须为 owner/repo 格式" >&2
  exit 1
fi
export GH_REPO="$REPO"

ALLOWED_FLAGS=(--comments --state --limit --label)
FLAGS_WITH_VALUES=(--state --limit --label)

SUB1="${1:-}"
SUB2="${2:-}"
CMD="$SUB1 $SUB2"
case "$CMD" in
  "issue view"|"issue list"|"search issues"|"label list")
    ;;
  *)
    echo "Error: 仅允许 issue view, issue list, search issues, label list" >&2
    exit 1
    ;;
esac

shift 2

POSITIONAL=()
FLAGS=()
skip_next=false
for arg in "$@"; do
  if [[ "$skip_next" == true ]]; then
    FLAGS+=("$arg")
    skip_next=false
  elif [[ "$arg" == -* ]]; then
    flag="${arg%%=*}"
    matched=false
    for allowed in "${ALLOWED_FLAGS[@]}"; do
      if [[ "$flag" == "$allowed" ]]; then
        matched=true
        break
      fi
    done
    if [[ "$matched" == false ]]; then
      echo "Error: 仅允许 --comments, --state, --limit, --label" >&2
      exit 1
    fi
    FLAGS+=("$arg")
    if [[ "$arg" != *=* ]]; then
      for vflag in "${FLAGS_WITH_VALUES[@]}"; do
        if [[ "$flag" == "$vflag" ]]; then
          skip_next=true
          break
        fi
      done
    fi
  else
    POSITIONAL+=("$arg")
  fi
done

if [[ "$CMD" == "search issues" ]]; then
  QUERY="${POSITIONAL[0]:-}"
  gh "$SUB1" "$SUB2" "$QUERY" --repo "$REPO" "${FLAGS[@]}"
elif [[ "$CMD" == "issue view" ]]; then
  if [[ ${#POSITIONAL[@]} -ne 1 ]] || ! [[ "${POSITIONAL[0]}" =~ ^[0-9]+$ ]]; then
    echo "Error: issue view 需要单个数字参数" >&2
    exit 1
  fi
  gh "$SUB1" "$SUB2" "${POSITIONAL[0]}" "${FLAGS[@]}"
else
  if [[ ${#POSITIONAL[@]} -ne 0 ]]; then
    echo "Error: issue list 和 label list 不接受位置参数" >&2
    exit 1
  fi
  gh "$SUB1" "$SUB2" "${FLAGS[@]}"
fi
