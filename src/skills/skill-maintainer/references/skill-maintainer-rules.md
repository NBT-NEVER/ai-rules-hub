# Skill Maintainer Rules

本文件是 `I:/STUDY/python/project/backup-test-cursor/ai-rules-hub` 这套共享 skill 规则仓库的权威维护规则。以后凡是新增、修改、重命名、安装、同步、部署、迁移自定义 skill，或把新经验写回 `recall-thinking`，都以本文件为准。

## 一、当前架构与单一真源

### 1. 仓库根目录

- `I:/STUDY/python/project/backup-test-cursor/ai-rules-hub`

### 2. 单一真源目录

- 全局入口源文件：`I:/STUDY/python/project/backup-test-cursor/ai-rules-hub/src/AGENTS.md`
- 自定义 skill 源目录：`I:/STUDY/python/project/backup-test-cursor/ai-rules-hub/src/skills`

### 3. 生成产物目录

- Codex 产物：`I:/STUDY/python/project/backup-test-cursor/ai-rules-hub/dist/codex`
- Cursor 产物：`I:/STUDY/python/project/backup-test-cursor/ai-rules-hub/dist/cursor`

### 4. 安装目标

- Codex 安装目标：默认按当前机器的 `%USERPROFILE%/.codex` 自动判断，不再写死某个用户名目录
- 默认 Cursor 项目级安装目标：按当前机器自动判断
  - 本机：`I:/STUDY/python/project/backup-test-cursor/cursor-workplace`
  - 远程电脑：`I:/PYTHON/OWN_PROJECT/backup-test-cursor/workplace`
- Cursor 项目级安装产物：`<ProjectPath>/AGENTS.md` 与 `<ProjectPath>/.cursor/rules`

### 5. 创建与元信息参考

- 新增或大改 skill 时，先读：`C:/Users/18030/.codex/skills/.system/skill-creator/SKILL.md`
- 修改 `agents/openai.yaml` 时，再读：`C:/Users/18030/.codex/skills/.system/skill-creator/references/openai_yaml.md`
- `.system/skill-creator` 是创建方法参考，不属于这套自定义 skill 源仓库，不要把它复制进 `src/skills`

### 6. 规则边界

- 只纳入自定义 skill，不纳入 `.system`。
- 以后只改 `src/`，不要手改 `dist/`，也不要手改已安装到 Codex 或 Cursor 项目里的产物。
- 正确路径始终是：`src -> build -> dist -> install`。
- 以后凡是反思、总结、写回经验、修改 skill、重命名 skill、增添新 skill，都必须只改 `src/`，改完后自动执行默认同步脚本，把 `src` 更新到 Codex 和默认 Cursor 项目。
- 入口脚本必须先判断当前是哪一台电脑，再自动选择该机器对应的仓库默认路径、Cursor 项目路径和 Codex 路径。

## 二、当前自定义 skill 清单与职责介绍

以后只要修改任意 skill，输出中都必须先列出当前受管 skill 清单，并对本次相关 skill 给出详细介绍，再说明修改动作。

当前受管自定义 skill：

- `academic-anti-ai-writing`
  负责学术报告、论文、实验报告、正式工科说明等中文正式文本的降模板化、降 AI 味、增强证据边界与工程细节表达。
- `academic-paper-composer`
  负责基于真实项目和既有草稿完成本科软件/计算机类论文正文重写、定稿整理、截图替换和最终交付。
- `academic-paper-strategist`
  负责基于真实项目证据规划本科软件/计算机类论文的大纲、证据映射、章节重写范围和配图方案。
- `chinese-encoding-guard`
  负责中文读写、防乱码、UTF-8 约束、中文中间文件链路与临时目录管理。
- `code-project-rules`
  负责 Python 项目结构、路径管理、中文注释、README、requirements 和工程交付规范。
- `lab-report-writer`
  负责实验报告、算法说明、论文解读中的公式说明、README 式项目介绍、方法说明、实现逻辑概述、结果分析以及 MathType 可复用 LaTeX 配套输出等中文说明性技术写作。
- `literature-downloader`
  负责中文文献检索、论文筛选、合法全文获取、批量采集、DOI/PMID 查询、影响因子/分区核验、下载日志整理，以及 Zotero/BibTeX 相关整理；明确禁止绕过付费墙或盗版下载。
- `recall-thinking`
  负责复用长期经验、踩坑记录、核验方法和稳定操作链路。
- `skill-maintainer`
  负责维护整套 skill 体系本身，包括命名、分层、GitHub 仓库、构建脚本、安装脚本、同步部署流程、新 skill 的正确源目录落点，以及把新经验回写到 `recall-thinking`；在新增或大改 skill 时要联动参考系统 `skill-creator`。

## 三、各层职责

### 1. `src/AGENTS.md`

作用：

- 存放长期全局约束
- 存放常见场景到 skill 的入口路由
- 指明哪些场景优先命中哪些 skill

不要写入：

- 单个 skill 的大段细则
- 构建脚本实现细节
- 某类规则的完整 references 内容
- 公式排版模板、变量解释样式、MathType 对应 LaTeX 行序这类具体输出格式

### 2. `src/skills/<skill>/SKILL.md`

作用：

- 定义 skill 名称
- 定义触发描述
- 定义命中后的读取入口

要求：

- 重点描述“什么时候该用这个 skill”
- 不要把所有长期细则堆进这里
- 触发描述需要覆盖相邻高频场景，避免写得过窄

### 3. `src/skills/<skill>/references/*-rules.md`

作用：

- 存放该 skill 的长期细则
- 作为真正的维护主文件

要求：

- 职责单一
- 便于长期人工维护
- 不混入无关 skill 的规则
- 像论文公式解读、变量说明顺序、LaTeX 代码区分离这类长期输出模板，应优先放在对应 skill 的 `references/*-rules.md`

### 4. `src/skills/<skill>/agents/openai.yaml`

作用：

- 保留 Codex 侧 UI 元信息
- 作为源仓库中该 skill 的元数据组成部分

### 5. `scripts/*.ps1`

作用：

- 根目录入口脚本负责完成本机同步、跨机器部署和 GitHub 发布
- `scripts/core` 下的底层脚本负责构建与安装
- 不承载 skill 业务规则文本

## 四、修改时的基本判断规则

预读要求：

- 只要任务是新增、重构或明显修改某个 skill，先读取：
  - `src/skills/skill-maintainer/SKILL.md`
  - `C:/Users/18030/.codex/skills/.system/skill-creator/SKILL.md`
- 只要任务会修改 `agents/openai.yaml`，再读取：
  - `C:/Users/18030/.codex/skills/.system/skill-creator/references/openai_yaml.md`

1. 如果是长期全局约束或总入口路由，改 `src/AGENTS.md`。
2. 如果是某个 skill 的触发范围、适用场景、入口说明，改该 skill 的 `SKILL.md`。
3. 如果是某个 skill 的长期细则，改该 skill 的 `references/*-rules.md`。
4. 如果是 Codex 展示名称或界面元信息，改该 skill 的 `agents/openai.yaml`。
5. 如果是构建、安装、同步、部署流程，改 `scripts/*.ps1`，必要时同步更新本文件。
6. 如果是自定义 skill 名称、目录结构或职责变化，同时更新：
   - `src/AGENTS.md`
   - 对应 skill 的 `SKILL.md`
   - 必要时相关 skill 的 `references/*-rules.md`
   - 本文件
7. 如果是从外部仓库安装 skill 进入这套受管体系，同时检查：
   - 目录名是否与 skill 的规范名称一致
   - 是否需要保留或清理无关的仓库辅助文件
   - `src/AGENTS.md` 是否需要补充入口路由
   - 当前受管 skill 清单是否需要补充该 skill
8. 如果是本轮经验、踩坑、错误路径、验证方法的长期沉淀，由本 skill 负责流程控制，并把内容写到：
   - `src/skills/recall-thinking/references/recall-rules.md`

## 五、修改 skill 时的输出要求

只要任务涉及 skill 的新增、删除、重命名、安装、修改、同步、下载或部署，输出中必须包含以下内容：

1. 当前受管 skill 清单。
2. 与本次任务直接相关的 skill 详细介绍。
3. 修改了哪些文件。
4. 为什么应该修改这些文件而不是其它层。
5. 新增、删除或改写了哪些规则。
6. 如果涉及重命名、结构调整或职责调整，如何同步更新了 `src/AGENTS.md` 和本文件。
7. 如果涉及部署，说明 build、install、Cursor 项目安装分别做了什么。

## 六、标准工作流

### 0. 新增 skill 的正确落点、流程与同步链路

1. 先读取 `src/skills/skill-maintainer/SKILL.md` 与 `C:/Users/18030/.codex/skills/.system/skill-creator/SKILL.md`。
2. 如果会新建或修改 `agents/openai.yaml`，再读取 `C:/Users/18030/.codex/skills/.system/skill-creator/references/openai_yaml.md`。
3. 新 skill 的唯一正确源目录落点是：`I:/STUDY/python/project/backup-test-cursor/ai-rules-hub/src/skills/<skill-name>`。
4. 不要把新 skill 直接创建到 `dist/`、`C:/Users/18030/.codex/skills`、`<ProjectPath>/.cursor/rules` 或任何已安装产物目录。
5. 目录结构至少包含 `SKILL.md`；如有需要，再补 `agents/openai.yaml`、`references/`、`scripts/`、`assets/`。
6. 如果 skill 来自外部仓库，先检查目录名是否应与 `SKILL.md` frontmatter 中的 `name` 对齐；默认应优先对齐，除非用户明确要求保留外部仓库名。
7. 如果新增 skill 改变了常见入口路由、职责边界或维护说明，同时更新：
   - `src/AGENTS.md`
   - `src/skills/skill-maintainer/references/skill-maintainer-rules.md`
8. 完成 `src/` 修改后，立即运行 `scripts/update-from-src.ps1`。
9. 默认同步链路始终是：`src -> scripts/core/build/build.ps1 -> dist -> scripts/core/install/install-codex.ps1 / scripts/core/install/install-cursor-project.ps1`。
10. 只有在确认本地同步和安装产物都正确后，才按需要继续 Git 提交或 GitHub 推送。

### 1. 本机修改并本地生效

1. 只修改 `src/` 下的源文件。
2. 运行默认同步脚本 `scripts/update-from-src.ps1`。
3. 默认同步脚本必须自动完成：
   - `scripts/core/build/build.ps1`
   - `scripts/core/install/install-codex.ps1`
   - `scripts/core/install/install-cursor-project.ps1`，目标固定为默认 Cursor 项目路径
4. 只有在确实需要覆盖其它 Cursor 项目时，才额外手动执行 `scripts/core/install/install-cursor-project.ps1 -ProjectPath <其它项目路径>`。

### 2. 发布到 GitHub

1. 完成本地修改与必要验证。
2. 运行 `scripts/github-push.ps1 -CommitMessage "update skill xxx"`。
3. `github-push.ps1` 必须自动完成：
   - `scripts/update-from-src.ps1`
   - `git add .`
   - `git commit`
   - `git push`
4. 如果工作区没有可提交的变化，脚本应停止提交并明确提示。

### 3. 另一台机器拉取并部署

第二台机器仓库路径固定为：

- `I:/PYTHON/OWN_PROJECT/backup-test-cursor/ai-rules-hub`

第二台机器默认 Cursor 项目路径固定为：

- `I:/PYTHON/OWN_PROJECT/backup-test-cursor/workplace`

标准动作：

1. `git pull`
2. 运行 `scripts/core/build/build.ps1`
3. 如果该机安装了 Codex，运行 `scripts/core/install/install-codex.ps1`
4. 如果要让默认 Cursor 项目生效，可直接运行 `scripts/pull-and-deploy.ps1`。
5. 如果要让其它 Cursor 项目生效，运行 `scripts/core/install/install-cursor-project.ps1 -ProjectPath <项目路径>`
6. `scripts/pull-and-deploy.ps1` 必须先自动判断当前机器，再套用该机器对应的默认路径。

### 4. Cursor 项目级安装

当前约定只做 Cursor 项目级安装，不做全局覆盖所有项目。

安装目标：

- `<ProjectPath>/AGENTS.md`
- `<ProjectPath>/.cursor/rules/*.mdc`

规则：

- 由 `dist/cursor/project-template` 统一生成
- 安装脚本负责覆盖本仓库管理的规则文件
- 不手改项目中的生成产物，改动应回到 `src/`
- 根目录入口脚本保留分层，底层构建与安装脚本统一收纳到 `scripts/core` 分类目录。

## 七、自动执行与双渠道更新逻辑

### 1. 默认自动执行脚本

- 默认脚本：`scripts/update-from-src.ps1`
- 默认用途：只要 `src/` 中任何受管 skill 或 `src/AGENTS.md` 发生变化，就把最新规则自动同步到本机 Codex 与默认 Cursor 项目。
- 默认目标按机器自动判断：
  - 本机：
    - Codex：`%USERPROFILE%/.codex`
    - Cursor：`I:/STUDY/python/project/backup-test-cursor/cursor-workplace`
  - 远程电脑：
    - Codex：`%USERPROFILE%/.codex`
    - Cursor：`I:/PYTHON/OWN_PROJECT/backup-test-cursor/workplace`

### 1.1 GitHub 发布脚本

- 发布脚本：`scripts/github-push.ps1`
- 用途：在本机完成默认同步后，把当前仓库暂存、提交并推送到 GitHub。
- 默认顺序：
  - `update-from-src.ps1`
  - `git add .`
  - `git commit`
  - `git push -u origin <当前分支>`

### 2. 渠道一：skill 更新渠道

适用场景：

- 新增 skill
- 修改已有 skill
- 重命名 skill
- 调整 skill 触发描述、规则细则、脚本、路由

执行逻辑：

1. 先按预读要求读取 `skill-maintainer` 与系统 `skill-creator`；如涉及 `openai.yaml`，再读 `openai_yaml.md`。
2. 判断本次需求属于 `SKILL.md`、`references/*-rules.md`、`agents/openai.yaml`、`src/AGENTS.md` 还是 `scripts/*.ps1`。
3. 只修改 `src/`。
4. 修改后立即执行 `scripts/update-from-src.ps1`。
5. 核对当前机器对应的 Codex 安装目录和默认 Cursor 项目目录中的产物是否已更新。
6. 如需长期保留，再执行 Git 提交与推送。

### 3. 渠道二：反思总结渠道

适用场景：

- 用户要求“总结经验到 skill”
- 用户要求“把这次踩坑沉淀下来”
- 用户要求“把反思写回长期规则”

执行逻辑：

1. 优先读取 `src/skills/recall-thinking/references/recall-rules.md`。
2. 把经验主内容写回 `src/skills/recall-thinking/references/recall-rules.md`。
3. 如果这次反思改变了维护方式、同步方式、触发范围或部署规则，再同步修改：
   - `src/skills/skill-maintainer/SKILL.md`
   - `src/skills/skill-maintainer/references/skill-maintainer-rules.md`
   - 必要时 `src/AGENTS.md`
4. 修改后立即执行 `scripts/update-from-src.ps1`。
5. 再说明这次经验属于“仅经验扩充”还是“经验扩充 + 维护流程变更”。

## 八、构建与安装约束

1. `scripts/core/build/build.ps1` 只负责从 `src/` 生成 `dist/`，不直接安装到用户目录。
2. `scripts/core/install/install-codex.ps1` 只负责安装到 `C:/Users/18030/.codex`。
3. `scripts/core/install/install-cursor-project.ps1` 只负责安装到指定 Cursor 项目。
4. `scripts/core/env/resolve-machine-context.ps1` 负责判断当前是哪一台电脑，并返回对应默认路径。
5. `sync-local.ps1` 与 `update-from-src.ps1` 负责串联本机构建与安装。
6. `update-from-src.ps1` 应作为默认入口，优先用于 skill 更新与反思总结后的自动部署。
7. `github-push.ps1` 负责串联默认同步与 GitHub 发布，不应绕过 `update-from-src.ps1` 直接推送未同步的源改动。
8. 产物目录 `dist/` 允许被重建覆盖，不应手工维护。
9. 如果 skill 被重命名，安装脚本应负责清理旧的受管目录，例如从 `codex-skill-maintainer` 迁移到 `skill-maintainer`。

## 九、必须同步更新本文件的场景

以下任一情况发生时，必须同步检查并按需更新本文件：

- 新增自定义 skill
- 从外部仓库安装自定义 skill
- 删除自定义 skill
- 重命名自定义 skill
- 调整 skill 职责定位
- 调整新增 skill 的默认落点、标准目录结构或预读要求
- 修改 `src -> dist -> install` 这条链路
- 增加、删除或重构构建与安装脚本
- 修改默认自动部署入口或默认 Cursor 项目路径
- 改变 Codex 或 Cursor 的安装策略

## 十、禁止项

1. 不要直接手改 `dist/`。
2. 不要直接手改 `C:/Users/18030/.codex/skills` 中受管 skill 的安装产物，除非是在调试安装脚本且之后会回写 `src/`。
3. 不要把 `.system` 技能混入这套自定义规则仓库。
4. 不要在没有同步更新 `src/AGENTS.md` 与本文件的情况下重命名或重构 skill。
5. 除非用户明确要求，否则不要推送到 GitHub；需要推送时优先使用 `scripts/github-push.ps1`。
