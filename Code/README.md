# Orbital Mechanics assignments

## Course dependencies

Place the complete WeBeep MATLAB functions bundle in a `course/` directory beside `Code/`. Extract `timeConversion.zip` into `course/` so that `course/time/date2mjd2000.m` is present. Alternatively, set the environment variable `OM_WEBEEP_DIR` to an absolute path to the extracted bundle before running the scripts.

## Run in MATLAB

- Assignment 1 starts at `Assignment1/InterplanetaryMission_group_N.m`.
- Assignment 2 starts at `Assignment2/PlanetaryMission_group_N.m`.
- Open the chosen script and click **Run**, or run it by path from the command window. Each script calls `setupOrbitalMechanics` with explicit paths.
- Both assignments are delivered together. Assignment 2 uses the common state conversion and two-body helpers in `Assignment1/functions/shared/`.

## Current status

Assignment 1 has the ephemeris and fixed-leg functions. Enter the group requirements and implement the powered-flyby model, three-date search, reconstruction, and altered flyby case. Assignment 2 has the two-body baseline and ground-track conversion. Enter the assigned orbit and epoch and add the perturbations, Gauss comparison, sensitivity and filtering, and real-satellite analysis.

## Before submission

Replace `N` in the main filenames with the group ID, complete the group inputs, and replace author placeholders. Check that the two scripts regenerate the results in a clean MATLAB session using the setup above. Include this `Code/` directory with both assignments and their analysis inputs. Supply the report and numerical results as required by the course. The WeBeep files are development dependencies kept outside `Code/`.
