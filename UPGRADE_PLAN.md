# Cooling-Law Upgrade Plan

## Scope
This plan modernizes `Ramin-Developer/Cooling-Law` for readability, maintainability, performance, and testing, while preserving solver behavior.

Target environment: MATLAB R2017a.

## Status
All planned modernization phases and follow-up tasks in this document are complete.

## Progress Snapshot (2026-08-03)

### Completed
- [x] Phase 0.1 README refresh (initial pass complete; see follow-up note below).
- [x] Phase 0.3 `.gitignore` for MATLAB + LaTeX artifacts.
- [x] Phase 1.2 Folder layout introduced:
  - [x] Solver code moved to `src/`
  - [x] Entry scripts moved to `scripts/`
  - [x] Tests in `tests/`
  - [x] LaTeX source folder present in `docs/latex/source/`
- [x] Phase 2.1 Public orchestration function `RunCoolingLaw(config)` returning a results struct.
- [x] Phase 2.2 Centralized configuration with `GetDefaultCoolingConfig`.
- [x] Phase 3.1 MATLAB `matlab.unittest` test class under `tests/`.
- [x] Phase 3.1 Test runner script `scripts/RunAllTests.m`.
- [x] Phase 3.2 Minimum test set coverage including selected analytical points, convergence trend, error-estimator sanity, and regression snapshot.
- [x] Phase 2.3 Logging and deterministic output contract hardening.
- [x] Phase 3.3 GitHub Actions MATLAB workflow with test-result artifact upload.
- [x] Phase 4 Performance profiling and optimization with benchmark guardrails.
- [x] Phase 5 LaTeX documentation integration and build workflow.
- [x] Phase 5.4 Figure-rich report expansion:
  - [x] Create modernization task branch and implementation plan update.
  - [x] Modernize MATLAB figure-generation workflow for report assets.
  - [x] Add discretization and convergence figures for multiple initial conditions and N values.
  - [x] Number and cross-reference key equations and figures in LaTeX.
  - [x] Rebuild PDF and verify references/figures.
- [x] Phase 6.1 MATLAB CLI compatibility hardening:
  - [x] Replace version-specific command examples in README with portable `.cmd` workflows.
  - [x] Add `scripts/RunAllTests.cmd` and `scripts/RunPerformanceBenchmark.cmd` wrappers.
  - [x] Make `scripts/RunMatlabFiguresAndTests.cmd` resolve MATLAB executable from `MATLAB_EXE` or PATH.
- [x] Phase 6.2 R2017a plotting export compatibility:
  - [x] Add `print(..., '-dpdf')` fallback in `src/PresentData.m` when `exportgraphics` is unavailable.
- [x] Phase 6.3 RunCoolingLaw summary contract hardening:
  - [x] Add summary-field and summary final-value consistency assertions in `tests/TestCoolingLaw.m`.
- [x] Phase 6.4 Documentation completion polish:
  - [x] Remove stale "planned" wording and align README test-coverage bullets with implemented tests.

### In Progress
- [x] None.

### Pending
- [x] None.

### Follow-up notes
- README synchronization pass completed for `src/` and `scripts/` paths.
- Remaining naming cleanup is mostly cosmetic consistency across variable names and comments.

## Phase 0 - Foundation (Start Here)

### 0.1 README refresh
- Replace current short README with:
  - project purpose (analytical + numerical Newton cooling solver)
  - MATLAB version target (R2017a)
  - quick start (`ScriptMain.m`)
  - repository structure overview (`src`, `tests`, `docs`)
  - validation/testing commands
  - performance notes
  - future LaTeX documentation location and build notes
- Add one comparison plot preview image (optional) and expected output description.

### 0.2 GitHub About section
Set these in repository About:
- Description: `Newton cooling law solver (analytical + numerical) in MATLAB with LaTeX documentation.`
- Website: (optional docs site/release URL when available)
- Topics: `matlab`, `numerical-methods`, `ode`, `scientific-computing`, `simulation`, `latex`, `heat-transfer`, `cooling-law`

### 0.3 .gitignore for MATLAB + LaTeX
Create `.gitignore` that ignores generated/intermediate files but keeps source and selected artifacts.

Recommended baseline:
- MATLAB: `*.asv`, `*.m~`, `*.mlx.autosave`, `slprj/`, `codegen/`, `*.mex*`, `*.p`, `*.fig.bak`
- LaTeX: `*.aux`, `*.log`, `*.toc`, `*.out`, `*.fls`, `*.fdb_latexmk`, `*.synctex.gz`, `*.bbl`, `*.blg`
- Editor/OS: `.DS_Store`, `Thumbs.db`, `.vscode/*.log`
- Keep tracked deliverables intentionally (for example selected `docs/figures/*.pdf`) using explicit negation rules if needed.

Note: reuse your existing template from `modelling-of-cooling-law/documentation` for docs structure and naming conventions.

## Phase 1 - Project structure and readability

### 1.1 Normalize file/function naming
- Standardize naming style (`AnalyticalSol`, `DiffSol`, etc.) and remove mixed legacy names (`DifferenceSolution`, `AnalyticalSolution`) from scripts.
- Fix typos in comments (`sentral` -> `central`).

### 1.2 Introduce clear folder layout
- Move solver code to `src/`.
- Keep executable entry scripts in `scripts/`.
- Add `tests/` for numerical and regression tests.
- Add `docs/latex/` for report source and outputs.

### 1.3 Improve script clarity
- Add concise headers with inputs/outputs.
- Remove dead/commented code in entry scripts.
- Validate inputs in key routines (`N`, `k`, `tStart`, `tMax`).

## Phase 2 - Maintainability upgrades

### 2.1 Convert script-driven flow into small API
Create one public orchestration function, e.g.:
- `RunCoolingLaw(config)` returning results struct (`time`, `tempExact`, `tempNum`, `error`).

### 2.2 Centralize configuration
- Replace scattered constants with a single config struct and defaults helper.
- Keep `ProblemConstants` as a thin wrapper or deprecate it cleanly.

### 2.3 Logging and result contracts
- Standardize numeric formatting and output messaging.
- Return deterministic outputs for tests (no hidden global state).

## Phase 3 - Testing strategy (MATLAB R2017a)

### 3.1 Test harness
- Use `matlab.unittest` test classes under `tests/`.
- Add a single runner script for local and CI execution.

### 3.2 Minimum test set
- Analytical correctness at selected time points.
- Numerical solution shape and boundary checks.
- Convergence trend check for increasing `N`.
- Error estimator sanity check.
- Regression snapshot for representative parameter set.

### 3.3 CI readiness
- Add GitHub Actions MATLAB workflow (if license/action available).
- Fail build on test failure and store test results artifacts.

## Phase 4 - Performance improvements

### 4.1 Profile first
- Use MATLAB profiler on `DiffSol` and plotting workflow.
- Track baseline runtime for multiple `N` values.

### 4.2 Optimize without changing behavior
- Favor sparse matrix assembly where beneficial.
- Reduce repeated allocations and repeated function-handle evaluations.
- Separate compute path from plotting path so benchmark timings stay clean.

### 4.3 Performance guardrails
- Add a lightweight benchmark script with threshold checks.
- Keep tolerances realistic for developer machines.

## Phase 5 - LaTeX documentation integration

### 5.1 Bring in template structure
- Initialize `docs/latex/` from your existing `modelling-of-cooling-law/documentation` template.
- Keep source in `docs/latex/source/` and outputs in `docs/latex/build/`.

### 5.2 Document implementation and validation
- Include mathematical model, discretization, error estimation, and comparison plots.
- Add reproducibility section mapping code files to equations.

### 5.3 Build workflow
- Add `latexmk` build instructions in README.
- Ensure `.gitignore` excludes temporary TeX build artifacts.

## Execution order and deliverables
1. Foundation update: README + About + `.gitignore`.
2. Structural refactor (`src/`, `scripts/`, naming consistency).
3. API and configuration cleanup.
4. Test suite and CI baseline.
5. Performance profiling and optimizations.
6. LaTeX docs integration and publication-ready report.

## Acceptance criteria
- Clear README with R2017a run/test instructions.
- About metadata completed on GitHub.
- `.gitignore` supports both MATLAB and LaTeX workflows.
- Tests pass locally and in CI.
- Numerical behavior unchanged within tolerance.
- Documentation build reproducible from repository source.
