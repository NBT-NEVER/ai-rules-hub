---
name: lab-report-writer
description: Write formal course-style Chinese technical explanations from code, experiment requirements, algorithm materials, project notes, papers, and observed results. Use when the user wants experiment reports, algorithm explanations, paper interpretation, method descriptions, implementation summaries, result analyses, or other explanatory writing that should stay concrete, student-like or course-style, and avoid obvious AI-writing patterns. For a paper request that also needs evidence checking, author-intent reconstruction, counterexamples, or follow-up research, use paper-reading-zh first, then use this skill to turn its reading judgment into prose. When formula character display, rendered-vs-LaTeX ordering, Word/PPT LaTeX formatting, or README formula expression is needed, also use formula-character-expression.
---

# Lab Report Writer

Read `references/lab-report-rules.md` before drafting explanatory Chinese technical writing when this skill is invoked.

## Workflow

1. Read the task, code, outputs, algorithm materials, and any user notes.
2. If the source is a research paper and the user asks for more than a surface explanation, first use `paper-reading-zh` to establish the claim, evidence, assumptions, and uncertainty; treat its reading judgment as input rather than re-deriving an unsupported summary.
3. Extract the actual algorithm, variables, module relations, and observable results from the materials instead of filling sections with generic language.
4. Write natural Chinese explanatory text that matches the requested artifact, such as a report section, algorithm explanation, README introduction, or result analysis.
5. If the user wants a full experiment report, keep the required report structure; otherwise adapt the same writing discipline to the requested explanatory document.
6. If data or code details are missing, state the gap plainly instead of fabricating specifics.
7. If formulas are involved, use this skill for the surrounding technical explanation and use `formula-character-expression` for formula characters, rendered-vs-LaTeX ordering, Word/PPT LaTeX format selection, and README formula expression.

## Writing Rule

Prefer concrete description, causal analysis, and code-grounded explanation. Avoid template summaries, exaggerated praise, and broad claims beyond the available materials.

## Update Rule

When the user wants to refine long-term explanatory writing style or banned expressions, update `references/lab-report-rules.md`.
