---
name: academic-paper-composer
description: Use when the user needs to turn a real software engineering / computer science project and an existing thesis draft into a submission-ready undergraduate thesis manuscript. Trigger for requests such as "根据项目把论文改成定稿", "按学校模板排版成最终版", "复制初稿后生成定稿 Word", "为定稿降查重", "根据PaperPass报告降AIGC", "继续在手改初稿上改", "恢复原来的图表和数据库说明", or when academic-paper-strategist has already produced an evidence-backed rewrite plan. Outputs a cleaned manuscript, final DOCX workflow, and a separate rework report.
---

# Academic Paper Composer

## Overview

This is the writing and finalization skill for Codex-based undergraduate software engineering theses. It consumes the strategist's evidence-backed plan and turns it into a clean, submission-ready manuscript grounded in the real project.

**Companion flow**:
1. `academic-paper-strategist` - determine structure, evidence map, keep/rewrite/delete scope
2. `academic-paper-composer` - rewrite sections and assemble the final thesis text
3. `drawio` - rebuild engineering-style figures when needed
4. `playwright` - capture real runtime screenshots when the thesis needs running-system evidence
5. `doc` - apply Word formatting and visually verify the final DOCX

This skill is responsible for the thesis content and final assembly logic. It must not claim completion until the copied or user-designated working DOCX has been formatted and checked.

## Required Inputs

- the strategist's outline or rewrite brief
- the existing thesis draft
- the school format sample
- the real project evidence files
- detection reports when available (similarity / plagiarism / AIGC PDFs, screenshots, or extracted text)
- the exact destination path for the copied final DOCX or the exact working draft path the user wants to continue editing
- the exact destination path for the rework report, if provided

## Non-Negotiable Rules

- Operate on a copied draft only unless the user explicitly says the current hand-edited draft is now the working file.
- Never overwrite the user's untouched original source draft.
- Load and obey:
  - `references/zjkj-undergrad-thesis-format.md`
  - `references/project-grounding-rules.md`
  - `references/finalization-task-rules.md`
- Load `references/detection-report-rewrite-playbook.md` whenever the user asks to lower similarity or AIGC risk and provides reports.
- Load `references/docx-draft-salvage-and-runtime-screenshot-playbook.md` whenever the task involves continuing from a hand-edited draft, partial section replacement, restoring original tables/figures, or adding real running-system screenshots.
- Load `references/thesis-revision-operation-checklist.md` whenever the task involves editing a live working draft, because the edit order matters.
- Rewrite unsupported text instead of polishing false content.
- When lowering similarity or AIGC risk, rewrite the wording while preserving project truth; never game the score by inventing facts or deleting essential substance.
- Keep all visible manuscript text black.
- Remove hyperlink styling, process notes, instructional text, and template hints.
- Use only project-supported figures and screenshots.
- Prefer restoring a supported original figure/table over redrawing it.
- Keep the testing chapter conservative and evidence-based.

## Workflow

### Step 1: Safety Copy

If the user provides a source draft and a destination path:
- copy the source draft first
- verify the destination copy exists
- preserve the source draft untouched

If the user says the already hand-edited draft is the working file:
- treat that file as the working manuscript
- create a timestamped backup before any structural edit
- keep all later edits on that working file only

Do not start direct editing on the wrong file under any circumstance.

### Step 2: Format Baseline Extraction

Read `references/zjkj-undergrad-thesis-format.md` and the provided school sample.

Extract and enforce:
- cover structure
- originality statement
- copyright authorization
- Chinese abstract page
- English abstract page
- automatic table of contents
- heading hierarchy
- body typography
- figure/table caption style
- references
- acknowledgement
- appendices

### Step 3: Draft Audit

Scan the current draft and mark:
- content to keep
- content to rewrite
- content to delete
- figures to replace
- figures/tables to preserve from the original draft
- formatting pollution to remove

Specifically remove:
- colored titles
- hyperlink-style headings
- template prompts
- revision notes
- unsupported data claims
- decorative figures

### Step 3A: Detection-Report Triage

If the user provided similarity or AIGC reports, read `references/detection-report-rewrite-playbook.md`.

At this stage:
- extract the latest score and hotspot pages
- map each hotspot back to the copied draft
- decide whether each hotspot needs heavy structural rewriting or light cleanup

### Step 3B: Existing-Draft Continuation / Salvage Mode

Use this mode when the user has already hand-edited part of the draft or asks to keep specific old content.

In this mode:
- identify the true working DOCX first
- identify the protected backup/original DOCX second
- detect replacement boundaries by **body heading style**, not by table-of-contents text
- never use TOC paragraphs as anchors for section replacement
- when the user asks to replace only content before or after a section such as `2.3`, edit only that body span
- preserve untouched manual edits outside the requested span
- if the user asks to keep an original E-R figure, per-table database description, or other supported legacy asset, restore it from backup instead of regenerating it

### Step 4: Rewrite The Thesis Body

Rewrite chapter by chapter using only project-supported evidence.

Typical chapter responsibilities:
- **Introduction**: background, significance, scope, chapter arrangement
- **Requirements analysis**: roles, workflows, functional and non-functional requirements
- **Overall design**: architecture, modules, data design, security/control strategy
- **Detailed implementation**: real mechanisms from code and config
- **Testing**: real functional verification and conservative summary
- **Conclusion**: summarize actual completed work and future improvements

For every section:
- prefer precise engineering wording
- avoid exaggerated novelty language
- avoid unsupported metrics
- remove any instruction text before final assembly

When the task includes lowering similarity or AIGC risk, apply these rewrite rules:
- follow the rewrite principles and transformations in `references/detection-report-rewrite-playbook.md`
- keep technical facts, chapter structure, figure/table numbering, and citations stable unless they are unsupported
- preserve meaning first; score reduction is secondary to factual accuracy

### Step 4A: Anti-AIGC / Anti-Similarity Rewrite Loop

When the user gives a target such as "降到 10% 以下":
1. attack the highest-yield hotspots first
2. rebuild the copied manuscript
3. if the user brings back a newer report, repeat the triage -> rewrite -> rebuild loop
4. in later rounds, focus only on the remaining hotspot pages instead of rewriting the whole paper again

Do not promise a score in advance. The composer's responsibility is to maximize safe, evidence-preserving reductions.

### Step 5: Figures, Legacy Assets, And Database Tables

If the thesis already contains a supported original figure or table block that the user wants to keep:
- preserve or restore it from the backup/original draft
- keep the caption style consistent with the school sample
- renumber later figures/tables only when necessary

Common salvage cases include:
- original E-R figure blocks
- per-table database field-description blocks
- screenshots already extracted from a valid older manuscript
- original engineering diagrams that still match the project

Only redraw through `drawio` when the figure is missing, unsupported, or visually unsuitable.

### Step 5A: Real Runtime Screenshot Capture

If the thesis needs system-running screenshots:
- prefer capturing the real application over fabricating static mockups
- use `playwright` or an equivalent browser workflow
- save screenshot assets under `output/playwright/` or a similarly explicit output directory
- insert screenshots near the subsection they support, with one short lead-in sentence and a thesis-style caption

When the main database is unavailable or risky to touch:
- create a temporary screenshot-only config
- prefer an isolated H2 + Flyway setup over modifying the primary `application.yml`
- seed or create only minimal demo data needed for the screenshots
- shut down the temporary runtime after capture

Good screenshot targets include:
- login page for authentication chapter
- resident appointment page for appointment flow chapter
- resident dashboard / health-code page for health-code chapter
- resident health-report page for reporting chapter
- admin appointment / review pages for backend operation chapters
- admin dashboard for operation summary / running-status sections

### Step 6: Final DOCX Formatting Through Doc

Use `doc` to finalize the working `.docx`:
- apply school-required heading styles
- ensure all text is black
- ensure Chinese headings are not bold unless the school sample explicitly requires it
- ensure paragraph spacing and line spacing match the school sample
- ensure TOC is automatic
- ensure figures and captions are placed correctly
- ensure references use hanging indent and correct typography
- ensure field-description tables use the correct smaller font when the sample requires it
- render and visually inspect pages when possible

### Step 7: Write A Separate Rework Report

The rework report belongs outside the final thesis and may include:
- deleted or weakened claims
- unsupported data not retained
- manual review items
- figure rebuild notes
- formatting fixes
- for similarity / AIGC tasks: which pages were hotspots, what rewrite strategy was used, and what still needs recheck in the next report
- for salvage tasks: which sections were restored from backup, which screenshots were newly captured, and which manual edits were intentionally preserved

Do not let any of that text leak into the final DOCX body.

### Step 8: Final Self-Check

Do not deliver until all of the following are true:
- original draft untouched or explicitly superseded by a user-designated working draft
- working DOCX backed up before structural edits
- TOC paragraphs were not mistaken for body anchors
- all headings/body text black
- no blue titles remain
- all figures and screenshots match thesis style
- legacy figures/tables requested by the user were preserved or restored
- no process/instruction text remains
- school format sample followed
- TOC automatic
- manuscript is ready to submit

## Writing Rules For Conservative Accuracy

- Replace unsupported "performance evaluation" with "functional verification" or "scenario-based testing" when appropriate.
- If no formal stress test exists, do not write performance benchmark tables.
- If no real deployment exists, avoid claims about cluster deployment, production operation, or concurrency scale.
- If a module is configured but not fully demonstrated, describe it carefully as implemented support rather than proven large-scale capability.
- For high-risk AIGC paragraphs, prefer "rewrite the whole sentence logic" over "swap a few words".
- When a paragraph still reads like a polished template, reduce polish before you reduce truth: vary sentence length, remove stock transitions, and anchor the wording in the actual repository.

## References To Load As Needed

- `references/zjkj-undergrad-thesis-format.md`
- `references/project-grounding-rules.md`
- `references/finalization-task-rules.md`
- `references/detection-report-rewrite-playbook.md`
- `references/docx-draft-salvage-and-runtime-screenshot-playbook.md`
- `references/thesis-revision-operation-checklist.md`
- `references/chinese-call-prompt-templates.md`
- `references/section_guides.md`
- `references/writing_standards.md`

## Example Prompts

- `继续在我手改的初稿上改，只替换正文 1 引言 到 2.3 前面的内容，目录不要当锚点。`
- `保留原来的数据库 E-R 图和每张表的字段说明表，再把定稿对应内容补回 working draft。`
- `根据这份最新 AIGC 报告继续降到 10% 以下，只改剩余热点页，不要整篇重写。`
- `按学校模板把当前 working docx 整理成最终版：标题不要加粗，全文黑色，表格字段说明用五号。`
- `给论文补系统运行截图，截图要来自真实项目页面，并且单独输出一份改稿说明。`

## Output Expectations

Produce:
- a cleaned thesis manuscript
- a final DOCX workflow executed on the copied draft or user-designated working draft
- a separate rework report

Never treat comments to the author, fix notes, or review annotations as manuscript content.
