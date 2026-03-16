#!/usr/bin/env bash
# 创建 GitHub Release 并上传 tarball
# 需在 APPAUTO 项目根目录执行，或确保 dist/claude-github-automation-1.0.tar.gz 存在
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
APPAUTO_DIST="${APPAUTO_DIST:-$REPO_DIR/../dist}"
VERSION="${1:-1.0}"
TAG="v$VERSION"

# 查找 tarball
if [[ -f "$APPAUTO_DIST/claude-github-automation-$VERSION.tar.gz" ]]; then
  TARBALL="$APPAUTO_DIST/claude-github-automation-$VERSION.tar.gz"
elif [[ -f "$REPO_DIR/../APPAUTO/dist/claude-github-automation-$VERSION.tar.gz" ]]; then
  TARBALL="$REPO_DIR/../APPAUTO/dist/claude-github-automation-$VERSION.tar.gz"
else
  echo "请先在 APPAUTO 项目执行: npm run pack:claude-github"
  echo "或指定版本: bash scripts/pack-claude-github-automation.sh $VERSION"
  exit 1
fi

# 复制为通用名（release 固定使用此名便于 latest 下载）
cp "$TARBALL" "$REPO_DIR/claude-github-automation.tar.gz"

cd "$REPO_DIR"

echo "创建 Release $TAG ..."
gh release create "$TAG" claude-github-automation.tar.gz \
  --title "$TAG" \
  --notes "## Claude Code + GitHub 自动化模板 $TAG

### 功能
- **PR 自动 Review**：PR 创建/更新时自动代码审查
- **Issue 自动打标签**：新 Issue 创建时自动分类
- **@claude 手动触发**：评论中 @claude 可触发 Claude 响应

### 安装
\`\`\`bash
curl -sSL https://github.com/gooda/claude-github-automation/releases/latest/download/claude-github-automation.tar.gz -o claude-github-automation.tar.gz
tar -xzf claude-github-automation.tar.gz && cd claude-github-automation-* && ./install.sh /path/to/your-project
\`\`\`"

rm -f claude-github-automation.tar.gz
echo "Release $TAG 已创建: https://github.com/gooda/claude-github-automation/releases/tag/$TAG"
