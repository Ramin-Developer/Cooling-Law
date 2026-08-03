# Cooling-Law

Newton's Cooling Law solver implemented in MATLAB, with both analytical and numerical solutions and comparison support.

## Highlights

- Analytical solution of the cooling ODE.
- Numerical solution using a finite-difference-style discretization.
- Error estimation between numerical and analytical results.
- Planned LaTeX documentation workflow for equations, derivations, and report output.

## Requirements

- MATLAB R2027a.

## Quick Start

1. Open MATLAB in this repository root.
2. Run `run('scripts/ScriptMain.m')`.
3. Optionally run `run('scripts/ScriptAnalyticalSol.m')` for analytical-only flow.

## Repository Layout

- `src/RunCoolingLaw.m`: Orchestration API for analytical + numerical execution.
- `src/GetDefaultCoolingConfig.m`: Centralized default run configuration.
- `scripts/ScriptMain.m`: Main execution entry point.
- `scripts/ScriptAnalyticalSol.m`: Analytical-only entry script.
- `scripts/RunPerformanceBenchmark.m`: Runtime benchmark for solver scaling.
- `src/ProblemConstants.m`: Physical/constants setup helper.
- `src/AnalyticalSol.m`: Analytical model.
- `src/DiffSol.m`: Numerical discretization and solve.
- `src/EstimateError.m`: Error computation.
- `src/PresentData.m`: Plotting/presentation utilities.
- `docs/latex/source/`: Planned LaTeX source location.

## Testing and Validation (Planned)

- Run all tests from repository root:
  - MATLAB command window: `run('scripts/RunAllTests.m')`
  - CLI: `matlab -batch "run(''scripts/RunAllTests.m'')"`
- Current test coverage includes:
  - analytical initial-condition consistency
  - numerical output shape and boundary checks
  - cooling trend sanity check
  - orchestration API result contract
  - coarse-vs-fine convergence trend check

## Documentation (Planned)

LaTeX documentation will be added under `docs/latex/source/`, aligned with your existing template approach.

## Performance

- Run benchmark from repository root:
  - MATLAB command window: `run('scripts/RunPerformanceBenchmark.m')`
  - CLI: `matlab -batch "run(''scripts/RunPerformanceBenchmark.m'')"`
- To enforce threshold guardrails in CI/local checks, set environment variable:
  - `COOLING_ENFORCE_PERF_THRESHOLDS=1`

## Notes

This repository is being modernized incrementally with emphasis on readability, maintainability, performance, and reproducibility.
