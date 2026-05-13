# Chinese Call Prompt Templates

Load this reference when the user wants ready-to-paste Chinese prompts for planning, evidence mapping, detection-report triage, or handoff generation.

Replace bracketed placeholders before use.

## 1. Thesis Planning From Codebase

```text
请使用 $academic-paper-strategist 基于当前项目仓库、学校模板和现有论文草稿，先做本科毕业论文定稿规划。要求只保留代码、SQL、配置和文档能证实的内容，输出章节大纲、证据映射、keep/rewrite/delete 矩阵、图表规划和后续给 composer 的 handoff。
```

## 2. Continue From A Hand-Edited Draft

```text
请使用 $academic-paper-strategist 继续在我已经手改过的 working draft 上做规划。当前 working draft 是：[working_draft_path]。请不要整篇推翻，只给我做 preserve / replace 方案，明确哪些正文区间可替换，哪些手改内容必须保留。
```

## 3. Partial Replacement Planning

```text
请使用 $academic-paper-strategist 按正文标题给我做局部替换规划。只替换正文 [起始标题] 到 [结束标题] 之间的内容，禁止把目录里的同名条目当成锚点。输出 body anchor、replace 范围、preserve 范围和风险点。
```

## 4. Detection Report Triage

```text
请使用 $academic-paper-strategist 根据这份查重报告和 AIGC 检测报告先做热点分析，不要直接改正文。请把热点页映射到论文章节，给出重写优先级，并区分哪些段落需要重写结构、哪些只需要轻度改写。
```

## 5. Legacy Asset Retention Plan

```text
请使用 $academic-paper-strategist 为我当前论文做保留/恢复规划。要求保留原来的数据库 E-R 图、每张数据表的字段说明表，以及已经有效的旧截图。请输出哪些内容保留、哪些内容恢复、哪些内容重画。
```

## 6. Runtime Screenshot Plan

```text
请使用 $academic-paper-strategist 给论文补一套系统运行截图规划。请按角色、页面、章节位置和所需演示数据输出截图计划，并说明哪些截图必须来自真实运行页面。
```

## 7. Composer Handoff Package

```text
请使用 $academic-paper-strategist 直接生成给 $academic-paper-composer 的 handoff package。里面必须包含 working draft 路径、original/backup 路径、body heading anchors、replace/preserve 列表、图表保留策略、截图计划和人工复核点。
```
