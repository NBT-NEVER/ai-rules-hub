---
name: english-paper-vocabulary
description: Summarize vocabulary from annotated English academic paper PDFs into CSV or Excel tables. Use when the user provides a Zotero-annotated English paper PDF and asks to extract only gray underline single-word annotations, add Chinese meanings, phonetics, original paper example sentences, and page numbers, then save the vocabulary summary to a specified location.
---

# English Paper Vocabulary

Use this skill only for English-paper vocabulary extraction and summary tasks. The input is usually a Zotero-annotated PDF; the output is a CSV or Excel vocabulary table named after the paper title.

## Required Reference

Before doing the task, read `references/vocabulary-rules.md` completely. It contains the annotation filter, output schema, formatting rules, and the user's original requirements that must be preserved.

## Workflow

1. Confirm the source PDF path and the required output directory.
2. Extract the paper title from PDF metadata or the first page; use it to name the output file.
3. Read PDF annotations and keep only gray underline annotations whose PDF subtype is `/Underline` and whose color is `[0.66666667, 0.66666667, 0.66666667]`.
4. From those annotations, keep only single English words. Exclude terminology phrases, multi-word expressions, full sentences, punctuation-only selections, equations, abbreviations that are not words, and duplicated entries unless the user requests otherwise.
5. For each retained word, collect the word, Chinese meaning with part of speech, standard phonetic transcription, original sentence from the paper, and page number.
6. Write the result to the requested output location as a CSV by default, or as an Excel workbook when the user asks for visual formatting.

## Quality Rules

- Do not invent marked words, meanings, phonetics, example sentences, or page numbers.
- If an annotation cannot be mapped to a clean single word or original sentence, report the uncertainty instead of silently guessing.
- Preserve Chinese text as UTF-8 and use normal Unicode characters.
- Keep the task scoped to vocabulary summary. Do not perform broad literature review, full translation, or paper summarization unless the user separately asks.
