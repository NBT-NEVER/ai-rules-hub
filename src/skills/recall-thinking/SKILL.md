---
name: recall-thinking
description: Reuse durable local lessons, pitfalls, validation methods, and safe operating paths from prior tasks. Use when the current task may benefit from previously learned practices about Word/docx, LaTeX source, file writes, Chinese encoding, verification, debugging, or other high-value risky operations.
---

# Recall Thinking

Read `references/recall-rules.md` whenever the current task may reuse prior local experience, not only when the user asks for a retrospective summary.

## Workflow

1. Before acting on risky or error-prone tasks, scan the closest sections in `references/recall-rules.md`.
2. Pull forward matching pitfalls, safe paths, and verification methods into the current task plan before editing files.
3. Treat this skill as a reusable memory and preflight checklist for Word/docx edits, LaTeX source edits, Chinese write-back, PowerShell execution chains, high-value file updates, and similar scenarios.
4. If the user asks to write new lessons back into the local skill system, let `C:/Users/18030/.codex/skills/skill-maintainer` handle the update while using this skill as the memory target.
5. Keep this skill focused on “what to remember and reuse”, not on the mechanics of maintaining the skill system.

## Scope Rule

This skill is for consuming and reusing durable local experience during real tasks. It should be read proactively when past lessons may reduce risk, not only after mistakes happen.

## Update Rule

When the user wants to expand or refine the experience content itself, update `references/recall-rules.md`. When the user wants to change how recall entries are created, maintained, synchronized, installed, or deployed, update `skill-maintainer` instead.
