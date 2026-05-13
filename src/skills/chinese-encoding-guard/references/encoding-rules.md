# Chinese Encoding Rules

This file defines long-term rules to keep Chinese text readable and stable across code, generated reports, plain text files, Markdown files, and content that may later be pasted into Word.

## Core Goal

- Do not produce garbled Chinese text.
- Prefer prevention over repair.
- Use a consistent encoding strategy across generation, editing, and saving.

## Default Encoding Policy

- Default text encoding: UTF-8
- Default file save mode for source text: UTF-8 without BOM
- Do not silently fall back to GBK, ANSI, or system-default encodings unless the user explicitly requires compatibility with a legacy environment
- When a program reads or writes Chinese text, explicitly specify encoding whenever the language or tool allows it

## Python File Rules

- Python source files containing Chinese comments or docstrings should be saved as UTF-8 without BOM
- When appropriate, include the file header `# _*_coding:UTF-8_*_`
- When opening Chinese text files in Python, prefer explicit forms such as `open(path, "r", encoding="utf-8")`
- When writing Chinese text files in Python, prefer explicit forms such as `open(path, "w", encoding="utf-8", newline="")`
- Do not change business logic just to add encoding comments unless the user requested code edits

## Markdown And Plain Text Rules

- Save `.md` and `.txt` files as UTF-8
- Keep Chinese punctuation and full Chinese characters as normal Unicode text
- Do not output escaped pseudo-Chinese or broken replacement characters
- Do not mix multiple encodings within the same file

## Word-Oriented Text Rules

- When generating Chinese content intended for Word, output normal Unicode Chinese text directly
- Prefer plain text or Markdown that can be copied into Word without transcoding
- Do not insert unnecessary control characters, invisible junk symbols, or malformed punctuation
- If the user asks for `.docx` generation in the future, keep the textual content itself in normal Unicode and ensure any generation path preserves UTF-8 or native Unicode handling

## Temporary Workspace Rules For File Reading

- When reading `.pdf`, `.doc`, `.docx`, `.ppt`, `.pptx`, `.txt`, or similar files and temporary extraction or conversion artifacts are needed, place them under `C:/Users/18030/Desktop/GPT-files`
- Do not place such temporary files inside the current project folder, repository folder, or the original data folder that contains the source files
- Create clear category folders under `C:/Users/18030/Desktop/GPT-files`, for example `pdf`, `word`, `ppt`, `txt`, `images`, `converted`, or `extracted`, and keep each task inside the matching category path
- Keep the temporary workspace orderly; do not mix unrelated tasks into one flat folder or scatter one task across many arbitrary directories
- After the file has been read successfully and the temporary artifacts are no longer needed, delete them promptly
- After the whole project is complete, clean up leftover temporary folders created for that project
- If the user explicitly asks to retain intermediate artifacts, keep them in the same `C:/Users/18030/Desktop/GPT-files` hierarchy with clear naming instead of leaving them in project or data directories

## Existing Mojibake Handling

- If existing Chinese text already appears garbled, do not guess the original text
- Stop and tell the user that the file may have an encoding problem
- Only attempt repair when the user explicitly asks for repair and provides the source file or confirms the intended encoding path

## Output Quality Rules

- Chinese code comments should be concise, natural, and readable
- Generated report text should use normal Simplified Chinese, not machine-transcoded fragments
- Avoid copying visibly corrupted text back into new files

## Compatibility Rule

- Only choose GBK or other legacy encodings when the user explicitly says the downstream tool requires it
- If such a legacy requirement exists, state the exact encoding in the output or code clearly
- Without that explicit requirement, stay on UTF-8

## Encoding Consistency Principle

- Treat file encoding, program read/write encoding, and display encoding as one complete path
- Do not assume terminal mojibake means the file itself is broken; first distinguish file corruption from display-layer decoding problems
- When converting a legacy Chinese file to UTF-8, identify the original encoding first and perform one explicit conversion instead of repeated open-save cycles across different tools

## Editor And Terminal Rules

- In editors such as VS Code, keep the default text encoding on UTF-8 for Markdown, plain text, and source files
- Before saving a reopened legacy Chinese file, confirm whether the editor decoded it as GBK, ANSI, or UTF-8 instead of trusting auto-detection blindly
- On Windows terminals or shells, make sure the display path supports UTF-8 before judging Chinese text as corrupted
- If a downstream tool explicitly requires UTF-8 with BOM, record that exception clearly instead of mixing BOM and non-BOM files arbitrarily

## Copy And Paste Rules

- Do not copy Chinese text from unknown legacy files, old terminals, or editors with unclear encoding directly into new UTF-8 files
- After pasting Chinese content from Word or other rich-text tools, quickly inspect punctuation, full-width characters, and replacement characters before saving
- If visibly corrupted Chinese text is already present in the source, preserve the original source and ask for an authoritative version instead of propagating the corrupted text
