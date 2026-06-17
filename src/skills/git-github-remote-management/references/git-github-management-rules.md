# Git 与 GitHub 项目管理规则

本文件存放 Git 暂存、提交、推送、远端仓库、代理、超时、大文件和 Cursor 归因处理的长期规则。

## 一、核心目标

- 让 Git 暂存、提交、推送和 GitHub 同步流程可复现、可排查、可回滚。
- 在远端推送前优先排除代理、超时和大文件问题，提高一次推送成功率。
- 保持提交历史干净，不引入无关产物、错误的大文件或 Cursor attribution。

## 二、默认检查顺序

执行 Git 项目管理任务时，优先按下面顺序检查：

1. 仓库状态：`git status --short --branch`
2. 当前分支：`git branch --show-current`
3. 远端配置：`git remote -v`
4. 最近提交：`git log --oneline --decorate -n 5`
5. 代理状态：环境变量代理与 Git 代理是否一致
6. 大文件风险：是否有不该进入仓库的压缩包、数据集、模型、备份、产物目录
7. 归因风险：提交模板、hooks、Cursor attribution 设置是否会注入额外 trailer

不要一上来反复 `git push`。先定位问题类别，再重试。

## 三、暂存与提交规则

- 默认优先选择性暂存，不要在存在无关改动时机械执行全量 `git add .`。
- 如果仓库已有稳定发布脚本，先读脚本再决定是直接使用脚本，还是改为手动 Git 操作。
- 不要把密钥、令牌、缓存、虚拟环境、日志、数据库、模型权重、打包产物、临时导出文件随手加入版本库。
- 当任务只涉及少量文件时，优先明确暂存目标文件。
- 提交信息保持干净，只写实际变更，不写工具宣传语。

## 四、推送前代理检查

远端推送 GitHub 前，先检查当前电脑是否正在通过代理访问网络。至少核对：

- 环境变量：`HTTPS_PROXY`、`HTTP_PROXY`、`ALL_PROXY`
- Git 当前配置：`git config --global --get http.proxy`、`git config --global --get https.proxy`
- 远端协议：`git remote -v` 是 HTTPS 还是 SSH

处理原则：

- 如果当前机器明显依赖代理访问 GitHub，而 Git 没拿到对应代理，先补齐 Git 代理再推送。
- 如果环境变量已经提供有效代理，优先复用当前环境代理，不要凭空编造代理地址。
- 如果没有检测到代理，不要强行改 Git 代理；先保留现状。
- 如果用户处在公司网络、校园网、跨境网络或远程桌面环境，优先把代理检查当成首轮排查项。

## 五、大文件推送策略

先判断文件是否真的应该进 Git 历史：

- 代码、配置、轻量文档可以正常入库。
- 模型、数据集、导出包、压缩包、备份、视频、训练产物、安装包通常不适合直接进主仓库历史。

默认阈值：

- 大于 50 MB：视为高风险文件，推送前重新确认方案。
- 大于 100 MB：GitHub 常规 Git 推送会被拒绝，不要继续走普通推送。

可选方案按优先级考虑：

1. `Git LFS`：需要长期版本化管理的大型二进制文件。
2. GitHub Release 资产：只用于发布下载，不需要频繁参与源码版本对比的大文件。
3. 外部对象存储或网盘：与源码分离保存的大文件交付物。
4. 拆仓或改交付路径：避免把非源码资产塞进主仓库。

如果大文件已经进入本地但尚未共享到远端，优先在本地提交历史中清掉，再推送。

## 六、推送超时与慢速网络

推送失败时，不要只盯着报错字面。先区分：

- 认证失败
- 远端拒绝
- 代理错误
- 网络中断
- 低速超时
- 大文件导致的长时间上传

如果是慢速网络或长时间无响应，优先调整低速超时参数后再重试。常用做法：

```bash
git config --global http.lowSpeedLimit 0
git config --global http.lowSpeedTime 600
```

使用原则：

- 先调时间限制，再判断是否还需要改大文件方案。
- 不要把调超时当成大文件问题的唯一解法；超过 GitHub 限制时应切换到 LFS 或别的交付方式。
- 如果多次失败仍集中在上传阶段，优先回到“大文件策略”重新判断，而不是无休止重试。

## 七、Cursor attribution 与 trailer 规则

永远不要在提交、PR 或代码注释中加入下面这类内容：

- `Made-with: Cursor`
- `Co-authored-by: Cursor`
- 任何 Cursor attribution、footer、trailer 或宣传式署名

执行规则：

- 提交时不要使用 `git commit --trailer` 添加 Cursor 相关字段。
- 优先使用普通的 `git commit -m` 或 `git commit -F`。
- 如果项目脚本、Git hooks、提交模板或 IDE 自动注入了 Cursor attribution，先停下并移除注入点，再继续提交。

根据参考文章与相关讨论，排查顺序至少包括：

1. Cursor IDE 设置里的 `Agents > Attribution`，关闭 Commit Attribution 和 PR Attribution。
2. 修改后完整重启 Cursor，而不是只重启终端。
3. 检查 `~/.cursor/cli-config.json` 中 `attribution.attributeCommitsToAgent` 与 `attribution.attributePRsToAgent` 是否关闭。
4. 如果本地配置无效，检查是否存在团队或 Enterprise 管理策略覆盖本地设置。
5. 检查 Git 提交模板：`git config --get commit.template`
6. 检查 hooks 路径：`git config --get core.hooksPath`
7. 检查 `.git/hooks/prepare-commit-msg` 或包装脚本是否会追加 trailer

如果环境仍然强制注入 Cursor attribution：

- 优先在不会注入该 trailer 的环境中完成提交。
- 或在本地仓库设置临时 `prepare-commit-msg` 清理钩子，作为兜底措施。
- 已经生成但尚未共享的本地提交，可以用 amend、rebase 或 `git filter-repo` 清理。
- 不要在已经共享给他人的历史上擅自重写这类提交，除非用户明确要求并接受强推影响。

## 八、推送失败时的最小排查路径

1. `git status --short --branch`
2. `git remote -v`
3. 检查代理是否匹配当前网络
4. 检查是否存在大文件或产物误入库
5. 检查是否需要延长低速超时
6. 检查远端是否要求先拉取、rebase 或处理冲突
7. 检查是否被提交模板、hook 或 Cursor attribution 污染

只有在明确问题类型后，再决定是否重试、改推送方式、改历史或改网络设置。

## 九、历史改写边界

- 只要历史已经推到共享分支，默认不要主动重写。
- 只改本地未共享提交时，才优先考虑 amend、interactive rebase 或 `git filter-repo`。
- 涉及强推、重写公共历史、删除远端大文件历史时，必须先向用户说明影响。

## 十、与本仓库脚本的关系

- 如果当前仓库已经提供 `scripts/github-push.ps1`、`scripts/pull-and-deploy.ps1` 等入口，先检查脚本行为是否符合本规则。
- 如果脚本强制添加 Cursor attribution、忽略代理、忽略大文件风险或缺少超时处理，应先修脚本，再继续使用脚本发布。
- 脚本是执行入口，不是规则真源；长期规则以本文件为准。
