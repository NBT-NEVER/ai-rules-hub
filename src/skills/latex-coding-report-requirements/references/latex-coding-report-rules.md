# LaTeX Coding Report Rules

This file stores the long-term rules for writing LaTeX code for experiment reports, course reports, academic papers, and similar formal writing tasks that must obey an existing template.

## Core Rule

- When the user provides a template, existing `.tex` file, rendered sample, or explicit section framework, generate LaTeX code strictly according to that structure.
- Template conformance takes priority over personal optimization, generic best practice, or stylistic simplification.

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

## Formatting Rule

- Follow the template's spacing, indentation, title style, caption style, citation style, bibliography style, and numbering conventions.
- Do not silently change full-width and half-width punctuation strategy if the template already implies one.
- Do not convert a Chinese report template into an English paper style, or vice versa, unless the user explicitly requests that transformation.

## Content Injection Rule

- When filling content into a template, place new content into the template's existing slots.
- Do not redesign the outer LaTeX scaffold if the task is only to fill text, formulas, tables, figures, or references.
- If the user asks only for one section, modify only that relevant section and keep the rest of the template stable.

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

- Output should be directly usable LaTeX code or a clearly delimited LaTeX patch.
- When explaining changes, describe them in terms of template compliance, preserved class, preserved environment layout, preserved citation path, or minimal package additions.
