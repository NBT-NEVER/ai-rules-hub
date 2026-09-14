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

## Versioned Project Documentation Rules

When a versioned experiment project uses `README.md`, `improve.md`, and `out/outreadme.md`, keep their responsibilities separate. Do not solve a documentation update by appending a second, conflicting description to an existing document. Reconcile changed facts point by point, preserve still-valid functional descriptions and historical records, and remove only content that has become incorrect or belongs in another document.

### Shared requirements

- All three documents must have a clear title hierarchy and a working Markdown table of contents.
- Use repository-relative links for files and generated artifacts. Verify every link after files are regenerated, moved, renamed, or deleted.
- State paths, units, data sources, version scope, and applicable boundaries explicitly. Do not invent values that are absent from code, logs, or result files.
- Keep code, configuration, commands, output paths, model paths, and documentation mutually consistent.
- Chinese Markdown files must remain UTF-8. Preserve existing useful content during rewrites and keep historical records in chronological order.

### Stable `README.md`

- Treat the version-directory `README.md` as the stable project entry document. Update it when the project version, enduring interface, directory structure, supported workflow, or durable storage convention changes; do not rewrite it for every routine run or regenerated figure.
- Describe the current project purpose and version, environment and dependencies, data format, directory layout, code entry point, executable commands and modes, key file responsibilities, file-to-file relationships, important global configuration, output management, raw/processed data locations, and model-weight locations.
- Give only a concise algorithm overview sufficient to orient a reader. Put complete derivations, per-run metrics, log excerpts, and figure-by-figure result interpretation in `out/outreadme.md`.
- Explain the documentation split and tell readers when `README.md`, `improve.md`, and `out/outreadme.md` are updated.
- Describe only the current version. Do not mention later versions or retain stale commands, parameter ranges, paths, or results as if they were current.

### Append-only `improve.md`

- Treat `improve.md` as an append-only engineering change log. Never delete or silently rewrite earlier records merely because a newer result supersedes them; corrections must be added as a new dated entry that identifies the corrected record.
- Add one consistently formatted entry for each functional optimization or Git implementation commit. Record local date and time, milestone title, corresponding implementation commit hash, modified scope, prior problem, treatment, verified effect, and output impact.
- Derive effects from tests, logs, diffs, or generated results. Distinguish measured effects from expected effects and write `未验证` when evidence is not yet available.
- Avoid circular commit references: create the implementation commit first, then append an entry that cites that implementation hash in a following documentation commit. A documentation-only commit need not create an entry about itself unless it changes project behavior or output.
- Preserve one table of contents and one recording convention section, followed by chronological historical entries. New entries use the established format rather than starting a second change-log structure.

### Run-coupled `out/outreadme.md`

- Treat `out/outreadme.md` as the detailed algorithm and current-output report. Update it whenever any file under `out/` changes, including retraining, reevaluation, data regeneration, file renaming, and small visualization corrections.
- Part A must explain the code background, mathematical formulation, symbols, assumptions, data preprocessing and split policy, data flow, model input and output, complete model structure, algorithm equations, loss and gradient correction, online-update order, hyperparameter selection, stopping conditions, prediction intervals, and relevant implementation links at paper-level rigor.
- Part B must extract a concise, traceable summary from the current log and structured result files: execution status, data scale, selected hyperparameters, training state, evaluation metrics, warnings, failures, and limitations. Never present historical values as current results.
- Part C must enumerate every current table and visualization with repository-relative paths. For each artifact, document its source CSV/JSON/log, title, axes and units, legends or encodings, observed numerical pattern, relevant off-figure values, supported conclusion, and limitations. Embed SVG/GIF where Markdown supports them and link interactive HTML explicitly.
- When an output cannot be committed because of data size, privacy, or model-weight policy, document its expected relative location, generation command, exclusion reason, and the small reproducibility metadata that remains versioned.
- Verify the report against the final output inventory after generation. Broken links, references to deleted PNG files, outdated metrics, and undocumented new artifacts are delivery defects.

### GitHub-renderable formulas in project Markdown

- 在与代码位于同一文件夹的 `README.md` 中，如果代码原理部分涉及公式，统一使用 GitHub 可直接渲染的 LaTeX 格式。
- 行内公式使用 `$...$`，独立成行的公式使用 `$$...$$`。
- `README.md` 中不要使用实验报告正文那种“先写渲染公式、下一行再重复 LaTeX 源码”的双行格式。
- 公式写完后仍要写 `其中：`，并逐项解释公式中的变量。
- `README.md` 中的变量解释统一使用 LaTeX 形式，例如 `$k_1$：变量解释。`
- 如果一组连续公式共同描述同一算法流程、同一数值方法或同一推导步骤，可以连续展示整组公式，再在后面统一写一次 `其中：`。
- 变量解释必须覆盖当前公式或当前公式组中的全部关键符号，不得只解释一部分。
- `README.md` 中的公式目标是便于 GitHub 页面直接渲染、直接阅读和直接维护，因此优先使用标准 Markdown 加 LaTeX 写法。
- 上述公式规则同样适用于 `improve.md` 和 `out/outreadme.md`；其中 `out/outreadme.md` 应承担详细公式推导和变量解释，稳定 `README.md` 只保留算法概览所需公式。

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
