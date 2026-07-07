---
name: english-paper-vocabulary
description: Summarize English words and phrases from Zotero-annotated English academic paper PDFs into CSV vocabulary tables. Use when the user provides an annotated paper PDF and asks to extract only gray underline annotations whose PDF subtype is /Underline and color is [0.66666667, 0.66666667, 0.66666667], including marked words, terminology phrases, and sentence annotations, then add Chinese meanings, phonetics where applicable, original paper examples, page numbers, marked-counts, and save a paper-title-named .csv to the specified location.
---

# English Paper Vocabulary

Use this skill only for English-paper vocabulary and phrase extraction tasks. The input is a Zotero-annotated PDF; the output is a CSV vocabulary table named after the paper title.

## Required Reference

Before doing the task, read `references/vocabulary-rules.md` completely. It contains the annotation filter, output schema, CSV rules, and the user's original requirements that must be preserved.

## Workflow

1. Confirm the source PDF path and the required output directory.
2. Extract the paper title from PDF metadata or the first page; use it to name the output file.
3. Read PDF annotations and keep only gray underline annotations whose PDF subtype is `/Underline` and whose color is `[0.66666667, 0.66666667, 0.66666667]`.
4. Keep only the exact marked characters, words, phrases, or sentences. If a suffix, `ed`, or trailing phrase segment is not marked, discard that unmarked part.
5. Normalize single-word entries to the base form in the first column: remove tense/passive/progressive/plural endings such as `ed`, `ing`, and `s`, remove negative prefixes such as `no`/`non`, repair PDF-clipped fragments, and do not carry prefix/suffix meanings into the Chinese definition.
6. For each retained item, collect the item, Chinese meaning, phonetic transcription for single words, a paper-original example fragment of at most 15 words, page number, and marked-count when greater than 1.
7. Write only a CSV to the requested output location.

## Quality Rules

- Do not invent marked content, meanings, phonetics, example sentences, page numbers, or counts.
- Do not exclude marked terminology phrases or sentence annotations merely because they are not single words.
- Do not add word class or phonetics for terminology phrases or sentence annotations, but translate them.
- For single-word entries, keep full Chinese word-class information and multiple common meanings after normalization; do not translate removed prefixes or suffixes.
- Keep example fragments from the paper, separated by spaces, and no longer than 15 words. They need not be complete sentences, but must preserve enough context to understand the vocabulary item.
- Preserve Chinese text as UTF-8 and use normal Unicode characters.
- Keep the task scoped to vocabulary and phrase summary. Do not perform broad literature review, full translation, or paper summarization unless the user separately asks.
