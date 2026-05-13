---
name: academic-anti-ai-writing
description: Reduce obvious AI-writing patterns in Chinese academic, technical, and engineering prose. Use when Codex drafts, rewrites, polishes, reviews, or explains academic reports, papers, thesis sections, technical descriptions, method sections, literature summaries, engineering lab reports, experiment analyses, README-style academic explanations, conclusions, abstracts, or any similar formal Chinese writing that should sound concrete, evidence-based, human, and less template-generated.
---

# Academic Anti-AI Writing

Use this skill when the user asks for Chinese academic or engineering writing and the output should avoid obvious AI-generated wording.

## Workflow

1. Read `references/anti-ai-writing-rules.md` before drafting or revising the target text.
2. Identify whether the text is a report, paper section, technical explanation, experiment analysis, abstract, conclusion, or README-style academic explanation.
3. Prefer concrete objects, data conditions, methods, variables, units, experimental settings, and limitations over broad background claims or empty praise.
4. Remove template phrases, exaggerated claims, uniform paragraph endings, and unsupported “significance” statements.
5. When information is missing, state the missing condition or write a bounded sentence instead of fabricating details.

## Priority

When this skill overlaps with `lab-report-writer`, use both styles of discipline: keep the report structure from `lab-report-writer`, and apply this skill to lower AI-like wording at the sentence, paragraph, and evidence level.

## Output Rule

Produce text that can be used directly in academic or engineering documents. Do not mention that the text was “de-AI-ed” unless the user asks for an explanation of the revision.
