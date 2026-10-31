# AGENTS.md

Guidance for AI coding agents working on SALAMANDER. SALAMANDER is a MOOSE-based
scientific application: results must be reproducible, traceable to an issue, and verified
against a documented reference. When in doubt, stop and ask the user.

## Scope and precedence
- For general coding principles (Think Before Coding, Simplicity First, Surgical Changes,
  Code Comments, Code Style, Goal-Driven Execution), follow `moose/AGENTS.md`. This file
  overrides it where the two conflict.
- Work inside the `moose/`, `tmap8/` and `cardinal/` submodules follows that submodule's own
  guidance. Do not change submodule refs without explicit instruction.

## Environment
- Before building or running anything, ask the user whether their MOOSE stack uses conda
  and, if so, which environment to activate. Do not reuse an existing binary or shell state
  as a shortcut around this question.
- If `make`, `./salamander-opt` or `./run_tests` fails, stop and report the full error
  message. Do not work around it.
- Cardinal/OpenMC/NekRS are optional. Ask before assuming they are built. Tests under
  `test/tests/neutronics/` require Cardinal.
- Formatting is enforced by a clang-format pre-commit hook (`scripts/install-format-hook.sh`).
  If the hook is not installed, run `git clang-format` on staged C++ before committing. The
  hook does not check input files: validate them with
  `moose/framework/contrib/hit/hit check <file>.i`.

## Before writing any code or input file
- Browse `src/`, `include/` and `doc/content/` and the relevant MOOSE modules (ray_tracing,
  electromagnetics, heat_transfer, scalar_transport, TMAP8, Cardinal) to find existing
  functionality. Reuse it instead of reimplementing it.
- Documentation can lag the code. Before using an object in an input file, read its C++
  `validParams()` and implementation to confirm it does what you expect.

## C++ code
- Use the SALAMANDER license header (copy it from `src/base/SalamanderApp.C`;
  `scripts/fixup_headers.py` fixes headers).
- Every new object requires (a) a TestHarness test in `test/tests/<category>/` and (b) a
  MooseDocs page in `doc/content/source/<category>/`. Register the object in `SalamanderApp`.
- Never hardcode physical constants or parameters. Use the constants provided by TMAP8, MOOSE, or
  libMesh, or expose the value through `addParam` with its units documented. Code is
  unit-agnostic; units live in input files only.

## Input files
- State the unit system in a comment block at the top of every input file.
- Write parameter values in the units of the cited source and use the MOOSE units system
  (`${units ...}`) to convert.
- Cite the source (DOI, ISBN and page, or report number) of every literature-derived
  parameter and benchmark.
- Run input files with `./salamander-opt -i <file>.i`.

## Testing and SQA
- Every test spec needs `requirement` ("The system shall ..."), `design` (documentation
  page) and `issues`. Follow existing specs such as `test/tests/raybcs/tests`.
- Gold files come only from runs you have verified. Never regenerate gold files or loosen
  tolerances to make a test pass. Explain every tolerance in a nearby comment.
- Verification and validation cases compare against analytical, benchmark or experimental
  references and are documented under `doc/content/verification_validation_examples/`.
- Run tests only when `.C`, `.h` or `test/` files change, and only the affected ones, e.g.
  `./run_tests -j<N> --re <name>`.
- Keep `doc/sqa_salamander.yml` and `doc/content/sqa/` consistent with your changes.

## Issues
- Every session is tied to a GitHub issue on `idaholab/salamander`. Ask the user for the
  issue number at the start of the session if it is not provided.
- When creating an issue with `gh`, read the templates in `.github/ISSUE_TEMPLATE/`, select
  the one that fits (`bug-report.md` or `feature-request.md`) and fill in every section.

## Session logs: never stage or commit
- Do not copy agent session files (Claude Code or Codex `.jsonl` transcripts) into the
  repository. Never stage, commit or push them. They can contain local paths, credentials
  and unrelated content. `*.jsonl` is in `.gitignore`; do not bypass it (no `git add -f`).
- Traceability comes from the issue reference and the AI trailers in each commit.
- Before every commit, check `git status` and `git diff --staged`. Confirm that no session
  files, generated outputs (e.g. `*.e`, `*.csv` or `*.h5` outside `gold/`) or binaries are
  staged. Stage files by name; never use `git add -A` or `git add .`.

## Committing
- Commit at logical checkpoints: each input file that runs, each test that passes or fails,
  each new class.
- If a test or run failed, commit the failure state first (full error message in the commit
  body), then commit the fix separately.
- Every commit message references the issue (`Refs #<issue>` or `Closes #<issue>`) and ends
  with these trailers:
```
Refs #<issue-number>
AI-assisted: true
AI-model: <model name>
AI-version: <model version>
Co-Authored-By: <model name> <noreply@anthropic.com>
```
- Never force-push or rewrite published history without explicit instruction.

## Pull requests
- Branch from and target `devel`, from a fork (see `doc/content/getting_started/contributing.md`).
- If the linked issue already has a complete Reason/Design/Impact, the PR body contains only
  the closing reference (e.g. `Closes #<issue-number>`). Do not duplicate the issue.
- Add a short addendum only for physics or modeling decisions, non-obvious AI reasoning, or
  tests not described in the issue.
- State what was verified (commands and results) and what was not.
- Never merge autonomously.

## Never do
- Modify existing passing tests or gold files, or the build system (`Makefile`, `config/`),
  without explicit user instruction.
- Make physics, modeling or numerical-scheme decisions (e.g. particle steppers, collision
  models, tolerances) without flagging them to the user.
- Suppress, skip or bypass test failures, or report unverified results as verified.
- Commit session logs, large binaries or generated outputs.
