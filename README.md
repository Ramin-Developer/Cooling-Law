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
2. Run `ScriptMain.m`.
3. Optionally run `ScriptAnalyticalSol.m` for analytical-only flow.

## Repository Layout
- `ScriptMain.m`: Main execution entry point.
- `ScriptAnalyticalSol.m`: Analytical-solution-only script.
- `ProblemConstants.m`: Physical/constants setup.
- `AnalyticalSol.m`: Analytical model.
- `DiffSol.m`: Numerical discretization and solve.
- `EstimateError.m`: Error computation.
- `PresentData.m`: Plotting/presentation utilities.
- `docs/latex/source/`: Planned LaTeX source location.

## Testing and Validation (Planned)
- Add MATLAB `matlab.unittest` test suite under `tests/`.
- Add convergence and regression checks for numerical correctness.
- Add CI execution for smoke tests and unit checks.

## Documentation (Planned)
LaTeX documentation will be added under `docs/latex/source/`, aligned with your existing template approach.

## Notes
This repository is being modernized incrementally with emphasis on readability, maintainability, performance, and reproducibility.
