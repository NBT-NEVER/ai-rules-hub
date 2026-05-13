# DOCX Draft Salvage And Runtime Screenshot Playbook

Load this reference when the user is **not** asking for a simple blank-slate finalization, but instead wants one or more of the following:
- continue editing a hand-modified draft
- replace only a slice of the manuscript such as "2.3 前面" or "从 2.4 开始"
- keep or restore original figures, E-R diagrams, or database table-description blocks
- add real system-running screenshots into the thesis

## 1. Pick The True Working File

Before editing, determine which file is the live manuscript now:
- original source draft
- copied final draft
- user hand-edited initial draft
- a newer partially revised draft

If the user says "我手改的是初稿" or equivalent, that file becomes the working manuscript.
Do not silently switch back to an older copied final DOCX.

## 2. Always Create A Fresh Safety Backup

Before any structural edit:
- create a timestamped backup of the working DOCX
- keep older backups if they already exist
- never delete or overwrite the user's original source draft

Useful naming pattern:
- `name.docx.bak.YYYYMMDD-task`

## 3. Anchor Detection Must Be Style-Aware

When locating chapter boundaries in DOCX:
- use body headings with styles such as `Heading 1`, `Heading 2`, `Heading 3`
- never use TOC paragraphs like `toc 1`, `toc 2`, `toc 3` as anchors
- verify the exact heading text and style before deleting or inserting blocks

This rule is critical for cases like:
- `2.3 非功能需求`
- `2.4 业务流程分析`
- `3.3 数据库设计`

A TOC line that visually looks identical is **not** a safe editing anchor.

## 4. Partial Replacement Mode

When the user wants only part of the manuscript replaced:
- identify the first body heading to replace from
- identify the stop heading that must remain untouched
- delete only the block range inside that body span
- insert new content before the preserved stop anchor
- keep front matter, TOC, and out-of-scope manual edits unchanged

Typical examples:
- replace body `1 引言` through just before body `2.3 非功能需求`
- replace from body `2.4` onward while preserving earlier manual edits

## 5. Preserve Supported Legacy Assets

If the user wants to keep an original figure or old structured section and it is still project-grounded, prefer salvage over regeneration.

High-value legacy assets often include:
- original E-R diagram subsection
- original database field-description tables for each table
- original chapter-specific engineering figures
- valid screenshots from an earlier but correct draft

Restore them from the backup/original draft by block, not by retyping from memory.
Keep captions, nearby explanatory text, and local numbering coherent.

## 6. Database Chapter Recovery Pattern

When the current manuscript compressed the database chapter too aggressively but the original draft had proper field-description tables:
- keep the current high-level `3.3.1` overview if it is already accurate
- restore the original per-table description block into `3.3.2`
- keep `3.3.3` for indexes and constraints
- verify table numbering after reinsertion

Typical restored sequence:
- `users`
- `user_roles`
- `vaccines`
- `vaccination_sites`
- `site_vaccine_inventory`
- `vaccination_appointments`
- `vaccination_records`
- `testing_sites`
- `nucleic_acid_tests`
- `health_reports`
- `notifications`
- `health_code_scan_log`

## 7. Runtime Screenshot Capture Pattern

When the thesis needs "系统运行截图":
- capture real pages from the running project
- prefer screenshots that prove actual business closure, not empty shells
- store assets under `output/playwright/` or another explicit output folder

Recommended screenshot set:
- login page
- resident appointment page
- resident health-code / dashboard page
- resident health-report page
- admin appointment management page
- admin health-report review page
- admin dashboard

### Data preparation

If the page is empty, create minimal demo data first:
- one reservation
- one health report
- one admin-reviewable record

Do not bulk-fabricate large datasets just to make screenshots look busy.

### Safe runtime setup

If the real MySQL environment is unavailable or risky:
- create a temporary screenshot config
- prefer H2 + Flyway for isolated startup
- do not rewrite the main runtime config only to take screenshots
- shut down the temporary service after capture

## 8. Screenshot Insertion Rules

For each screenshot inserted into the thesis:
- add one short lead-in sentence
- insert the image centered
- add a normal thesis caption below it
- place it immediately before or after the paragraph/table it supports
- renumber later figures if earlier screenshots are inserted into the chapter

Keep screenshot placement semantically correct:
- authentication screenshot in authentication section
- resident appointment screenshot in appointment section
- backend review screenshot in review or management section

## 9. Formatting Guardrails

Unless the school sample says otherwise:
- all visible text should be black
- Chinese headings should not be bold
- table field-description text should use the smaller thesis-required size
- remove hyperlink coloring and underlines
- keep captions in the school's caption style

## 10. Final Verification

Before delivery, verify:
- TOC/body anchors were not confused
- preserved manual edits outside the requested span still exist
- restored legacy figures/tables are in the expected section
- figure numbers are sequential after new screenshot insertion
- table numbers remain coherent after database-section restoration
- Word TOC needs refresh if the user opens the document locally
- if visual rendering is unavailable, explicitly state that final page-level layout still needs local review
