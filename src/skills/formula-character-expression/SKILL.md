---
name: formula-character-expression
description: Decide and format formula characters, rendered formula explanations, LaTeX companion versions, Word/DOCX formula variable explanations, PPT/PowerPoint formula variable explanations, and same-folder README formula expression rules. Use when Codex needs to show formulas in dialogue, choose Word vs PPT LaTeX format, write formula explanations for reports or papers, or keep README formulas GitHub-renderable. Also use when Codex must distinguish unadorned single mathematical symbols from indexed or otherwise structured notation, render every symbol with a subscript or superscript through a mathematical typesetting engine, and prevent linear Unicode imitations such as E_(tr,total).
---

# Formula Character Expression

Read `references/formula-character-rules.md` before outputting, explaining, or writing formula characters.

## Workflow

1. Identify the target context: dialogue-only display, Word/DOCX-style document, PPT/PowerPoint-style document, or same-folder `README.md`.
2. For formulas shown in dialogue, output two consecutive versions: first the fully rendered version, then the LaTeX version.
3. Before writing the dialogue LaTeX version, infer whether the user needs Word-style or PPT-style LaTeX. If the target cannot be determined, use PPT-style LaTeX by default.
4. For Word, DOCX, reports, papers, principle explanations, and formula interpretation files, use Word-style LaTeX.
5. For PPT, PowerPoint, slides, defense presentations, courseware, and copied-to-PPT content, use PPT-style LaTeX.
6. For formulas in a same-folder `README.md`, follow the README formula rules in this skill and keep them consistent with `code-project-rules`.
7. Before formatting each mathematical item, distinguish an unadorned single symbol from structured notation. Use a Unicode mathematical character only when the item is one standalone symbol with no subscript, superscript, accent, relation, or operation.
8. Treat any item containing a subscript, superscript, accent, relation, operator, or multi-part mathematical structure as rendered mathematics, including symbols listed after `其中：` and indexed symbols embedded in prose.
9. Never imitate an index with `_`, `_(...)`, `^(...)`, ordinary parentheses, or an asterisk. Render indexed notation through the mathematical typesetting engine in the fully rendered version and preserve its standard LaTeX structure in the companion version.

## Boundary

This skill controls formula character representation and LaTeX companion formatting. Writing skills such as `lab-report-writer` may still handle the surrounding prose, experiment logic, paper explanation, and result analysis, but must defer formula character format decisions to this skill.

## Update Rule

When the user wants to refine formula character display, rendered-vs-LaTeX ordering, Word/PPT LaTeX selection, or README formula expression rules, update `references/formula-character-rules.md`.
