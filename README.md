# Claude Code + GitHub 自动化模板

通用化 Claude Code 与 GitHub 集成模板，可复用到任意项目。

## 功能

| 工作流 | 触发 | 功能 |
|--------|------|------|
| PR Review | PR 创建/更新 | 自动代码审查 |
| Issue Triage | 新 Issue 创建 | 自动分类打标签 |
| @claude | 评论中 @claude | 手动触发 Claude 响应 |

## 安装方式

### 方式一：使用安装脚本（推荐）

```bash
# 下载或解压本模板后，在模板目录执行
./install.sh /path/to/your-project
```

### 方式二：手动复制

将以下目录/文件复制到目标项目根目录：

```
.github/workflows/     → 目标项目 .github/workflows/
.claude/commands/      → 目标项目 .claude/commands/
scripts/gh.sh          → 目标项目 scripts/
scripts/edit-issue-labels.sh → 目标项目 scripts/
CLAUDE.md.template     → 重命名为 CLAUDE.md 并自定义
```

### 方式三：从 GitHub Release 下载（推荐）

```bash
# 下载最新 release 并安装
curl -sSL https://github.com/gooda/claude-github-automation/releases/latest/download/claude-github-automation.tar.gz -o claude-github-automation.tar.gz
tar -xzf claude-github-automation.tar.gz && cd claude-github-automation-* && ./install.sh /path/to/your-project
```

### 方式四：从打包文件安装

```bash
# 解压后运行安装脚本（推荐，不会覆盖已有 CLAUDE.md）
tar -xzf claude-github-automation-*.tar.gz
cd claude-github-automation-*
./install.sh /path/to/your-project

# 或直接解压到目标项目根目录（会合并 .github、.claude、scripts）
tar -xzf claude-github-automation-*.tar.gz -C /path/to/your-project --strip-components=1
# 若有 CLAUDE.md.template，请重命名为 CLAUDE.md 并自定义
```

## 配置

1. **安装 Claude GitHub App**：[github.com/apps/claude](https://github.com/apps/claude)
2. **添加 Secret**：`ANTHROPIC_API_KEY`（仓库 Settings → Secrets）
3. **可选**：在仓库 Labels 中创建 bug、feature、P1、P2 等标签

## 自定义

- **CLAUDE.md**：根据 `CLAUDE.md.template` 创建，补充项目规范
- **PR 审查 prompt**：编辑 `.github/workflows/claude-pr-review.yml` 中的 `prompt` 字段
- **Issue 标签**：在仓库 Labels 中创建，Claude 会从已有标签中选择
- **自定义 API 地址**：通过 `ANTHROPIC_BASE_URL` 环境变量指定代理或网关，见下方

### 自定义 API 调用 URL

若需使用代理、网关或自建服务，在 workflow 的 step 中添加 `env`：

```yaml
- name: Claude PR Review
  uses: anthropics/claude-code-action@v1
  env:
    ANTHROPIC_BASE_URL: "https://your-proxy.example.com/v1"  # 或 ${{ vars.ANTHROPIC_BASE_URL }}
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    # ...
```

适用场景：代理、OpenRouter、国内网关等。代理需兼容 Anthropic API 格式。

## 依赖

- GitHub Actions（ubuntu-latest）
- gh CLI（Runner 内置）
- Claude API（需 ANTHROPIC_API_KEY）
