# Detection Report Rewrite Playbook

Use this reference when the user asks to lower plagiarism / similarity / AIGC risk and provides one or more detection reports.

## Purpose

This reference belongs to the strategist stage. Its job is to convert a report into a precise rewrite plan for the composer.

The strategist does not rewrite the paper here. It identifies where the score is coming from, which sections matter most, and what kind of rewrite is required.

## Inputs

- report files such as PDF / DOCX / screenshots / extracted text
- current thesis draft
- project evidence files

## Triage Workflow

### 1. Record The Report Headline

Capture the concrete values shown in the report:

- total similarity or plagiarism rate
- total AIGC rate
- weighted AIGC rate when present
- submission time
- report id when visible

### 2. Extract Hotspots

For each report, extract:

- high-risk pages
- marked paragraphs
- repeated sentence fragments
- sections that appear structurally templated

### 3. Map Hotspots Back To The Thesis

For every hotspot, map it to:

- chapter / section number
- paragraph purpose
- whether it is narrative text, front matter, caption, table, citation, or formulaic school text

### 4. Classify The Cause

Typical causes:

- generic academic prose
- polished but repetitive summary wording
- over-symmetric sentence structure
- repeated stock transitions
- source overlap with public literature

### 5. Decide Rewrite Intensity

Classify each hotspot into:

- heavy structural rewrite
- light rewrite
- leave unchanged

Prefer leaving these untouched unless they are explicitly flagged and materially harmful:

- cover pages
- declarations / authorization text
- English abstract unless actually needed
- references
- figure and table captions
- formulaic school-required front matter

## Prioritization Rules

- attack the smallest set of sections that dominates the score
- prioritize Chinese narrative paragraphs over low-yield formal sections
- prefer a few deep rewrites over many shallow edits
- do not ask the composer to rewrite broad stable sections unless the report actually points there

## What The Composer Needs From The Strategist

Produce a handoff that includes:

- hotspot page -> thesis section mapping
- suspected cause of the score
- rewrite intensity for each hotspot
- recommended rewrite mode:
  - sentence-order rework
  - paragraph recentering around project evidence
  - removal of generic bridge sentences
  - conversion from abstract summary language to implementation-grounded wording

## Guardrails

- reports are rewrite-priority signals, not sources of truth about the system
- never use a report to justify inventing project content
- never plan score reduction by deleting essential factual substance
- keep the project grounding rules above the report signal
