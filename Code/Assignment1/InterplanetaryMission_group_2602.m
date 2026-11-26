%INTERPLANETARYMISSION_GROUP_2602 Entry script for Assignment 1.
% Authors: .
% Usage: Open om.prj and follow Code/README.md.
% Inputs and outputs: document when the analysis is implemented.



% Example dates in MJD2000 for testing the plot.
tDep = 100;
tEnc = 190;
tArr = 250;

[vtot, mission] = legAssembler(tDep, tEnc, tArr);
plotMission(mission);

