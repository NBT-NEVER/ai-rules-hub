# 中文启动提示模板

直接这样启动：

```text
Use $literature-downloader 帮我检索主题：[主题]。
要求：近 [年份范围]，找 [数量] 篇，优先高影响因子/高分区/权威期刊，尽量要能合法下载全文。
请输出：关键词和检索式、推荐文献表、影响因子或分区依据、全文下载入口、无法下载时的合法替代路线。
```

批量采集这样启动：

```text
Use $literature-downloader 为主题“[主题]”创建一个批量文献采集任务。
要求：
- 年份：[年份范围]
- 目标篇数：[数量]
- 质量条件：[影响因子/JCR 分区/SCI/SSCI/EI/Scopus/PubMed]
- 全文策略：优先合法开放 PDF，其次 HTML/XML 全文，再记录需要学校库/馆际互借/联系作者的文献
- 输出：任务目录、config.json、candidate_table.csv、高/中优先级表、download_log.csv、汇总报告
```

处理已有 DOI/题名清单这样启动：

```text
Use $literature-downloader 帮我检查下面这些文献是否能合法下载全文，并整理成表格：
[粘贴 DOI、PMID、题名或文献清单]
```
