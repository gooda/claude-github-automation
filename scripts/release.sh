#!/usr/bin/env bash
# 打包并创建 GitHub Release
# 用法: ./scripts/release.sh [版本号]
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="${1:-1.0}"
TAG="v$VERSION"

cd "$REPO_DIR"

# 打包
"$REPO_DIR/scripts/pack.sh" "$VERSION"

TARBALL="$REPO_DIR/dist/claude-github-automation-$VERSION.tar.gz"
cp "$TARBALL" "$REPO_DIR/claude-github-automation.tar.gz"

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
echo "Release $TAG: https://github.com/gooda/claude-github-automation/releases/tag/$TAG"
