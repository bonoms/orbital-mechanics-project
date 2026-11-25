# Orbital Mechanics MATLAB Project

Open `matlab.toml` as a Project in MATLAB R2026b. The Project adds the student code folders to the path and exposes the two assignment scripts and two baseline checks as shortcuts. Each entry script or check loads the course dependencies when run.

`Code/` follows the course submission structure. See [the code README](Code/README.md) for instructions and current status. The local `course/` bundle and generated `results/` are ignored by Git. Teammates cloning the repository can obtain their own official WeBeep bundle and follow the setup instructions.

Development order

1. Run **Mars Express** to verify the fixed-time Lambert leg.
2. Extend the direct date grid for Chapter 3, then build the powered-flyby evaluator and search for Assignment 1.
3. Run **Planetary baseline** to verify the two-body and ground-track helpers.
4. Add the group's assigned perturbation model and the Cartesian/Gauss comparison for Assignment 2.
