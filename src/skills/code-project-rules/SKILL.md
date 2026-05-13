---
name: code-project-rules
description: Follow the user's coding structure, Python project layout, path management rules, Chinese comment standards, README and requirements conventions, and versioned output conventions. Use when creating, modifying, organizing, documenting, or reviewing code projects under the user's personal engineering rules, especially when the task involves project documentation, module explanations, or README content tied to the codebase.
---

# Code Project Rules

Read `references/coding-rules.md` before changing project files when this skill is invoked.

## Workflow

1. Treat `references/coding-rules.md` as the working rule set for coding tasks.
2. Apply the rules relevant to the current task. Do not force machine learning modules into projects that do not need them.
3. Keep the project minimal but complete. Add only the files needed for a runnable and maintainable result.
4. Centralize path and output naming in `config.py` whenever the project uses Python entry scripts.
5. Keep code, README, requirements, and generated output descriptions consistent with each other.
6. When the task includes explanatory project writing, such as README sections or module introductions, apply these project rules together with the relevant writing-style skill.

## Priority Rule

If the current conversation gives a direct instruction that conflicts with the stored rules, follow the current conversation. If the repository already has a clear local style, preserve that style unless the user asked to refactor it.

## Editing Rule

When the user asks to update long-term coding constraints, edit `references/coding-rules.md` so the rule set stays in one place.
