# Thesis Revision Operation Checklist

Load this checklist when the composer is editing a real working draft instead of writing a paper from scratch.

Use it as an execution-order guardrail for tasks such as:
- continue from a hand-edited draft
- replace only a selected body span
- restore original figures or per-table database description blocks
- add real runtime screenshots
- perform another anti-similarity or anti-AIGC round on a newer report

## 1. Lock The Working Files

Before editing, record all three roles explicitly:
- working manuscript path
- protected original source path
- newest backup path

If the user says the initial draft is now the hand-edited base, use that file as the working manuscript.
Do not switch to an older copied final draft just because its name looks newer.

## 2. Create A Timestamped Backup

Before structural edits:
- create a fresh timestamped backup of the working DOCX
- keep prior backups
- never overwrite the untouched source manuscript

If the working file is already the user's hand-edited draft, this backup step is mandatory.

## 3. Confirm The Replace / Preserve Scope

Write down, in plain terms:
- what must be replaced
- what must remain untouched
- what must be restored from backup
- what must be inserted newly

Useful labels:
- replace completely
- replace only before anchor
- replace only after anchor
- preserve manual edits
- restore legacy asset
- insert screenshot

## 4. Verify Body Anchors, Not TOC Anchors

Before deleting or inserting any DOCX block:
- confirm the anchor paragraph is in the body
- confirm it uses a body heading style
- reject TOC paragraphs even if the text matches visually

This is the mandatory check for anchors such as:
- `2.3 非功能需求`
- `2.4 业务流程分析`
- `3.3 数据库设计`

## 5. Replace Only The Requested Span

When the user asks for a partial rewrite:
- locate the start body heading
- locate the stop body heading that must stay
- delete only the paragraphs inside that body span
- insert the new content before the preserved stop anchor
- leave front matter, TOC, and out-of-scope manual edits untouched

If the user says "2.3 前面" or "2.4 之后", convert that into an exact body-range operation before touching the file.

## 6. Restore Legacy Assets Before Redrawing

Check whether the current manuscript lost any user-requested, project-grounded content:
- original E-R diagram
- original database table-description blocks
- original engineering figures
- valid old screenshots

If a supported old asset exists in the backup/original draft:
- restore it by block
- keep nearby caption and explanation coherent
- renumber only if necessary

Do not regenerate from memory when direct restoration is possible.

## 7. Recover The Database Chapter Carefully

If the database chapter was simplified too much:
- keep the accurate overview subsection
- restore each table's field-description block
- keep indexes and constraints in a later subsection
- verify table numbering after reinsertion

The restored block should stay grounded in actual schema, migration, or entity evidence.

## 8. Capture Real Runtime Screenshots

When the thesis needs "系统运行截图":
- run the real project if possible
- use real pages tied to the chapter narrative
- create only minimal demo data needed to show the workflow
- save screenshots in an explicit output folder

Recommended capture targets:
- login page
- resident appointment page
- resident health-code or dashboard page
- resident health-report page
- admin appointment management page
- admin review page
- admin dashboard

If the main database is risky or unavailable:
- use a screenshot-only runtime config
- prefer isolated H2 + Flyway startup
- avoid editing the main runtime config only for screenshots

## 9. Insert Screenshots With Thesis Semantics

For each inserted screenshot:
- add one short lead-in sentence
- place the screenshot near the subsection it proves
- add a thesis-style caption
- keep chapter ordering and figure numbering coherent

Do not dump screenshots into a random appendix if the thesis body is supposed to reference them directly.

## 10. Apply Formatting Guardrails Last

After content structure is stable, enforce formatting:
- all visible text black
- Chinese headings not bold unless the school sample explicitly requires it
- no hyperlink blue or underline styling
- field-description tables use the required smaller font
- captions follow the school sample
- TOC remains automatic

Do not spend time polishing page-level typography before the replacement and restore steps are finished.

## 11. Run The Final QA Pass

Before delivery, verify:
- the wrong file was not edited
- a fresh backup exists
- TOC anchors were not used as body anchors
- preserved manual edits still exist outside the requested span
- restored figures/tables appear in the intended sections
- screenshot numbering and table numbering are coherent
- no process notes or template hints remain
- the manuscript still matches the school sample

If page rendering cannot be verified in-tool, state that the user should refresh the TOC and do one local visual pass in Word.

## 12. Write The Rework Report Separately

Keep the rework report outside the thesis body.

The report should briefly record:
- which sections were replaced
- which legacy assets were restored
- which screenshots were added
- which hotspot pages were attacked in this round
- what still needs manual review in the next round
