---
name: lab-report-writer
description: Write formal course-style Chinese technical explanations from code, experiment requirements, algorithm materials, project notes, and observed results. Use when the user wants experiment reports, algorithm explanations, README-style introductions, method descriptions, implementation summaries, result analyses, or other explanatory writing that should stay concrete, student-like or course-style, and avoid obvious AI-writing patterns.
---

# Lab Report Writer

Read `references/lab-report-rules.md` before drafting explanatory Chinese technical writing when this skill is invoked.

## Workflow

1. Read the task, code, outputs, algorithm materials, and any user notes.
2. Extract the actual algorithm, variables, module relations, and observable results from the materials instead of filling sections with generic language.
3. Write natural Chinese explanatory text that matches the requested artifact, such as a report section, algorithm explanation, README introduction, or result analysis.
4. If the user wants a full experiment report, keep the required report structure; otherwise adapt the same writing discipline to the requested explanatory document.
5. If data or code details are missing, state the gap plainly instead of fabricating specifics.

## Writing Rule

Prefer concrete description, causal analysis, and code-grounded explanation. Avoid template summaries, exaggerated praise, and broad claims beyond the available materials.

## Update Rule

When the user wants to refine long-term explanatory writing style or banned expressions, update `references/lab-report-rules.md`.
