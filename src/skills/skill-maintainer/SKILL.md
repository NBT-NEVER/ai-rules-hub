---
name: skill-maintainer
description: Create, modify, rename, restructure, install, synchronize, or deploy custom skills and their shared rule repository across Codex and Cursor. Use when maintaining skill folders, skill metadata, skill references, AGENTS routing, GitHub-backed rule sources, local installation scripts, project-level Cursor rules, reflecting or summarizing lessons back into skills, adding new skills, deciding the correct source landing for a skill, or when listing skills with detailed introductions before changing the skill system. When creating or materially modifying a skill, also read the system skill-creator guidance.
---

# Skill Maintainer

Read `references/skill-maintainer-rules.md` first when this skill is invoked.

## Workflow

1. Treat `references/skill-maintainer-rules.md` as the authoritative rule source for skill maintenance.
2. If the task adds a new skill or materially modifies an existing skill, also read `C:/Users/18030/.codex/skills/.system/skill-creator/SKILL.md` before editing. If you touch `agents/openai.yaml`, also read `C:/Users/18030/.codex/skills/.system/skill-creator/references/openai_yaml.md`.
3. Before editing, decide which layer the request belongs to: `src/AGENTS.md`, a skill's `SKILL.md`, `agents/openai.yaml`, `references/*-rules.md`, repository scripts, generated `dist/` artifacts, or a brand-new skill directory.
4. If the request is a new long-term category, create a complete skill directory under `src/skills` instead of a loose file. Do not create new managed skills directly under `dist/`, `C:/Users/18030/.codex`, or any Cursor project.
5. If the user asks to “总结经验到skill” or to write new long-term lessons, follow this skill's experience-update workflow and write the durable content into `src/skills/recall-thinking/references/recall-rules.md`.
6. Keep responsibilities separated: entry logic in `SKILL.md`, UI metadata in `agents/openai.yaml`, long-term detailed rules in `references/*-rules.md`, reusable experience content in `recall-thinking`, and install or deploy mechanics in repository scripts.
7. When modifying any skill, list the current managed skill set and provide a detailed introduction to the relevant skill responsibilities in the response.
8. Treat `src/` as the single source of truth. Treat `dist/` and installed copies under `C:/Users/18030/.codex` or Cursor projects as generated artifacts.
9. After any source change related to skill maintenance, reflection, summarization, or adding a new skill, run the default source deployment script so `src` is rebuilt and synced into Codex and the default Cursor project.
10. Any change to a skill's structure, responsibility, synchronization flow, or deployment path must be synchronized back into `references/skill-maintainer-rules.md` and `src/AGENTS.md` when routing changes.

## Scope Rule

This skill is for maintaining the shared custom skill system itself, including GitHub-backed source rules, Codex installation targets, Cursor project-level rule deployment, and the workflow for writing new experience back into `recall-thinking`. Do not use it for ordinary project coding or report writing tasks.

## Update Rule

When the user wants to refine how local skills are created, maintained, synchronized, installed, deployed, auto-synced from `src`, or how new recall experience should be written back, update `references/skill-maintainer-rules.md`.
