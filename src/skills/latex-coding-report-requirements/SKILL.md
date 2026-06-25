---
name: latex-coding-report-requirements
description: Generate and revise LaTeX code for experiment reports, course papers, academic papers, and similar formal writing under strict template constraints. Use when the user provides a LaTeX template, an existing `.tex` file, a fixed report framework, or a formatting sample and requires the output to follow that structure exactly instead of freely restructuring the document.
---

# LaTeX Coding Report Requirements

## Workflow

1. Read the user-provided template, existing `.tex` source, or structural sample first.
2. Extract the real formatting constraints from the material, including document class, package set, title area, heading levels, environment usage, bibliography style, figure and table layout, and any fixed command definitions.
3. Generate or revise LaTeX code by following the extracted structure exactly, rather than replacing it with a generic personal structure.
4. If the user asks for a reusable rule document rather than only a one-off `.tex` answer, rewrite the extracted constraints into a neutral, reusable rule set plus matching LaTeX code templates.
5. Remove only the parts that the user explicitly says are non-reusable. Do not silently discard other formatting constraints.
6. Preserve template-defined macros, ordering, and formatting conventions unless the user explicitly asks to change them.

## Priority Rule

Template fidelity is the first rule for this skill. When a user gives a template, sample file, or existing report framework, do not optimize it away into a cleaner but different structure.

## Self-Containment Rule

- Keep this skill self-contained.
- Do not mention local computer paths, collection paths, source package names, institution names, or provenance notes inside the maintained skill rules unless the user explicitly asks to retain them.
- When converting a specific template into a reusable long-term skill rule, rewrite it into generic wording suitable for repeated reuse.
- Avoid embedding “reference source” narration inside the maintained skill content.

## Output Rule

- Output should be directly usable LaTeX code, a clearly delimited LaTeX patch, or a reusable rule document with matching LaTeX templates, depending on the request.
- When explaining changes, describe them in terms of template compliance, preserved structure, preserved macro path, or reusable formatting constraints.

## Update Rule

When the user wants to refine long-term LaTeX template-following behavior for reports or papers, update this file directly.
