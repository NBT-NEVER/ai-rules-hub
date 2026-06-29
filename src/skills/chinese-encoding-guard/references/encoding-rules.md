# Chinese Encoding Rules

This file defines long-term rules to keep Chinese text readable and stable across code, generated reports, plain text files, Markdown files, LaTeX source files, and content that may later be pasted into Word.

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

## Word And LaTeX Text Rules

- When generating Chinese content intended for Word or LaTeX source, output normal Unicode Chinese text directly
- Prefer plain text, Markdown, or `.tex` source that can be copied or written without transcoding
- Do not insert unnecessary control characters, invisible junk symbols, or malformed punctuation
- If the user asks for `.docx` generation, keep the textual content itself in normal Unicode and ensure any generation path preserves UTF-8 or native Unicode handling
- If the user asks for `.tex` generation, keep Chinese text in UTF-8, preserve the template engine path, and avoid shell paths that may corrupt Chinese characters before they reach the source file

## Temporary Workspace Rules For File Reading

- When reading `.pdf`, `.doc`, `.docx`, `.ppt`, `.pptx`, `.txt`, `.tex`, `.bib`, `.cls`, `.sty`, or similar files and temporary extraction or conversion artifacts are needed, place them under `C:/Users/18030/Desktop/GPT-files`
- Do not place such temporary files inside the current project folder, repository folder, or the original data folder that contains the source files
- Create clear category folders under `C:/Users/18030/Desktop/GPT-files`, for example `pdf`, `word`, `latex`, `ppt`, `txt`, `images`, `converted`, or `extracted`, and keep each task inside the matching category path
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

## Display And Capture Layer Rules

- Distinguish three layers whenever Chinese output is involved: file bytes, runtime display, and captured or re-read logs
- Do not treat mojibake seen only in a captured terminal transcript, tool panel, redirected log, or copied console text as proof that the live terminal display is broken
- When one layer looks wrong, verify the other layers separately before concluding that the source file or the running program is corrupted
- Prefer wording such as "captured output appears garbled" over "the terminal is garbled" until the live display has been checked directly
- If the live terminal display is correct but a transcript is garbled, classify it as a capture or decode-path problem rather than a file-encoding problem
- When validating Chinese console output, keep evidence for each layer explicit: file encoding check, console encoding check, and capture-path check
- Treat external harness logs, IDE terminal snapshots, redirected stdout files, clipboard text, and copied command output as potentially different decode paths even when they originate from the same command
- If a task includes PowerShell, CMD, Git Bash, Python subprocesses, or agent-run shell commands, assume the display path and the capture path may diverge on Windows until verified
- When reporting findings to the user, state which layer each observation belongs to and avoid upgrading a capture-only symptom into a source-file diagnosis
- If evidence is mixed, stop at the narrowest true statement first, then describe what remains unverified

## PowerShell And Windows Console Verification Rules

- For PowerShell Chinese output checks on Windows, verify at least these four items separately when relevant: script file encoding, explicit read/write encoding, console input or output encoding, and transcript or redirection encoding
- Do not rely on a single terminal screenshot, a single captured transcript, or a single redirected log as the only evidence for overall Chinese-output correctness
- When possible, confirm console behavior with direct Chinese output plus the current values of `[Console]::InputEncoding`, `[Console]::OutputEncoding`, `$OutputEncoding`, and the active code page
- If script files are already correct and live output is correct, do not propose source-file rewrites merely because a tool-collected transcript is garbled
- When using PowerShell to create or rewrite Chinese files, choose and document BOM versus non-BOM intentionally based on downstream compatibility instead of treating it as a universal fix
- For automation chains, prefer explicit UTF-8 settings at file I/O boundaries and treat console rendering as a separate compatibility concern

## Evidence And Reporting Rules

- Report encoding findings in a layered order: first file bytes, then program read or write settings, then live display, then captured logs or copied text
- When a mismatch appears, explain whether the problem is likely in generation, decoding, display, capture, or re-read steps instead of using the generic label "乱码问题"
- If you personally only saw a captured transcript, say so directly and do not claim the user's local terminal is broken unless the user confirms it or direct live evidence shows it
- If the user reports normal local display while a transcript looks garbled, treat the user's direct observation as the stronger signal for the display layer and reclassify the issue toward capture or decode-path analysis

## Copy And Paste Rules

- Do not copy Chinese text from unknown legacy files, old terminals, or editors with unclear encoding directly into new UTF-8 files
- After pasting Chinese content from Word or other rich-text tools, quickly inspect punctuation, full-width characters, and replacement characters before saving
- If visibly corrupted Chinese text is already present in the source, preserve the original source and ask for an authoritative version instead of propagating the corrupted text
