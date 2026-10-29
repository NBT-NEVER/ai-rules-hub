---
name: paper-reading-zh
description: 用中文深度阅读和批判分析研究论文、预印本或学术文章。用户提供论文链接、PDF、标题、摘要，或要求总结、理解、拆解方法、检查实验、设计复现与反例、提出后续研究时使用。适用于计算机、软件工程、AI/ML 及相邻技术和科学方向；重点是重建作者推理、解释机制、核对证据和形成可执行的研究判断。只检索、下载或整理文献时使用 literature-downloader；只需把已有阅读材料写成报告时转交 lab-report-writer。
---

# 中文论文深度阅读

先阅读 `references/paper-reading-rules.md`，再按用户提供的材料选择快速筛读、完整深读或论文对比模式。需要补全文、核对来源或整理引用时，先调用 `literature-downloader` 的相应规则；不要在本 skill 内复制下载流程。

## 协作规则

1. 优先获取论文全文，至少核对 abstract、introduction、related work、method、experiments、conclusion 和 appendix。只有摘要时，明确标注分析范围和无法验证的内容。
2. 先给出 1-2 个由论文引出的研究问题，帮助用户决定是否值得继续读；用户明确要求完整分析时直接进入完整模式。
3. 完整阅读按“问题与重要性、前人工作与不足、作者思路、核心 intuition、方法 pipeline、数学、实验、takeaways、脆弱假设、最小复现、最强反例、follow-up”展开。没有形式化数学时说明并跳过数学推导。
4. 严格区分论文原文声称、相关文献已有结论、基于证据的推断和仍不确定的猜测；不把摘要、标题或常识补成论文结论。
5. 需要检索或获取论文时，复用 `literature-downloader` 的来源质量、合法全文和去重规则；不要绕过付费墙或伪造引用。
6. 中文写回、公式展示和正式学术表达分别遵循 `chinese-encoding-guard`、`formula-character-expression` 和 `academic-anti-ai-writing`；项目论文需要落到真实代码证据时，再结合 `academic-paper-strategist`。

## 交接规则

- 从 `literature-downloader` 接收题录卡、全文状态、canonical URL、版本和合法获取路径；缺少全文时先说明分析边界。
- 输出“阅读判断卡”：核心 claim、证据位置、四类信息标签、关键假设、失败条件、最小复现和未决问题。
- 用户要实验报告、课程说明或 README 成文时，把阅读判断卡交给 `lab-report-writer`；用户要本科论文证据映射时交给 `academic-paper-strategist`。

## 输出要求

以连贯中文为主，只有在 pipeline、实验问题链、变量清单或复现步骤确实更清楚时使用列表。保留必要英文术语，给出具体对象、条件、测量和证据，不用空泛的“效果显著”“具有重要意义”。
