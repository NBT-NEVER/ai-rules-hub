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
    sync-local.ps1
    update-from-src.ps1
    pull-and-deploy.ps1
    github-push.ps1
    ps1-readme.md
    core/
      build/
        build.ps1
      install/
        install-codex.ps1
        install-cursor-project.ps1
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

以后凡是修改 skill、反思总结写回 skill、增添新 skill，都只改 `src/`，然后直接运行默认同步脚本：

```powershell
pwsh .\scripts\update-from-src.ps1
```

这个脚本会自动把 `src` 更新到：

- `C:\Users\18030\.codex`
- `I:\STUDY\python\project\backup-test-cursor\cursor-workplace`

如果你还想手动分步执行，可以用：

```powershell
pwsh .\scripts\core\build\build.ps1
pwsh .\scripts\core\install\install-codex.ps1
pwsh .\scripts\core\install\install-cursor-project.ps1 -ProjectPath "I:\STUDY\python\project\backup-test-cursor\cursor-workplace"
```

或使用原有一键命令：

```powershell
pwsh .\scripts\sync-local.ps1 -ProjectPath "I:\STUDY\python\project\backup-test-cursor\cursor-workplace"
```

## 推送到 GitHub

```powershell
pwsh .\scripts\github-push.ps1 -CommitMessage "update skill xxx"
```

## 第二台电脑拉取并部署

第二台电脑仓库路径：

- `I:\PYTHON\OWN_PROJECT\backup-test-cursor\ai-rules-hub`

第二台电脑默认 Cursor 项目路径：

- `I:\PYTHON\OWN_PROJECT\backup-test-cursor\workplace`

标准动作：

```powershell
pwsh .\scripts\pull-and-deploy.ps1
```

如果你要覆盖其它 Cursor 项目，可以显式传参：

```powershell
pwsh .\scripts\pull-and-deploy.ps1 -ProjectPath "<其它 Cursor 项目路径>"
```

如果那台电脑没有 Codex，可加：

```powershell
pwsh .\scripts\pull-and-deploy.ps1 -SkipCodex
```
