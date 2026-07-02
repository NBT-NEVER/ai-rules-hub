# 全局入口说明

本文件只保留长期全局约束和常用 skill 路由。具体细则优先放到对应 skill，不在这里重复展开。

## 全局约束

- 默认使用中文交流，除非我明确要求英文。
- 回答应直接、清晰、少空话，优先给可执行结果。
- 不要擅自编造缺失信息；如果关键信息不足，应明确指出缺口。
- 处理代码任务时，先尊重当前仓库已有风格，再应用我的长期规则。
- Python 源文件头默认统一采用以下约定：开发者署名写为 `开发者: NBT`，时间字段写为 `开发时间`，`功能说明` 使用中文具体功能描述，下一行补 `版本号：x.x`；如果当前对话明确要求其他格式，以当前对话要求为准。
- 处理写作任务时，先依据我提供的原始材料输出，不要脱离代码或实验要求空泛发挥。
- 只要安装、新增、删除、重命名、重构或调整 `skills` 下任意 skill，必须同步检查并按需更新本文件，以及 `skills/skill-maintainer/references/skill-maintainer-rules.md`。

## Skill 路由

- 中文内容读写、防乱码、中文抽取/转存/写回、可复制到 Word 或写入 LaTeX 源文件的中文材料：`skills/chinese-encoding-guard`
- 使用 LaTeX 编码撰写实验报告、课程论文、学术论文，且必须严格按给定模板生成、修改或验证 `.tex` 结构；也用于把学校模板抽取为可复用的通用 LaTeX 规则文档：`skills/latex-coding-report-requirements`
- 代码编写、改代码、工程整理、Python 项目搭建、路径管理、中文注释规范、README 与 requirements 整理、同目录 README 中代码原理公式与变量说明：`skills/code-project-rules`
- Git 暂存、提交、分支管理、远程 `origin` 配置、GitHub 推送/拉取、代理检查、推送超时、大文件入库、Git LFS、提交归因与项目级版本管理：`skills/git-github-remote-management`
- 实验报告、算法说明、论文解读中的公式说明、实验报告正文公式排版、对话中公式的渲染版与 LaTeX 双版本展示、方法说明、实现逻辑概述、课程式技术说明、结果分析、README 式中文项目介绍：`skills/lab-report-writer`
- 在对话中解释公式、需要先给渲染公式再给 LaTeX 版本、并逐项解释变量：`skills/lab-report-writer`
- 与代码位于同一文件夹的 `README.md` 中需要写代码原理公式、LaTeX 变量说明或 GitHub 可渲染公式：`skills/code-project-rules`
- 学术报告、论文、摘要、结论、正式工科说明的降 AI 味、降模板化改写：`skills/academic-anti-ai-writing`
- 基于真实项目做本科论文大纲、证据映射、章节规划、配图规划、保留/重写范围判断：`skills/academic-paper-strategist`
- 基于真实项目和已有草稿完成本科论文正文重写、定稿整理、截图替换、最终交付；主要负责 Word/DOCX 定稿流，LaTeX 模板定稿流转交 `skills/latex-coding-report-requirements`：`skills/academic-paper-composer`
- 英文论文 PDF 中 Zotero 灰色下划线标注的英文单词、术语短语和整句标注提取，整理中文释义、音标、论文内例句、页码和标注次数，并输出指定位置的 CSV 词汇表：`skills/english-paper-vocabulary`
- 中文文献检索、论文筛选、合法全文获取、批量文献采集、DOI/PMID 查询、期刊指标核验、下载日志与 Zotero/BibTeX 整理：`skills/literature-downloader`
- Word/docx、LaTeX 源文件、PowerShell 中文链路、高价值文件覆盖、批量替换、需要先复用稳定经验再动手的任务：`skills/recall-thinking`
- 新增、安装、删除、重命名、重构、同步或维护 `skills` 下任意 skill，以及沉淀经验到 skill：`skills/skill-maintainer`

## 常见组合

- 代码任务涉及中文注释、中文 README、中文输出：`skills/code-project-rules` + `skills/chinese-encoding-guard`
- LaTeX 实验报告、课程论文或学术论文任务要求严格复用学校模板、老师模板、现有 `.tex` 样式或固定框架时：`skills/latex-coding-report-requirements`
- Word/DOCX 定稿与 LaTeX 模板定稿分开处理：前者优先 `skills/academic-paper-composer` + `skills/chinese-encoding-guard` + `skills/recall-thinking`，后者优先 `skills/latex-coding-report-requirements` + `skills/chinese-encoding-guard`
- 同一任务同时涉及实验报告正文公式排版和同目录 README 公式时：`skills/lab-report-writer` + `skills/code-project-rules`
- 只在对话框中展示和讲解公式，不写入文档时：`skills/lab-report-writer`
- 远程推送 GitHub、`git add`、`git commit`、`git push`、修改远端地址、处理代理/超时/大文件/提交归因等项目管理任务：`skills/git-github-remote-management`
- 实验报告、技术说明、正文公式排版或对话公式说明需要减少 AI 味：`skills/lab-report-writer` + `skills/academic-anti-ai-writing` + `skills/chinese-encoding-guard`
- 论文从项目证据出发先规划再成稿：先 `skills/academic-paper-strategist`；Word/DOCX 定稿再用 `skills/academic-paper-composer`，LaTeX 模板定稿再用 `skills/latex-coding-report-requirements`；中文写回时加 `skills/chinese-encoding-guard`，高价值文件修改前加 `skills/recall-thinking`
- 查论文、批量筛文献、优先合法下载 PDF/HTML/XML 全文、整理 DOI/PMID/Zotero/BibTeX：`skills/literature-downloader`
- 从已标注英文论文 PDF 提取灰色下划线英文单词、短语或整句标注并生成 CSV 词汇表：`skills/english-paper-vocabulary` + `skills/chinese-encoding-guard`
- Word/docx 或高价值文件修改同时含中文内容：`skills/chinese-encoding-guard` + `skills/recall-thinking`
- 安装或修改任意 skill 后，需要同步检查 `C:/Users/18030/.codex/AGENTS.md` 是否补充、删减或改写入口路由：`skills/skill-maintainer`
- 涉及 skill 的更新、下载、部署、本地安装或 Cursor 项目级安装时，优先使用：`skills/skill-maintainer`
- 涉及 skill 体系改完后的 `git add`、`git commit`、GitHub 同步、远端推送和推送失败排查时，优先组合使用：`skills/skill-maintainer` + `skills/git-github-remote-management`
- 涉及反思总结写回 skill、沉淀新经验、增添新 skill，或需要把 `src` 自动同步到 Codex 和 Cursor 项目时，优先使用：`skills/skill-maintainer`
- 新增 skill、重构 skill 结构或明显修改 skill 元信息时，优先使用：`skills/skill-maintainer`，并同时参考 `C:/Users/18030/.codex/skills/.system/skill-creator`
- 如果当前对话中的明确要求与 skill 规则冲突，以当前对话要求为准；如果仓库本地约束比 skill 更具体，优先遵守本地约束，再补充 skill 规则。
