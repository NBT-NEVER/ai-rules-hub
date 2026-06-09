# scripts / readme

本目录仅保留日常直接使用的 PowerShell 入口脚本，`core/` 继续作为底层构建与安装实现层，不在这里直接改动。

## 一、目录结构

```text
scripts/
  pull-and-deploy.ps1
  github-push.ps1
  update-from-src.ps1
  promotes.md
  readme.md
  core/
    addresses.txt
    common.ps1
    build/
      build.ps1
    env/
      resolve-machine-context.ps1
    install/
      install-codex.ps1
      install-cursor-project.ps1
```

## 二、地址记录机制

`core/addresses.txt` 统一记录以下地址：

- `github_repo_url`：GitHub 仓库地址。
- `local_codex_root`：本机 Codex 根目录，填写到 `.codex` 这一层目录。
- `cursor_project_path`：本机 Cursor 项目地址，填写到要写入规则的那个项目根目录。
- `local_repo_path`：本机 `ai-rules-hub` 仓库地址，填写到仓库根目录，也就是 `ai-rules-hub` 这一层。

推荐示例（以下路径仅作格式演示，不包含你的真实隐私地址）：

```text
github_repo_url=https://github.com/NBT-NEVER/ai-rules-hub.git
local_codex_root=C:\Users\YourName\.codex
cursor_project_path=D:\Projects\your-cursor-workspace
local_repo_path=D:\Projects\ai-rules-hub
```

填写说明：

- `local_codex_root` 不要填到 `skills` 子目录，应填 `.codex` 根目录，因为脚本会自动写入 `.codex\skills`。
- `cursor_project_path` 不要填到 `.cursor\rules` 子目录，应填 Cursor 项目根目录，因为脚本会自动写入 `<项目根目录>\.cursor\rules`。
- `local_repo_path` 不要填到 `scripts` 子目录，应填仓库根目录，因为脚本内部会再通过相对路径调用 `scripts\core`。

所有入口脚本都会先读取这里的地址：

- 如果已有默认地址，会询问是否继续使用。
- 如果输入 `n`，则要求重新输入并覆盖保存。
- 以后同一台机器再次执行时，会直接复用上次保存的地址。

## 三、入口脚本说明

### 1. `pull-and-deploy.ps1`

作用：从 GitHub 拉取当前仓库后，继续部署到本机 Codex 和 Cursor。

执行逻辑：

- 如果脚本本身已经位于 `ai-rules-hub/scripts` 下，就直接把当前仓库视为目标仓库。
- 如果不是该结构，则读取或询问 `local_repo_path`，在目标位置克隆仓库。
- 拉取前自动检测系统代理环境变量与 WinHTTP 代理，并同步到 Git 全局代理配置。
- 如果检测到本地仓库存在未提交修改，会提示用户选择“覆盖”或“停止”。
- 拉取完成后自动调用 `update-from-src.ps1` 完成本机部署。
- 执行成功后显示仓库地址、GitHub 地址以及所有 skill 的功能说明。

### 2. `github-push.ps1`

作用：将当前仓库暂存、提交并推送到 GitHub。

执行逻辑：

- 自动读取当前仓库地址或询问 `local_repo_path`。
- 推送前自动检测代理并设置 Git 代理。
- 先调用 `update-from-src.ps1`，确保本地部署与当前源代码一致。
- 弹出输入框让用户填写本次提交说明。
- 自动执行 `git add .`、`git commit -m`、`git push -u origin 当前分支`。
- 远端地址固定为 `https://github.com/NBT-NEVER/ai-rules-hub.git`。

### 3. `update-from-src.ps1`

作用：从当前源码重新构建，并按选择更新 Codex、Cursor 或两者。

执行逻辑：

- 提示用户选择：
  - `1` 更新 Codex skill
  - `2` 更新 Cursor skill
  - `3` 同时更新 Codex 和 Cursor skill
- 若要更新 Codex，会读取或询问 `local_codex_root`。
- 若要更新 Cursor，会读取或询问 `cursor_project_path`。
- 内部只调用 `core/build/build.ps1`、`core/install/install-codex.ps1`、`core/install/install-cursor-project.ps1`。
- 完成后展示 Codex 地址、Cursor 地址以及所有 skill 的适用场景与功能。

## 四、窗口关闭行为

三个入口脚本都遵循同一规则：

- 成功时不自动关闭窗口，而是输出：`已完成，任意键关闭窗口`
- 失败时直接抛出报错信息，不自动关闭，方便查看原因。

## 五、推荐使用方式

### 1. 另一台电脑拉取并部署

```powershell
pwsh .\scripts\pull-and-deploy.ps1
```

### 2. 本机从源码重新部署

```powershell
pwsh .\scripts\update-from-src.ps1
```

### 3. 提交并推送到 GitHub

```powershell
pwsh .\scripts\github-push.ps1
```

## 六、维护原则

- 根目录入口脚本只负责交互、地址管理、代理处理和调用链组织。
- `core/` 只负责底层构建与安装，不在本次入口改造中调整其行为。
- 以后若仓库地址、Codex 地址或 Cursor 地址变化，优先更新 `core/addresses.txt` 或在脚本运行时重新输入。
- 若要新增入口脚本，优先复用 `core/common.ps1` 中的共享函数，避免重复维护交互与地址逻辑。
