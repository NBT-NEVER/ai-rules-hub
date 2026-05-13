---
name: chinese-encoding-guard
description: Prevent garbled Chinese text and keep temporary read/write artifacts orderly when handling Chinese materials in code comments, generated documents, copied report text, README sections, algorithm explanations, and content read from Word, PDF, PPT, TXT, or similar files. Use whenever Chinese content is written, copied, extracted, converted, or prepared for Word and similar editors.
---

# Chinese Encoding Guard

Read `references/encoding-rules.md` before reading or writing Chinese text when this skill is invoked.

## Workflow

1. Treat `references/encoding-rules.md` as the default rule set for any task that reads or outputs Chinese text.
2. Apply the rules to code comments, Python source files, Markdown, plain text, experiment reports, Word-oriented text, and intermediate files produced while reading Chinese materials from formats such as PDF, Word, PPT, or TXT.
3. Prefer prevention over repair. Use a safe encoding, a stable text path, and a dedicated temporary workspace from the start.
4. If existing files already show suspicious mojibake, stop and report the risk instead of guessing a reverse conversion.

## Scope Rule

This skill is global in nature, but it should still be applied only when the task involves Chinese text output, editing, extraction, conversion, or temporary file handling around those steps.

## Update Rule

When the user wants to refine encoding policy, anti-mojibake rules, or temporary workspace rules for Chinese file handling, update `references/encoding-rules.md`.
