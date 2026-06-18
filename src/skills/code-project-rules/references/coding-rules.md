# Coding Rules

This file mirrors the user's long-term coding requirements for Python projects.

## Scope

Apply these rules when building or restructuring a Python project for the user.

## Project Baseline

- Maintain a complete, directly runnable Python project in the code directory.
- Keep the style simple, clear, and modular.
- Split modules by responsibility, but do not create unnecessary files.
- Required baseline files are `config.py`, `main.py`, `README.md`, and `requirements.txt`.
- `main.py` is the unified entry point.
- Add extra Python files only when they serve a clear responsibility.
- `submission.py` may exist as a standalone regeneration script when the task needs repeated output generation.

## Independent Experiment Rules

- Versioned experiments such as `1.0` to `6.0` must be fully independent.
- Each experiment may only keep code, parameters, functions, and documentation used by the current version.
- Do not reserve interfaces, mode branches, or upgrade hooks for later experiments.
- Each experiment must keep its own `config.py`, `main.py`, `README.md`, and `requirements.txt`.
- Each experiment must write its own functions and its own README.
- Each README must describe only the current experiment and must not mention later versions.
- If remove folders that are not used by the current experiment, do not keep unused directory configuration in `config.py`.

## config.py Rules

- Manage all paths only in `config.py`.
- Define paths near the top of the file after imports.
- Use the names `PROJECT_ROOT`, `DATA_DIR`, `SAVE_DIR`, and `OUT_DIR`.
- Include Chinese comments explaining each path.
- Support code directory, data directory, output directory, model directory, and log directory.
- Provide derived paths such as train file, test file, sample file, best model file, training log file, loss curve file, and submission file when relevant.
- Provide a function to build a config object when the project benefits from it.
- Provide a function that ensures required directories exist.
- If `config.py` is run directly, print the key paths and list file names under valid paths.
- Output file names must also be centralized here.
- In simple experiment projects, configure only the directories, files, and constants actually used by the current experiment.

## main.py And Module Rules

- Every `.py` file must be useful. Do not leave empty placeholder files.
- `main.py` dispatches workflow modes and should not hold too much low-level detail.
- Read paths from `config.py` immediately after imports when needed.
- Keep module relations clear so each script remains maintainable and, when appropriate, independently runnable.
- Prefer structural fixes over temporary patching.

## Simple And Complex Code Rules

- For simple single-experiment code, keep display and output helper functions in `main.py` outside `main()`.
- For simple single-experiment code, keep core calculation, integration, and statistics directly in `main()`, and do not extract them into extra functions when the logic is short and direct.
- When `main()` calls display, plotting, font, or saving helper functions, add concise Chinese comments stating the purpose of the call.
- For complex code, split only the parts with clear independent responsibility, strong reuse value, or excessive length.
- For complex code, extracted functions or modules must still serve only the current project or current experiment, and must not become placeholders for future versions.
- Prefer fewer files and fewer abstraction layers when the code can stay clear without them.

## Import Comment Rules

- When `main.py` imports variables or helper functions from other modules, add concise Chinese inline comments after the imported names.
- Imported constant comments should state the variable meaning and unit when applicable.
- Imported helper function comments should state the function role directly.

## Chinese Comment Rules

- Save comments in UTF-8 without BOM.
- Do not change business logic, variable names, function names, imports, string constants, or execution flow when only adding comments.
- If existing text appears garbled, stop and ask the user instead of guessing an encoding repair.
- Use concise Simplified Chinese comments.
- Each function docstring should include four lines: function, parameters, returns, call location.
- Preserve existing structure, indentation, unrelated comments, and file names.
- Every Python file should begin with a UTF-8 header block that includes developer name, file name, generation time, repeated file name line, and a short Chinese-English function summary.
- Under the user's current long-term convention, the developer line in that header should default to the exact text `开发者: NBT`.
- In that header, use the exact field name `开发时间` instead of `生成时间`.
- The header should keep the repeated file-name line, and should add a separate line in the exact form `版本号：x.x` when the project or experiment version is known.
- The `功能说明` line should use a concrete Chinese functional description tied to the current file and current experiment, such as `功能说明:追踪法允许攻击区分析`；do not keep the old Chinese-English mixed summary on that line unless the current conversation explicitly asks for it.
- For versioned experiment projects, the version number in the header should match the current experiment directory such as `1.0`、`4.2` or `6.4`.
- If the current conversation explicitly requires a different developer signature or a different header format, follow the current conversation instead of forcing the default template.
- When normalizing an existing Python file header, update the developer line, time field name, function-description line, and version line together so the whole header remains internally consistent.

## Typical ML Workflow Rules

Use these only when the task actually includes machine learning.

- Training scripts should read configured dataset paths, validate files and fields, split train and validation data, build tokenizer or dataset objects as needed, run training and validation loops, save the best model, save training logs, save a loss curve, and print key training information.
- Prediction scripts should read configured test data and model paths, validate required files, load the tokenizer and model when needed, run batch prediction, and write a standard output file containing required identifiers and labels.
- `main.py` should support command-line modes such as train only, predict only, and full pipeline when the task needs them.
- Command-line arguments should be able to override defaults such as model name, batch size, epoch count, learning rate, max length, random seed, data directory, model directory, and output directory when these parameters exist.

## README Rules

- Describe the current project purpose and version.
- Explain how to run the whole workflow and where the entry point is.
- Describe the data format used by the program.
- Show the directory layout for code, data, model, and output folders.
- Explain the role of every Python file.
- Explain file-to-file call relationships, key function call relationships, and important global configuration usage.
- Explain the internal execution logic clearly enough that the user can understand how the project works.
- When the project contains an algorithm, describe it in experiment-report style and tie it back to the code.
- Document every output artifact, including figure names, axis meanings, table field meanings, and units when applicable.
- 在与代码位于同一文件夹的 `README.md` 中，如果代码原理部分涉及公式，统一使用 GitHub 可直接渲染的 LaTeX 格式。
- 行内公式使用 `$...$`，独立成行的公式使用 `$$...$$`。
- `README.md` 中不要使用实验报告正文那种“先写渲染公式、下一行再重复 LaTeX 源码”的双行格式。
- 公式写完后仍要写 `其中：`，并逐项解释公式中的变量。
- `README.md` 中的变量解释统一使用 LaTeX 形式，例如 `$k_1$：变量解释。`
- 如果一组连续公式共同描述同一算法流程、同一数值方法或同一推导步骤，可以连续展示整组公式，再在后面统一写一次 `其中：`。
- 变量解释必须覆盖当前公式或当前公式组中的全部关键符号，不得只解释一部分。
- `README.md` 中的公式目标是便于 GitHub 页面直接渲染、直接阅读和直接维护，因此优先使用标准 Markdown 加 LaTeX 写法。

## requirements.txt Rules

- Cover the dependencies actually used by the code.
- Do not leave it as an empty placeholder.

## Delivery Rules

- Final code should run directly once the required runtime and dependencies already exist.
- Imports should be correct.
- Avoid hard-coded relative paths.
- Complete at least a syntax-level check when allowed by the task.
- Keep documentation, configuration, and code aligned.
- Report which files were added or modified, what each file does, where key paths are read from, and example commands that can be executed directly.
- Do not install packages unless the user explicitly asks.
