# Draft Salvage Handoff Playbook

Load this reference when the strategist must prepare a handoff for an existing draft that is already partially usable, partially hand-edited, or contains legacy figures/tables the user wants to keep.

## 1. Working Draft Map

The handoff must explicitly name:
- current working draft path
- protected original/backup draft path
- whether the user has already hand-edited the working file
- whether the composer should copy again or continue in place

Do not leave this ambiguous.

## 2. Replace / Preserve Matrix

For each relevant chapter or subsection, classify it as one of:
- replace completely
- replace only before anchor X
- replace only after anchor X
- preserve manual edits outside a narrow replacement span
- restore from backup if current version is worse
- keep untouched

## 3. Anchor Rules For The Handoff

When planning selective replacement:
- specify the boundary headings exactly
- require body heading styles such as `Heading 1/2/3`
- explicitly forbid using TOC paragraphs as anchors

Examples worth calling out in the handoff:
- `1 引言`
- `2.3 非功能需求`
- `2.4 业务流程分析`
- `3.3 数据库设计`

## 4. Legacy Asset Retention Plan

The strategist should identify any old manuscript blocks that are still evidence-backed and worth restoring, such as:
- original E-R figure subsection
- original per-table database field-description blocks
- original supported module screenshots
- original captions that already match school style

For each retained asset, specify:
- where it belongs now
- whether numbering must change
- whether later blocks depend on it

## 5. Database Chapter Planning

If the original draft contains valid per-table database descriptions grounded in SQL or migration files, prefer this structure in the handoff:
- `3.3.1` overview and E-R discussion
- `3.3.2` per-table field-description block
- `3.3.3` indexes and constraints

Do not compress everything into one summary table if the school-style manuscript clearly benefits from fuller database explanation.

## 6. Runtime Screenshot Plan

When the final thesis needs "系统运行截图", the handoff should define:
- which pages to capture
- which user role each page needs
- what minimal demo data must exist first
- which chapter/subsection each screenshot supports
- whether the screenshot is mandatory or optional

Good default screenshot candidates:
- login page
- resident appointment page
- resident dashboard / health code page
- resident health-report page
- admin appointment page
- admin health-report review page
- admin dashboard

## 7. Safe Runtime Strategy

If the live database environment may block or pollute capture work, tell the composer to:
- prefer a temporary screenshot-only config
- consider H2 + Flyway for isolated startup
- avoid modifying the main runtime config just to capture screenshots
- shut down the capture runtime after screenshots are saved

## 8. Handoff Fields To Include

A good handoff for the composer should contain these explicit fields:
- working draft path
- backup/original draft path
- preserve list
- replace list
- body heading anchors
- screenshot capture list
- demo-data prerequisites
- figure/table renumbering risks
- final manual-review checkpoints
