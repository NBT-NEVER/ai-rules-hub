# scripts / ps1-readme

本目录按“入口层 + 底层实现层”组织。

## 一、目录结构

```text
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

## 二、入口层脚本

这些脚本保留在 `scripts/` 根目录，目的是让你日常只面对少量高频入口。

### 1. `sync-local.ps1`

- 作用：本机一键执行构建、Codex 安装和默认 Cursor 项目安装。
- 适用：你已经改完 `src/`，想让本机立即生效。
- 判断：先根据当前仓库根目录判断是本机还是远程电脑，再自动选择对应的默认 Cursor 项目路径与 `%USERPROFILE%\.codex`。

### 2. `update-from-src.ps1`

- 作用：默认同步入口。
- 适用：修改 skill、反思总结写回 skill、增添新 skill 后，从 `src` 自动更新到本机 Codex 和默认 Cursor 项目。
- 说明：它当前内部直接调用 `sync-local.ps1`。
- 判断：先根据当前仓库根目录判断机器身份，再把正确地址传给 `sync-local.ps1`。

### 3. `pull-and-deploy.ps1`

- 作用：跨机器同步入口。
- 适用：另一台电脑执行 `git pull` 后，继续构建并部署到本机 Codex 与默认 Cursor 项目。
- 判断：先根据当前仓库根目录判断机器身份，再自动使用该机器对应的默认 Cursor 项目路径与 `%USERPROFILE%\.codex`。

### 4. `github-push.ps1`

- 作用：GitHub 发布入口。
- 适用：你要把当前仓库发布到 GitHub。
- 顺序：先 `update-from-src.ps1`，再 `git add`、`git commit`、`git push`。
- 判断：先根据当前仓库根目录判断机器身份，再把对应地址交给 `update-from-src.ps1`。

## 三、底层实现层

这些脚本放到 `scripts/core/` 下，避免和入口层混在一起。

### 1. `core/build/build.ps1`

- 作用：把 `src/` 生成为 `dist/`。
- 不负责安装。

### 2. `core/install/install-codex.ps1`

- 作用：把 `dist/codex` 安装到 `C:/Users/18030/.codex`。
- 不负责构建。

### 3. `core/install/install-cursor-project.ps1`

- 作用：把 `dist/cursor/project-template` 安装到指定 Cursor 项目。
- 不负责构建。

## 四、推荐使用方式

### 1. 本机日常维护

```powershell
pwsh .\scripts\update-from-src.ps1
```

### 2. 发布到 GitHub

```powershell
pwsh .\scripts\github-push.ps1 -CommitMessage "update skill xxx"
```

### 3. 另一台机器拉取并部署

```powershell
pwsh .\scripts\pull-and-deploy.ps1
```

## 五、维护原则

- 入口脚本尽量保持少而稳定。
- 底层脚本按职责放进分类目录，不堆在根目录。
- 修改构建或安装细节时，优先改 `scripts/core/`。
- 修改日常使用方式或入口链路时，优先改根目录入口脚本。
- 如果以后新增电脑或仓库位置变化，优先修改 `scripts/core/env/resolve-machine-context.ps1` 这一处。
