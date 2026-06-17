---
name: git-github-remote-management
description: 管理 Git 暂存、提交、分支、远程仓库、GitHub 推送、拉取和失败排查。用于用户要求 `git add`、`git commit`、`git push`、设置或修改 `origin`、同步 GitHub、检查代理、处理超时、处理大文件或 Git LFS、清理或禁用 Cursor 提交归因、重写本地未共享历史，或任何项目级版本管理与远端仓库运维任务。
---

# GIT 管理与 GITHUB 远程仓库管理

在命中本 skill 时，先读取 `references/git-github-management-rules.md`，再执行暂存、提交、推送、远端修改、历史清理或失败排查。

## 工作流

1. 把 `references/git-github-management-rules.md` 作为 Git/GitHub 项目管理任务的默认规则集。
2. 在 `git add`、`git commit`、`git push` 之前，先检查仓库状态、当前分支、远端地址、代理状态，以及是否存在不该入库的大文件或生成产物。
3. 优先使用最小必要变更：该选择性暂存时不要盲目全量暂存，该避免重写共享历史时不要强推。
4. 推送失败时，先判断是代理、认证、超时、大文件、远端冲突，还是 Cursor 归因注入，再选择对应处理路径。
5. 任何提交、PR 或代码注释都保持干净，不要加入 Cursor attribution 或 trailer。

## 作用范围

本 skill 负责项目级 Git/GitHub 管理，包括本地版本管理、远程仓库同步、网络与代理排查、大文件推送策略、提交规范、历史清理和与 Cursor 归因相关的问题处理。

如果当前任务主要是维护 skill 体系本身，仍然优先使用 `skill-maintainer`；一旦进入 `git add`、`git commit`、`git push`、修改远端、处理代理或推送失败阶段，再同时参考本 skill。

## 更新规则

当用户要调整 Git/GitHub 项目管理规则、代理与超时策略、大文件推送策略、Cursor attribution 清理规范，或项目内 Git 发布脚本的长期行为时，更新 `references/git-github-management-rules.md`。
