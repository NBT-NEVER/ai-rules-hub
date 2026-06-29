---
name: latex-coding-report-requirements
description: Generate, revise, and validate LaTeX code for experiment reports, course papers, undergraduate theses, academic papers, and similar formal writing under strict template constraints. Use when the user provides a LaTeX template, an existing `.tex` project, a fixed report framework, a rendered PDF sample, or asks to migrate report/paper work from Word-style templates to LaTeX templates while preserving the required structure.
---

# LaTeX Coding Report Requirements

## Workflow

1. Read `references/latex-coding-report-rules.md` before creating, filling, revising, or validating a LaTeX report or paper.
2. Read the user-provided template, existing `.tex` source, LaTeX project folder, rendered PDF sample, or structural sample before writing new code.
3. Extract the real formatting constraints from the material, including document class, package set, title area, heading levels, environment usage, bibliography style, figure and table layout, and fixed command definitions.
4. Work inside a copied template/project when files are being edited. Preserve the original template and avoid rebuilding the outer scaffold unless the user explicitly asks.
5. Generate or revise LaTeX code by following the extracted structure exactly, rather than replacing it with a generic personal structure.
6. Compile or at least perform a syntax-oriented validation when the local toolchain exists. Use the template's engine/build path if it is defined.
7. If the user asks for a reusable rule document rather than only a one-off `.tex` answer, rewrite the extracted constraints into a neutral, reusable rule set plus matching LaTeX code templates.
8. Remove only the parts that the user explicitly says are non-reusable. Do not silently discard other formatting constraints.
9. Preserve template-defined macros, ordering, and formatting conventions unless the user explicitly asks to change them.

## Priority Rule

Template fidelity is the first rule for this skill. When a user gives a template, sample file, or existing report framework, do not optimize it away into a cleaner but different structure.

## Self-Containment Rule

- Keep this skill self-contained.
- Do not mention local computer paths, collection paths, source package names, institution names, or provenance notes inside the maintained skill rules unless the user explicitly asks to retain them.
- When converting a specific template into a reusable long-term skill rule, rewrite it into generic wording suitable for repeated reuse.
- Avoid embedding “reference source” narration inside the maintained skill content.

## Output Rule

- Output should be directly usable LaTeX code, a clearly delimited LaTeX patch, a revised `.tex` project, a compiled PDF when possible, or a reusable rule document with matching LaTeX templates, depending on the request.
- When explaining changes, describe them in terms of template compliance, preserved structure, preserved macro path, minimal package changes, compilation status, or reusable formatting constraints.

## Update Rule

When the user wants to refine long-term LaTeX template-following behavior for reports or papers, update this file directly.
