# ai-rules-hub

这个仓库是你自定义 skill 的单一规则源，用于同时服务：

- Codex：`C:/Users/18030/.codex`
- Cursor：项目级 `AGENTS.md` 与 `.cursor/rules/*.mdc`

## 目录结构

```text
ai-rules-hub/
  src/
    AGENTS.md
    skills/
      ...
  dist/
    codex/
    cursor/
  scripts/
    build.ps1
    install-codex.ps1
    install-cursor-project.ps1
    sync-local.ps1
    pull-and-deploy.ps1
```

## 单一真源原则

- 只修改 `src/`
- 不手改 `dist/`
- 不手改 Codex 或 Cursor 项目中的安装产物
- 正确流程始终是：`src -> build -> dist -> install`

## 当前受管自定义 skill

- `academic-anti-ai-writing`
- `academic-paper-composer`
- `academic-paper-strategist`
- `chinese-encoding-guard`
- `code-project-rules`
- `lab-report-writer`
- `recall-thinking`
- `skill-maintainer`

## 本机修改并本地生效

```powershell
pwsh .\scripts\build.ps1
pwsh .\scripts\install-codex.ps1
pwsh .\scripts\install-cursor-project.ps1 -ProjectPath "I:\STUDY\python\project\backup-test-cursor\cursor-workplace"
```

或使用一键命令：

```powershell
pwsh .\scripts\sync-local.ps1 -ProjectPath "I:\STUDY\python\project\backup-test-cursor\cursor-workplace"
```

## 推送到 GitHub

```powershell
git add .
git commit -m "update skill xxx"
git push
```

## 第二台电脑拉取并部署

第二台电脑仓库路径：

- `I:\PYTHON\OWN_PROJECT\ai-rules-hub`

标准动作：

```powershell
pwsh .\scripts\pull-and-deploy.ps1 -ProjectPath "<你的 Cursor 项目路径>"
```

如果那台电脑没有 Codex，可加：

```powershell
pwsh .\scripts\pull-and-deploy.ps1 -ProjectPath "<你的 Cursor 项目路径>" -SkipCodex
```
