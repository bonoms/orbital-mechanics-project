%INTERPLANETARYMISSION_GROUP_2602 Main script for the interplanetary mission analysis
%
% DESCRIPTION:
% bla bla
%
% NOTE:
% The example dates are expressed in MJD2000 days, while the transfer
% computations inside the mission functions use relative time in seconds.

depDateMin = 40;
depDateMax = 60;

encDateMin = 510;
encDateMax = 520;

arrDateMin = 1290;
arrDateMax = 1310;


[dvMatrix, dvPork, missionOptimal, dvOptimal] = missionOptimizer(depDateMin, depDateMax, encDateMin,...
                                                encDateMax, arrDateMin, arrDateMax, 50, 50, 50);


%% Plots

figure(1)

plotMission(missionOptimal);

figure(2)

porkChopPlot(dvPork, depDateMin, depDateMax, arrDateMin, arrDateMax);