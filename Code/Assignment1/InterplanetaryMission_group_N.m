%INTERPLANETARYMISSION_GROUP_N Entry script for Assignment 1.
% Authors: Lab team (add contributor names before submission).
% Usage: Set the group requirements and run this script.
% Inputs: cfg [scalar struct], body IDs and group windows [MJD2000 days].
% Output: cfg in the workspace. The mission search is still to be implemented.

addpath(fileparts(fileparts(mfilename('fullpath'))));
setupOrbitalMechanics("Assignment1");

cfg.groupId = [];
cfg.asteroidId = [];
cfg.flybyPlanetId = [];
cfg.arrivalPlanetId = [];
cfg.earliestDeparture = [];
cfg.latestArrival = [];
cfg.minFlybyAltitudeKm = [];
cfg.muSun = astroConstants(4);

disp('Assignment 1 setup is ready. Use checkMarsExpress to verify the Lambert leg.');
