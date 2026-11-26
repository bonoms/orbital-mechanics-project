%INTERPLANETARYMISSION_GROUP_2602 Entry script for Assignment 1.
% Authors: .
% Usage: Open om.prj and follow Code/README.md.
% Inputs and outputs: document when the analysis is implemented.



% Example dates in MJD2000 for testing the plot.
% convention used, relative time is in seconds also in teh other functionts
%, but abosolute time is providedi in MJD2000; 


tDep = 50;
tEnc = 520;
tArr = 1300;

[dvMatrix, missionOptimal] = missionOptimizer(40, 60, 510, 520, 1290, 1310, 50, 50, 50);

plotMission(missionOptimal);

