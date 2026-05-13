# Chinese Call Prompt Templates

Load this reference when the user wants ready-to-paste Chinese prompts for live draft revision, anti-similarity rewriting, formatting cleanup, figure restoration, or screenshot insertion.

Replace bracketed placeholders before use.

## 1. Continue Revising The Working Draft

```text
请使用 $academic-paper-composer 继续在我当前的 working draft 上改稿。working draft 路径是：[working_draft_path]。请先备份，再按学校模板和项目证据继续修改，不要误改到原始初稿。
```

## 2. Replace Only A Selected Body Span

```text
请使用 $academic-paper-composer 只替换正文 [起始标题] 到 [结束标题] 之前的内容，其他部分保持不动。请只按正文标题锚点操作，不要把目录里的同名条目当成正文锚点。
```

## 3. Restore E-R Diagram And Database Tables

```text
请使用 $academic-paper-composer 保留并恢复原来的数据库 E-R 图和每张数据表的字段说明表，再把当前定稿对应的正文内容补回到 working draft。缺失内容优先从原稿恢复，不要凭空重写旧图表。
```

## 4. Another Anti-AIGC / Anti-Similarity Round

```text
请使用 $academic-paper-composer 根据我最新的查重报告和 AIGC 报告继续改稿，目标是进一步降到 [目标值] 以下。只优先处理剩余热点页，不要整篇重写，并在改稿说明里写清楚本轮处理了哪些热点。
```

## 5. Formatting Cleanup For Final Submission

```text
请使用 $academic-paper-composer 按学校模板把当前 working docx 收口成最终版。要求全文黑色、中文标题不要加粗、去掉蓝色超链接样式、数据库字段说明表使用学校要求的小字号，并单独输出一份改稿说明。
```

## 6. Add Real Runtime Screenshots

```text
请使用 $academic-paper-composer 为论文补真实系统运行截图。请从实际运行项目里截取 [页面列表]，把截图插入对应章节，补一条引导句和规范图题，并把截图文件单独保存到输出目录。
```

## 7. Salvage Mode For A Hand-Edited Draft

```text
请使用 $academic-paper-composer 进入 hand-edited draft salvage mode。当前我手改的是：[working_draft_path]，原始保护稿是：[original_draft_path]。请保留我已手改的正文部分，只修复指定区间、恢复丢失图表，并补充系统运行截图。
```

## 8. Full Finalization With Rework Report

```text
请使用 $academic-paper-composer 根据项目证据、学校模板和现有论文草稿完成定稿整理。请输出处理后的 working draft，并另写一份改稿报告，说明删除了哪些不实表述、恢复了哪些旧图表、补了哪些截图、还剩哪些人工复核项。
```
