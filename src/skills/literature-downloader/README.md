# Literature Downloader Skill

面向中国大学生、研究生、博士和老师的中文文献检索与合法全文获取 Codex Skill。

它不是盗版下载器，也不会绕过付费墙。它的目标是把“找文献、筛文献、查期刊质量、尝试获取开放全文、整理下载结果”做成一套清楚、可复现、适合学生使用的流程。

## 适合谁

- 需要快速入门一个研究主题的本科生、研究生、博士生
- 正在写综述、开题报告、论文引言的同学
- 需要批量整理 DOI、PDF、期刊指标和阅读清单的研究者
- 想把文献检索流程交给 AI agent 辅助完成的老师或课题组

## 能做什么

- 根据主题生成关键词、同义词和 Boolean 检索式
- 生成 Google Scholar、PubMed、Crossref、OpenAlex、Semantic Scholar、PMC、arXiv 等检索入口
- 批量维护候选文献表
- 按相关性分出高、中、低优先级文献
- 尝试下载合法可访问的 PDF、HTML、XML 全文
- 识别登录页、订阅页、403、短 HTML 跳转页，避免把失败误报成成功
- 生成中文下载报告 PDF/HTML
- 生成学生友好的中文表格：
  - `文章地址总表.csv`
  - `候选文献总表.csv`
  - `已下载文献清单.csv`
  - `待处理文献清单.csv`
- 在每篇文献行中合并期刊指标字段：影响因子、分区、指标年份、指标来源、索引情况
- 把英文兼容文件和原始日志收进 `内部数据_一般不用打开/`，让输出目录更清楚

## 不做什么

本项目不会、也不应被改造成：

- 付费墙绕过工具
- 盗版论文下载器
- 账号共享工具
- DRM 破解工具
- 影子图书馆访问器

如果出版社或数据库限制直连下载，Skill 会把结果标为“平台限制直连下载”，并建议使用学校图书馆、机构 VPN、馆际互借、机构仓储或联系作者。

## 安装

把本仓库放到 Codex skills 目录，例如：

```powershell
git clone https://github.com/Lucaswangzcx/literature-downloader-skill.git $env:USERPROFILE\.codex\skills\literature-downloader
```

也可以手动下载后放入：

```text
<你的 Codex skills 目录>/literature-downloader/
```

目录中必须能看到：

```text
SKILL.md
agents/openai.yaml
references/
scripts/
```

## 最简单用法

在 Codex 中直接说：

```text
Use $literature-downloader 帮我下载“LLM 在环境领域中的应用”的近五年文献，优先高影响因子，最多 20 篇，下载到 <下载目录>
```

或换成自己的主题：

```text
Use $literature-downloader 帮我下载“你的研究主题”的近五年文献，优先高影响因子，最多 20 篇，下载到 <下载目录>
```

## 在其他 AI 编程工具中使用

本项目首先是一个 Codex Skill，但并不只能在 Codex 里用。

### Codex 原生体验

Codex 可以识别 `SKILL.md`，并支持类似下面的调用方式：

```text
Use $literature-downloader 帮我下载“LLM 在环境领域中的应用”的近五年文献，优先高影响因子，最多 20 篇，下载到 <下载目录>
```

这属于 Codex 的 Skill 自动触发体验。

### Claude Code / Trae / CodeBuddy / Cursor 等工具

这些工具不一定认识 `Use $literature-downloader` 或 Codex Skill 的自动注入机制，但仍然可以使用本项目。

使用方式是：

1. 让 agent 阅读本仓库的 `README.md` 和 `SKILL.md`
2. 要求它严格按 `literature-downloader` 工作流执行
3. 让它调用 `scripts/` 里的脚本
4. 明确要求只下载合法可访问全文，不绕过付费墙
5. 最后生成中文报告、文章地址总表、已下载文献清单、待处理文献清单

可以直接复制下面这段提示词给 Claude Code、Trae、CodeBuddy 或 Cursor：

```text
请阅读当前仓库的 README.md 和 SKILL.md，并严格按其中的 literature-downloader 工作流执行。

我的任务是：下载“LLM 在环境领域中的应用”的近五年文献，优先高影响因子，最多 20 篇，下载到 <下载目录>。

要求：
1. 只允许使用合法可访问的全文来源，不要绕过付费墙，不要使用盗版来源。
2. 先创建批量采集任务目录。
3. 生成候选文献表，并在每篇文献行中列出题名、年份、期刊或来源、影响因子/分区、指标年份、指标来源、DOI、文章地址、全文状态和下一步建议。
4. 尝试下载开放 PDF、HTML 或 XML；遇到登录页、403、订阅页、短 HTML 跳转页时，不要算成功，写入待处理清单。
5. 最后运行 scripts 生成中文下载报告、文章地址总表、已下载文献清单、待处理文献清单，并整理输出目录。
```

如果只想把它当作普通脚本工具包，也可以直接运行 `scripts/` 里的脚本，见下一节。

## 手动运行脚本

创建任务目录：

```bash
python scripts/prepare_harvest_run.py \
  --topic "LLM 在环境领域中的应用" \
  --keywords "large language model|LLM|ChatGPT,environmental science|climate|sustainability" \
  --years 2021-2026 \
  --output-root literature_runs \
  --run-name llm_environment
```

把检索得到的文献填入 `candidate_table.csv` 后，继续运行：

```bash
python scripts/rank_candidates.py --run-root literature_runs/llm_environment
python scripts/download_accessible_fulltexts.py --run-root literature_runs/llm_environment --retry-failed
python scripts/make_student_outputs.py --run-root literature_runs/llm_environment
python scripts/generate_readable_report.py --run-root literature_runs/llm_environment --title "文献下载报告" --pdf
python scripts/organize_final_outputs.py --run-root literature_runs/llm_environment
```

## 推荐输出结构

任务完成后，普通用户主要看这些：

```text
00_先看我_文件说明.txt
下载报告.pdf
下载报告.html
文章地址总表.csv
候选文献总表.csv
高优先级文献.csv
已下载文献清单.csv
待处理文献清单.csv
已下载全文/
内部数据_一般不用打开/
```

其中：

- `下载报告.pdf`：最适合直接阅读和转发
- `文章地址总表.csv`：题名、文章地址、是否下载成功、下一步建议
- `已下载全文/`：实际下载到的 PDF 或全文文件
- `待处理文献清单.csv`：没能直接下载的文献和下一步合法获取方式
- `内部数据_一般不用打开/`：脚本兼容文件和原始日志，普通用户通常不用看

## 期刊指标说明

影响因子、JCR 分区、SJR、CiteScore、索引状态都会随年份变化。Skill 的原则是：

- 不凭空生成指标
- 指标必须标注年份和来源
- 没核验时显示“待核验”
- 不把 JIF、SJR、CiteScore 混称为同一个指标
- 所有面向学生的文献清单都把期刊指标并入每一行，不要求用户单独对照另一张表

## 隐私与合规

本仓库不应包含：

- 个人下载结果
- 论文 PDF
- 学校账号或浏览器 Cookie
- API key、token、密码
- 本机路径、用户名、邮箱
- 任何绕过访问控制的代码

`.gitignore` 已默认排除报告、日志、下载全文、内部数据等运行产物。提交前仍建议再做一次敏感信息扫描。

## 许可证

MIT License。详见 [LICENSE](LICENSE)。

## 贡献

欢迎提交 issue 或 pull request，尤其是：

- 更好的中文输出格式
- 更多数据库的合法检索流程
- 更稳的 PDF/HTML/XML 识别
- 更清楚的学生阅读清单
- 期刊指标核验流程改进

请先阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。
