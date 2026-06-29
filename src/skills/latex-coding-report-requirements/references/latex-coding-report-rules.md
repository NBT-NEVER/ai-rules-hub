# LaTeX Coding Report Rules

This file stores the long-term rules for writing LaTeX code for experiment reports, course reports, academic papers, and similar formal writing tasks that must obey an existing template.

## Word And LaTeX Boundary

- Use this skill for `.tex`, `.bib`, `.cls`, `.sty`, LaTeX project folders, LaTeX templates, and PDF output produced from LaTeX.
- Do not apply Word/DOCX editing workflows to LaTeX tasks. DOCX anchor checks, Word TOC refreshes, `python-docx`, and Word visual style repair belong only to DOCX delivery.
- If the user asks for a Word deliverable, use the Word/DOCX-oriented workflow in the relevant document skill.
- If the user asks for a LaTeX deliverable or supplies a LaTeX template, treat the template source and compiled PDF as the final authority pair: source controls structure, PDF verifies rendering.

## Core Rule

- When the user provides a template, existing `.tex` file, rendered sample, or explicit section framework, generate LaTeX code strictly according to that structure.
- Template conformance takes priority over personal optimization, generic best practice, or stylistic simplification.

## Best Workflow For LaTeX Template Reports

1. Identify the target artifact first: single `.tex`, multi-file LaTeX project, `.bib`-backed paper, or template plus PDF sample.
2. Create a working copy before editing supplied templates or user drafts. Keep the original template unchanged.
3. Locate the main entry file by checking `\documentclass`, `\begin{document}`, `\input`, `\include`, `latexmkrc`, `Makefile`, `main.tex`, or template documentation.
4. Record the build engine if visible: `xelatex`, `lualatex`, `pdflatex`, `latexmk`, BibTeX, or Biber. For Chinese reports, prefer the template's existing `ctex`/XeLaTeX/LuaLaTeX path when present.
5. Extract the template contract before writing content: class, packages, macros, title block, abstract/keywords format, heading depth, figure/table/caption rules, bibliography path, appendix pattern, and any custom environments.
6. Fill content into existing slots. Avoid changing `\documentclass`, package order, page geometry, heading macros, counters, citation style, or bibliography backend unless a concrete compile or formatting problem requires it.
7. Keep figures, tables, formulas, citations, labels, and cross-references in template-native environments.
8. Compile early after structural changes and again before delivery when the toolchain exists.
9. Fix errors in the smallest possible scope. Start from the first LaTeX error, then address missing assets, undefined references, bibliography failures, overfull boxes, and warnings that affect the final PDF.
10. Deliver the `.tex` source changes and, when compilation is available, the compiled PDF plus a short note of engine, command, and remaining warnings.

## Template-First Rule

- Read the given template before writing any new LaTeX code.
- Identify and reuse the original document class, package imports, command definitions, environment usage, title structure, section hierarchy, bibliography mechanism, and layout style.
- Do not replace the template with a self-made universal template just because it looks cleaner.

## Structure Preservation Rule

- Keep the original section order when the template already defines it.
- Keep the original heading depth, such as `\section`, `\subsection`, and `\subsubsection`, unless the user explicitly asks to restructure.
- Keep template-defined wrappers such as abstract blocks, appendices, theorem environments, figure environments, table environments, or other fixed structural shells.

## Macro Preservation Rule

- Preserve existing custom commands, custom environments, counters, labels, and formatting macros.
- Do not rename template macros casually.
- If a macro is clearly broken, explain the issue and repair it in-place instead of replacing the whole template style.

## Package Rule

- Prefer the package set already used by the template.
- Do not add new packages unless they are necessary for the requested content or to repair a concrete compilation problem.
- If a new package is required, keep the addition minimal and avoid conflicting with the template's current package stack.
- Do not switch bibliography tooling between BibTeX and Biber unless the template or user explicitly requires it.

## Formatting Rule

- Follow the template's spacing, indentation, title style, caption style, citation style, bibliography style, and numbering conventions.
- Do not silently change full-width and half-width punctuation strategy if the template already implies one.
- Do not convert a Chinese report template into an English paper style, or vice versa, unless the user explicitly requests that transformation.

## Content Injection Rule

- When filling content into a template, place new content into the template's existing slots.
- Do not redesign the outer LaTeX scaffold if the task is only to fill text, formulas, tables, figures, or references.
- If the user asks only for one section, modify only that relevant section and keep the rest of the template stable.
- Preserve existing `\label`, `\ref`, `\cite`, `\bibliography`, `\printbibliography`, `\input`, and `\include` patterns unless the requested change directly targets them.
- For bilingual abstracts and keywords, define abbreviations on first use within the corresponding language section, and keep the full name, abbreviation, capitalization, and hyphenation consistent across the abstract, main body, captions, and notes. In Chinese text, use `中文全称（英文全称，英文缩写）` on first use; in English text, use `English full name (ABBR)`.

## Chinese LaTeX Rule

- Save `.tex`, `.bib`, `.cls`, `.sty`, and included text files as UTF-8 unless a legacy template explicitly requires another encoding.
- For Chinese templates, preserve existing `ctex`, `xeCJK`, fontset, punctuation, and engine choices.
- Prefer XeLaTeX or LuaLaTeX for Chinese reports when the template already uses CJK/ctex tooling. Do not force pdfLaTeX on a Chinese template that was designed for XeLaTeX.
- Do not paste Chinese through a shell path that may replace characters with `?`. Write source files through a known UTF-8 path and verify bytes or rendered PDF when risk is high.

## Figures Tables And Assets

- Keep assets in the project structure expected by the template, such as `figures/`, `images/`, or `assets/`.
- Use stable relative paths rather than absolute local paths.
- Preserve figure and table caption commands, numbering conventions, and placement style.
- When adding images, verify that referenced files exist and the case-sensitive path is correct.
- For tables, prefer the template's existing table environment and column style before adding packages such as `booktabs`, `longtable`, or `tabularx`.

## Bibliography Rule

- Preserve the template's citation mechanism.
- If the template uses `.bib`, add entries to the existing `.bib` file or a copied working `.bib` file rather than hard-coding references into the body.
- Keep citation keys stable and readable. Do not rename existing keys unless necessary.
- If the user supplies references in plain text, convert only the confirmed bibliographic fields and mark missing fields plainly instead of fabricating them.

## Validation Rule

- Prefer the template's documented build command.
- If no build command is documented, try the least invasive standard path that matches the source:
  - `latexmk -xelatex main.tex` for Chinese XeLaTeX templates.
  - `latexmk -lualatex main.tex` when the template clearly uses LuaLaTeX.
  - `latexmk -pdf main.tex` or `pdflatex` only when the template appears pdfLaTeX-compatible.
- For bibliography, run the required BibTeX or Biber step only when the template calls for it.
- Treat a compiled PDF as the strongest validation, but also inspect warnings that affect visible output, missing citations, missing references, or absent figures.
- If a compiler is unavailable, state that compilation was not run and still perform source-level checks for unmatched braces, missing `\begin`/`\end`, missing assets, and obvious citation path problems.

## Reusable Rule Extraction

- If the user asks to extract a reusable rule document from a concrete template, preserve the original formatting constraints instead of rewriting them into loose generic advice.
- Keep the extracted document focused on durable LaTeX constraints such as document structure, heading levels, page layout, font rules, figure rules, table rules, formula rules, citation rules, appendix rules, and other stable formatting requirements.
- Remove only the parts that the user explicitly marks as non-reusable.
- Pair prose rules with matching LaTeX code templates when the result is intended for long-term reuse.
- Keep the maintained rule text neutral. Do not retain local machine paths, institution labels, or source-package naming unless explicitly requested.

## Scope Rule

- This skill is for LaTeX coding constraints, not for general prose polishing.
- If the task also requires Chinese technical writing quality, report-body explanation, or formula narration, combine this skill with the relevant writing skill rather than overloading this one.

## Output Rule

- Output should be directly usable LaTeX code, a clearly delimited LaTeX patch, a revised source project, or a compiled PDF when local compilation is available.
- When explaining changes, describe them in terms of template compliance, preserved class, preserved environment layout, preserved citation path, minimal package additions, and compilation status.
