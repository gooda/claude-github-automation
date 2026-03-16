#!/usr/bin/env bash
# 将 Claude GitHub 自动化模板安装到目标项目
# 用法: ./install.sh [目标目录]
# 默认目标为当前目录的父级或当前目录
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-.}"

if [[ ! -d "$TARGET" ]]; then
  echo "目标目录不存在: $TARGET"
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"
echo "安装到: $TARGET"

# 复制 .github/workflows
mkdir -p "$TARGET/.github/workflows"
for f in "$SCRIPT_DIR/.github/workflows"/*.yml; do
  [ -f "$f" ] && cp "$f" "$TARGET/.github/workflows/" && echo "  + $(basename "$f")"
done

# 复制 .claude/commands
mkdir -p "$TARGET/.claude/commands"
cp "$SCRIPT_DIR/.claude/commands/label-issue.md" "$TARGET/.claude/commands/" 2>/dev/null && echo "  + label-issue.md"

# 复制 scripts
mkdir -p "$TARGET/scripts"
cp "$SCRIPT_DIR/scripts/gh.sh" "$TARGET/scripts/" && chmod +x "$TARGET/scripts/gh.sh" && echo "  + scripts/gh.sh"
cp "$SCRIPT_DIR/scripts/edit-issue-labels.sh" "$TARGET/scripts/" && chmod +x "$TARGET/scripts/edit-issue-labels.sh" && echo "  + scripts/edit-issue-labels.sh"

# CLAUDE.md：仅当目标不存在时复制模板
if [[ ! -f "$TARGET/CLAUDE.md" ]]; then
  cp "$SCRIPT_DIR/CLAUDE.md.template" "$TARGET/CLAUDE.md"
  echo "  + CLAUDE.md (从模板创建，请根据项目补充)"
else
  echo "  - CLAUDE.md 已存在，跳过"
fi

echo ""
echo "安装完成。请配置 ANTHROPIC_API_KEY 并安装 Claude GitHub App。"
