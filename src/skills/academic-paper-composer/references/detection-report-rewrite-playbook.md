# Detection Report Rewrite Playbook

Use this reference when the user asks to lower plagiarism / similarity / AIGC risk and provides one or more detection reports.

## Purpose

This reference belongs to the composer stage. Its job is to turn report hotspots into safe, evidence-preserving rewrites.

The score is not the source of truth. The repository remains the source of truth. Rewriting must lower risk without damaging factual accuracy.

## Inputs

- the strategist's hotspot mapping or a direct report triage
- the copied thesis draft
- project evidence files
- the latest detection report

## Rewrite Principles

- do not rely on synonym substitution as the main method
- prefer sentence-level restructuring: split, merge, invert, reorder
- change the paragraph's center of gravity from generic summary language to concrete project evidence
- break overly neat parallel structure when it sounds templated
- replace abstract bridge sentences with implementation-grounded observations when evidence exists
- keep chapter structure, numbering, figures, tables, citations, and technical facts stable unless they are unsupported
- preserve meaning first; score reduction is secondary to truth

## High-Yield Transformations

- generic academic claim -> code-grounded explanation
- smooth polished summary -> uneven natural engineering description
- "first / second / therefore" scaffolding -> direct description of what the project actually does
- broad conclusion sentence -> narrower observation tied to the repository
- repeated paired clauses -> one factual sentence plus one supporting sentence

## Low-Yield Or Risky Tactics

Avoid treating these as the main strategy:

- only swapping synonyms
- mechanically deleting technical detail
- rewriting citations or tables without need
- changing project facts just to reduce similarity
- overediting school-required formal sections

## Hotspot Execution Order

1. rewrite the highest-yield pages first
2. rebuild the copied manuscript
3. if the user brings back a newer report, repeat triage -> rewrite -> rebuild
4. in later rounds, touch only the remaining hotspot pages

## Paragraph Heuristics

When a paragraph still reads like a template:

- vary sentence length
- remove stock transitions
- reduce symmetrical phrasing
- anchor the wording in repository evidence
- prefer concrete module / config / service references over broad claims

When a paragraph is already low-risk:

- leave it alone

## Rework Report Expectations

For similarity / AIGC tasks, record:

- which pages were hotspots
- what rewrite strategy was used
- whether the round focused on heavy or light rewrites
- what should be rechecked in the next report

## Final Guardrails

- never promise an exact future score
- never invent facts to chase a number
- never delete required substance just to look different
- when in doubt, choose the more truthful version, then reduce template-like wording around it
