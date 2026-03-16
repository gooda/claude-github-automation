# Claude GitHub 自动化配置指南

## 前置条件

1. **Claude API Key**：从 [console.anthropic.com](https://console.anthropic.com/) 获取
2. **GitHub 仓库管理员权限**：用于安装 App 和配置 Secrets

## 快速配置（推荐）

在 Claude Code 终端运行：

```bash
/install-github-app
```

按提示完成 Claude GitHub App 安装和 `ANTHROPIC_API_KEY` 配置。

## 手动配置

### 1. 安装 Claude GitHub App

访问 [github.com/apps/claude](https://github.com/apps/claude)，安装到目标仓库。

所需权限：Pull requests、Issues、Contents 的读写权限。

### 2. 添加 Secrets

仓库 Settings → Secrets and variables → Actions → New repository secret：

| Secret 名称 | 说明 |
|-------------|------|
| `ANTHROPIC_API_KEY` | Claude API Key |

### 3. 自定义 API 地址（可选）

若需使用代理、网关或自建服务，在 workflow 的 step 中添加 `env`：

```yaml
env:
  ANTHROPIC_BASE_URL: "https://your-proxy.example.com/v1"
```

或使用仓库变量：`ANTHROPIC_BASE_URL: ${{ vars.ANTHROPIC_BASE_URL }}`

### 4. 预置 Issue 标签（可选）

Issue 自动打标签依赖仓库已有标签。建议在仓库 Labels 中创建：

- **类型**：bug, feature, question, documentation
- **领域**：frontend, backend, test, infra
- **优先级**：P0, P1, P2, P3

## 工作流说明

| 工作流 | 触发条件 | 功能 |
|--------|----------|------|
| `claude-pr-review.yml` | PR 创建/更新 | 自动代码审查 |
| `claude-issue-triage.yml` | 新 Issue 创建 | 自动分类打标签 |
| `claude-mention.yml` | 评论中 @claude | 手动触发 Claude 响应 |

## 验证

1. **PR Review**：创建或更新一个 PR，查看 Actions 是否运行
2. **Issue Triage**：新建一个 Issue，检查是否自动添加标签
3. **@claude**：在 Issue 或 PR 评论中写 `@claude 请分析这个问题`

## 成本说明

- **GitHub Actions**：消耗仓库的 Actions 分钟数
- **Claude API**：按 token 计费，见 [claude.com/pricing](https://claude.com/pricing)

建议设置 `--max-turns` 控制单次任务迭代次数以控制成本。
