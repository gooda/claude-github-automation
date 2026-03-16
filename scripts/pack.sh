#!/usr/bin/env bash
# 打包 Claude GitHub 自动化模板
# 输出: dist/claude-github-automation-<version>.tar.gz
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$REPO_DIR/dist"
VERSION="${1:-1.0}"
PACK_NAME="claude-github-automation-$VERSION"
TARBALL="$DIST_DIR/$PACK_NAME.tar.gz"

mkdir -p "$DIST_DIR"
TMP=$(mktemp -d)
trap "rm -rf $TMP" EXIT

mkdir -p "$TMP/$PACK_NAME"
cp -r "$REPO_DIR"/.github "$TMP/$PACK_NAME/"
cp -r "$REPO_DIR"/.claude "$TMP/$PACK_NAME/"
mkdir -p "$TMP/$PACK_NAME/scripts"
cp "$REPO_DIR/scripts/gh.sh" "$TMP/$PACK_NAME/scripts/"
cp "$REPO_DIR/scripts/edit-issue-labels.sh" "$TMP/$PACK_NAME/scripts/"
cp "$REPO_DIR/CLAUDE.md.template" "$TMP/$PACK_NAME/"
cp "$REPO_DIR/README.md" "$TMP/$PACK_NAME/"
cp "$REPO_DIR/install.sh" "$TMP/$PACK_NAME/"
mkdir -p "$TMP/$PACK_NAME/docs"
cp "$REPO_DIR/docs/SETUP.md" "$TMP/$PACK_NAME/docs/" 2>/dev/null || true
chmod +x "$TMP/$PACK_NAME/scripts/"*.sh "$TMP/$PACK_NAME/install.sh"

(cd "$TMP" && tar -czf "$TARBALL" "$PACK_NAME")

echo "已生成: $TARBALL"
