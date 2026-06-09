# ai-rules-hub

自定义 skill 的单一规则源，用于同时服务：

- Codex：`%USERPROFILE%\.codex`
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
    update-from-src.ps1
    pull-and-deploy.ps1
    github-push.ps1
    promotes.md
    readme.md
    core/
      addresses.txt
      common.ps1
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
- `.codex` 下的已安装 skill、副本规则、`AGENTS.md` 等都视为安装结果，不是维护源；除读取 `.system/skill-creator` 这类系统参考外，不直接把 skill 变更写进 `.codex`
- 如果发现安装结果与 `src/` 不一致，应回到仓库根目录修改 `src/`，再通过构建与安装覆盖产物
- 正确流程始终是：`src -> build -> dist -> install`

## 当前受管自定义 skill

- `academic-anti-ai-writing`：降 AI 味、降模板化改写学术报告与工科说明
- `academic-paper-composer`：本科论文定稿重写与最终交付
- `academic-paper-strategist`：本科论文大纲与证据规划
- `chinese-encoding-guard`：中文读写与防乱码
- `code-project-rules`：Python 项目结构与工程规范
- `lab-report-writer`：实验报告与课程式技术说明
- `literature-downloader`：中文文献检索与合法全文获取
- `recall-thinking`：Word/docx 与踩坑经验复用
- `skill-maintainer`：skill 体系维护与同步部署（基础设施用，不直接触发）

## 日常维护流程

以后凡是修改 skill、反思总结写回 skill、增添新 skill，都只改 `src/`，然后运行默认同步脚本：

```powershell
pwsh .\scripts\update-from-src.ps1
```

脚本会先判断当前是否已在仓库标准目录结构内；若不是，则读取或询问 `scripts/core/addresses.txt` 中保存的仓库路径。随后按你的选择更新 Codex、Cursor，或两者同时更新。

脚本依赖 `scripts/core/addresses.txt` 保存以下地址，首次执行时会提示确认，之后复用已保存的路径：

- `github_repo_url`：GitHub 仓库地址
- `local_codex_root`：Codex 根目录，例如 `%USERPROFILE%\.codex`
- `cursor_project_path`：Cursor 项目根目录，例如 `D:\Projects\your-cursor-workspace`
- `local_repo_path`：本地 `ai-rules-hub` 仓库根目录，例如 `D:\Projects\ai-rules-hub`

同步完成后，脚本会输出本次使用的 Codex 路径、Cursor 路径，以及当前受管 skill 的简略功能说明，方便快速确认同步目标和内容。这里显示的是压缩后的摘要，不会原样展开 `SKILL.md` 里的完整长描述。

如果你还想手动分步执行，可以用：

```powershell
pwsh .\scripts\core\build\build.ps1
pwsh .\scripts\core\install\install-codex.ps1
pwsh .\scripts\core\install\install-cursor-project.ps1 -ProjectPath "D:\Projects\your-cursor-workspace"
```

## 推送到 GitHub

```powershell
pwsh .\scripts\github-push.ps1
```

这个脚本会读取当前仓库地址或已保存的 `local_repo_path`，自动设置远端地址、暂存变更、要求输入提交说明，并将当前分支推送到 `origin`。执行前会先复用代理检测与地址确认逻辑。

## 在其它机器拉取并部署

标准动作：

```powershell
pwsh .\scripts\pull-and-deploy.ps1
```

这个脚本会先判断当前是否已经位于目标仓库；如果本地还没有仓库，会根据已保存或刚输入的 `local_repo_path` 自动克隆。随后自动套用已保存的 Codex 路径和默认 Cursor 项目路径，并在拉取完成后继续调用 `update-from-src.ps1` 完成构建与部署。

如果检测到本地仓库有未提交修改，脚本会提示你选择覆盖本地修改或停止执行；部署完成后会展示仓库地址、GitHub 地址，以及当前受管 skill 的简略功能说明。

如果你要部署到其它 Cursor 项目，可在脚本执行过程中输入新的项目路径，覆盖当前保存值。

## 入口脚本分工

- `scripts/update-from-src.ps1`：从当前源码重新构建，并更新 Codex、Cursor 或两者
- `scripts/pull-and-deploy.ps1`：拉取远端仓库后继续本机构建与部署
- `scripts/github-push.ps1`：暂存、提交并推送当前仓库到 GitHub
- `scripts/core/common.ps1`：保存共享的地址管理、路径确认、Git 调用与 skill 摘要展示逻辑
- `scripts/core/addresses.txt`：保存当前机器默认使用的仓库、Codex、Cursor 地址

## 维护建议

- 根目录入口脚本只负责交互、地址管理、代理处理和调用链组织
- `scripts/core/` 负责底层构建与安装，不承载 skill 业务规则文本
- 若仓库地址、Codex 地址或 Cursor 项目地址变化，优先更新 `scripts/core/addresses.txt`，或在脚本运行时重新输入
- 若要新增入口脚本，优先复用 `scripts/core/common.ps1` 中的共享函数，避免重复维护交互与地址逻辑
- `README.md` 以总览为主，`scripts/readme.md` 以脚本细节为主；修改脚本行为时，两个文档应同步检查
