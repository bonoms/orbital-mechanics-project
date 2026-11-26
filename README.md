# Orbital Mechanics Lab — Group 2602

MATLAB code for the 2026/27 Orbital Mechanics project lab at Politecnico di Milano. Assignment 1 studies a transfer from Asteroid 1534 to Venus via Mars.

## Run Assignment 1

1. Open `om.prj` in MATLAB.
2. Open [`InterplanetaryMission_group_2602.m`](Code/Assignment1/InterplanetaryMission_group_2602.m) and click **Run**.

The script tests departure, Mars encounter, and Venus arrival dates. It selects the lowest preliminary cost on the grid and plots the two Lambert transfer arcs, the body orbits, and the encounter positions. Dates are in MJD2000 days, flight times are in seconds, and costs are in km/s.

## Submission layout

Include this README alongside `Code/`, with separate `Assignment1/` and `Assignment2/` folders. Keep the main scripts in their assignment folders and supporting code in `functions/`. Each main script should reproduce the submitted results. Include the authors, usage, and input and output dimensions and units in the MATLAB file headers.
